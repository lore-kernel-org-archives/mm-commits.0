Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0077AC4321E
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B516349A
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240992AbhKOSRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240804AbhKOSNs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB906633C9;
        Mon, 15 Nov 2021 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998514;
        bh=UF2pxQWSduMft0xOCdp+R66AHCugAa7FwB9p1eIbadw=;
        h=Date:From:To:Subject:From;
        b=bnxqATn8F0NzSvV1Juq0wk+gNjaIz4rvRedOXqrtUWCGOAQ6t2rOqXBg45jFvMY98
         z1OlYAflVwx7mQsviZPEdWm6Ixc6iWLLozKo+ecEC7c7C8hO4ejfFdw6l3B2k2wMmH
         VlWiFQV3tJB/w48Plx1hJVxQOvimWNudmfwFY1KM=
Date:   Mon, 15 Nov 2021 09:48:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  + mm-damon-add-age-of-region-tracepoint-support.patch
 added to -mm tree
Message-ID: <20211115174833.d3p7k2klS%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-damon-add-age-of-region-tracepoint-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-add-age-of-region-tr=
acepoint-support.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-add-age-of-region-tr=
acepoint-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Fixes: 2fcb93629ad8 ("mm/damon: add a tracepoint")
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
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

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

