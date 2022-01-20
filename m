Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54238C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377890AbiATV2T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377888AbiATV2T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B223C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED59AB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EFEC340E0;
        Thu, 20 Jan 2022 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714096;
        bh=7+sBzVldaej5nkpzGCnBX2lcqIH0FrEhP2G0xnTtRsg=;
        h=Date:From:To:Subject:From;
        b=p49D0V6zTM+Nu6h1X3jPqULvLTfs80fg/ojoY1suulFNoytdYF/O+6f54WuXQmWPI
         Mh1hYMIAe58wx+/+HqVCHL40t86L1E3fMYXMBmCI1vTM+MVG/wQMBHUZgoS3WP4q6t
         YCdgrDxnNXIB9FdlHBVM0bi8jjfb5gQG9VFRWe0E=
Date:   Thu, 20 Jan 2022 13:28:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-add-age-of-region-tracepoint-support.patch removed from -mm tree
Message-ID: <20220120212816.dzYLNzyLJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: add 'age' of region tracepoint support
has been removed from the -mm tree.  Its filename was
     mm-damon-add-age-of-region-tracepoint-support.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: add 'age' of region tracepoint support

In Damon, we can get age information by analyzing the nr_access change,
But short time sampling is not effective, we have to obtain enough data
for analysis through long time trace, this also means that we need to
consume more cpu resources and storage space.

Now the region add a new 'age' variable, we only need to get the change of
age value through a little time trace, for example, age has been
increasing to 141, but nr_access shows a value of 0 at the same time,
Through this=EF=BC=8Cwe can conclude that the region has a very low nr_acce=
ss
value for a long time.

Link: https://lkml.kernel.org/r/b9def1262af95e0dc1d0caea447886434db01161.16=
36989871.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/trace/events/damon.h~mm-damon-add-age-of-region-tracepoint-su=
pport
+++ a/include/trace/events/damon.h
@@ -22,6 +22,7 @@ TRACE_EVENT(damon_aggregated,
 		__field(unsigned long, start)
 		__field(unsigned long, end)
 		__field(unsigned int, nr_accesses)
+		__field(unsigned int, age)
 	),
=20
 	TP_fast_assign(
@@ -30,11 +31,13 @@ TRACE_EVENT(damon_aggregated,
 		__entry->start =3D r->ar.start;
 		__entry->end =3D r->ar.end;
 		__entry->nr_accesses =3D r->nr_accesses;
+		__entry->age =3D r->age;
 	),
=20
-	TP_printk("target_id=3D%lu nr_regions=3D%u %lu-%lu: %u",
+	TP_printk("target_id=3D%lu nr_regions=3D%u %lu-%lu: %u %u",
 			__entry->target_id, __entry->nr_regions,
-			__entry->start, __entry->end, __entry->nr_accesses)
+			__entry->start, __entry->end,
+			__entry->nr_accesses, __entry->age)
 );
=20
 #endif /* _TRACE_DAMON_H */
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


