Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2C4C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E642312A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbhAMAmr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390132AbhALXoB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EE1C23120;
        Tue, 12 Jan 2021 23:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495000;
        bh=hrYX6BOFDTUN+j6h7Rhlj8aK7dKLvNcHoPI4hv3vV1U=;
        h=Date:From:To:Subject:From;
        b=bjXLO9MinOlBRvr92uXpg5RPfMh7mgmvRbKotkhOChFdcs6/ZQHxxh/zk5LBIsMpy
         Rc/TdD/Dn8SPnhLM3NQmwdFOdme0IGNY6Aiv8TSLZjESwiEPulB4iKgBQcKtmarW8J
         b0yrLVdEQrOxO6CVxPWd/LfqlKbbAiVtiAjQ8pns=
Date:   Tue, 12 Jan 2021 15:43:19 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liu.hailong6@zte.com.cn,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
 removed from -mm tree
Message-ID: <20210112234319.WdaGNltzA%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.p=
atch

This patch was dropped because it was folded into mm-page_alloc-add-a-missi=
ng-mm_page_alloc_zone_locked-tracepoint.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-f=
ix

use IS_ENABLED() to suppress warning

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

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint.patch
mm-process_vm_accessc-include-compath.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fi=
x.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fix=
es.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

