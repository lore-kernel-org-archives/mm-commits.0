Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01A7C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA0BF22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630506;
	bh=Rxs96eS4tXVcmHucJT5iyuriKrRtGW7C4XZdo6Zw6x8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JBaod5Gnm7P3Zyt/LMWdSx1FLfrl2MyRHxFhe69P1Zau8PMGnqA0YQmzdR7kOI16/
	 bfKwDsYyJTeirulENXAwYI8nHBChHKL+B/mztvv7mLunNgc1qLwbA5fWvdrV7/Hci8
	 PGOI2pTBos5ITItoTXPCCBNfs+d1rxDzHfk/Rdrw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgJMXI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXI0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:08:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D4521D40;
        Tue, 13 Oct 2020 23:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630504;
        bh=Rxs96eS4tXVcmHucJT5iyuriKrRtGW7C4XZdo6Zw6x8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gdFkDYJ3qPv76izOs/DOKXRwISsCm1JrCaOpW12qY7x/jGHmmDvuTYi0XwCVx9Q0B
         N8NErFM5ICMwd4MXgN/ubPE5+Aln4vMfIj1gU7ecFJplgfSDoNeukICYKBvsIJ/+Z0
         Krk5wRhEb1JDhqYkXV87sAC5uKxLfxhxa16Yhpz8=
Date:   Tue, 13 Oct 2020 16:08:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, sfr@canb.auug.org.au,
        song.bao.hua@hisilicon.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-gup-dont-permit-users-to-call-get=5Fuser=5Fpages-with-fol?=
 =?US-ASCII?Q?l=5Flongterm-fix.patch?= removed from -mm tree
Message-ID: <20201013230824.oKEU_Say6%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch

This patch was dropped because it was folded into mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix

fix CONFIG_MMU=n build

Link: https://lkml.kernel.org/r/CA+G9fYuNS3k0DVT62twfV746pfNhCSrk5sVMcOcQ1PGGnEseyw@mail.gmail.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/gup.c~mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix
+++ a/mm/gup.c
@@ -1747,6 +1747,25 @@ static __always_inline long __gup_longte
 }
 #endif /* CONFIG_FS_DAX || CONFIG_CMA */
 
+static bool is_valid_gup_flags(unsigned int gup_flags)
+{
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
+	 * never directly by the caller, so enforce that with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return false;
+	/*
+	 * FOLL_PIN is a prerequisite to FOLL_LONGTERM. Another way of saying
+	 * that is, FOLL_LONGTERM is a specific case, more restrictive case of
+	 * FOLL_PIN.
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_MMU
 static long __get_user_pages_remote(struct mm_struct *mm,
 				    unsigned long start, unsigned long nr_pages,
@@ -1777,25 +1796,6 @@ static long __get_user_pages_remote(stru
 				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 
-static bool is_valid_gup_flags(unsigned int gup_flags)
-{
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that with an assertion:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
-		return false;
-	/*
-	 * FOLL_PIN is a prerequisite to FOLL_LONGTERM. Another way of saying
-	 * that is, FOLL_LONGTERM is a specific case, more restrictive case of
-	 * FOLL_PIN.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return false;
-
-	return true;
-}
-
 /**
  * get_user_pages_remote() - pin user pages in memory
  * @mm:		mm_struct of target mm
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

