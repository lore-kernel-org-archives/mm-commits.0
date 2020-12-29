Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D51EC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC92321D1B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgL2VVz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 16:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgL2VVz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 16:21:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ACC620727;
        Tue, 29 Dec 2020 21:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609276874;
        bh=TxBgWJTNdApLC92mTI27p7Y6LJoi3LupR5Nx2qxqOqo=;
        h=Date:From:To:Subject:From;
        b=C/YyV50egeR7x1IiMPr6uMqiBvakmEqy9RpkOIDf5gS1gr697JdBOwVUyOQoue6Ig
         b25GN2HqFeEgEwp/0TMb72Za0zlIg6NIAFF6bbjLccvoyA0/hRGdX407krAp1k6cFO
         188DafpWYT6tP0Th8EDsX4FT5PLRiXWOCcHC6JJ8=
Date:   Tue, 29 Dec 2020 13:21:14 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liu.hailong6@zte.com.cn,
        mm-commits@vger.kernel.org
Subject:  +
 mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
 added to -mm tree
Message-ID: <20201229212114.jbvVbJ8rJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepo=
int-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.p=
atch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-a-missing-m=
m_page_alloc_zone_locked-tracepoint-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-a-missing-m=
m_page_alloc_zone_locked-tracepoint-fix.patch

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
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-f=
ix

use IS_ANABLED() to suppress warning

mm/page_alloc.c: In function =E2=80=98__rmqueue=E2=80=99:
mm/page_alloc.c:2889:1: warning: label =E2=80=98out=E2=80=99 defined but no=
t used [-Wunused-label]
 out:
 ^~~

Cc: Hailong liu <liu.hailong6@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked=
-tracepoint-fix
+++ a/mm/page_alloc.c
@@ -2862,20 +2862,20 @@ __rmqueue(struct zone *zone, unsigned in
 {
 	struct page *page;
=20
-#ifdef CONFIG_CMA
-	/*
-	 * Balance movable allocations between regular and CMA areas by
-	 * allocating from CMA when over half of the zone's free memory
-	 * is in the CMA area.
-	 */
-	if (alloc_flags & ALLOC_CMA &&
-	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
-	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
-		page =3D __rmqueue_cma_fallback(zone, order);
-		if (page)
-			goto out;
+	if (IS_ENABLED(CONFIG_CMA)) {
+		/*
+		 * Balance movable allocations between regular and CMA areas by
+		 * allocating from CMA when over half of the zone's free memory
+		 * is in the CMA area.
+		 */
+		if (alloc_flags & ALLOC_CMA &&
+		    zone_page_state(zone, NR_FREE_CMA_PAGES) >
+		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
+			page =3D __rmqueue_cma_fallback(zone, order);
+			if (page)
+				goto out;
+		}
 	}
-#endif
 retry:
 	page =3D __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch
mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fi=
x.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fix=
es.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-=
fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

