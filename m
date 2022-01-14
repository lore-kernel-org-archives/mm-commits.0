Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC72C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiANWJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38266 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52357CE24A4
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B071C36AE9;
        Fri, 14 Jan 2022 22:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198178;
        bh=w7pxM9LCTRt/1PblGv0j5a5eklnr95NNigWSslQVvdU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q1hTNVQXqpwrKRnOLbplTzfNpqQYRUtK48rIcthVqyif2neaGYHYZhRZomc21gHvh
         IM2rszrOK78hTBzlTryIBkO7eM+kNxFcWP/5EZwELRAYh8GWHC0c2SPbc4eSggr128
         lHdFTch9X/O8DF3ZlsLzC14g+LPyzdllHPBAVF2Y=
Date:   Fri, 14 Jan 2022 14:09:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        xhao@linux.alibaba.com
Subject:  [patch 122/146] mm/damon: add 'age' of region tracepoint
 support
Message-ID: <20220114220937.or_UptqWt%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
