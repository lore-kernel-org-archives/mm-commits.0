Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6BCC388F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59712242C
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451450;
	bh=hvGA/x5cpDgHpu7l0kspZsyKNhcX/dli6+2/mNUknIU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tQbhs/gndcdtCEESDXv/joxrFbagqGfw23MPCwkEnY5y+LOJwma7g5mD+RkjcS+Kf
	 fvh+2H4GWS4JHZPqxz2sqpQ543vE/mTMuAURFY2zfuqB+KYZB2IUm0IsQWXyrzXpl2
	 lGxDyy4YwfKE7LtGTaPibvRoJ6PneSeEPDqSxFS0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgKDA5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgKDA5a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:57:30 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A0D22403;
        Wed,  4 Nov 2020 00:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451449;
        bh=hvGA/x5cpDgHpu7l0kspZsyKNhcX/dli6+2/mNUknIU=;
        h=Date:From:To:Subject:From;
        b=NN8rhQjKLoSC/lvNagecrsUmlYh3InSKwDNEXanMGZ2PV479aIfgpbC2AIDZ9lzJG
         7CfNgGBd8ZnjDv/VduE36a5NcQO/wzqY19gsi5cLI395h6x4FA14s02JCIQGcJzqe0
         B/DyOtf+Jp/Eu10qmfulqLR4ycDdDNQXyixSUztU=
Date:   Tue, 03 Nov 2020 16:57:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net, rientjes@google.com, rick.p.edgecombe@intel.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        penberg@kernel.org, pavel@ucw.cz, paul.walmsley@sifive.com,
        paulus@samba.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, len.brown@intel.com,
        kirill.shutemov@linux.intel.com, iamjoonsoo.kim@lge.com,
        hpa@zytor.com, hca@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, davem@davemloft.net, dave.hansen@linux.intel.com,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@de.ibm.com, benh@kernel.crashing.org,
        aou@eecs.berkeley.edu, rppt@linux.ibm.com
Subject:  +
 pm-hibernate-make-direct-map-manipulations-more-explicit.patch added to -mm
 tree
Message-ID: <20201104005727.AKQEx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: PM: hibernate: make direct map manipulations more explicit
has been added to the -mm tree.  Its filename is
     pm-hibernate-make-direct-map-manipulations-more-explicit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/pm-hibernate-make-direct-map-manipulations-more-explicit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/pm-hibernate-make-direct-map-manipulations-more-explicit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: PM: hibernate: make direct map manipulations more explicit

When DEBUG_PAGEALLOC or ARCH_HAS_SET_DIRECT_MAP is enabled a page may be
not present in the direct map and has to be explicitly mapped before it
could be copied.

Introduce hibernate_map_page() that will explicitly use
set_direct_map_{default,invalid}_noflush() for ARCH_HAS_SET_DIRECT_MAP
case and debug_pagealloc_map_pages() for DEBUG_PAGEALLOC case.

The remapping of the pages in safe_copy_page() presumes that it only
changes protection bits in an existing PTE and so it is safe to ignore
return value of set_direct_map_{default,invalid}_noflush().

Still, add a pr_warn() so that future changes in set_memory APIs will not
silently break hibernation.

Link: https://lkml.kernel.org/r/20201103162057.22916-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |   12 ------------
 kernel/power/snapshot.c |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~pm-hibernate-make-direct-map-manipulations-more-explicit
+++ a/include/linux/mm.h
@@ -2915,16 +2915,6 @@ static inline bool debug_pagealloc_enabl
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
 extern void __kernel_map_pages(struct page *page, int numpages, int enable);
 
-/*
- * When called in DEBUG_PAGEALLOC context, the call should most likely be
- * guarded by debug_pagealloc_enabled() or debug_pagealloc_enabled_static()
- */
-static inline void
-kernel_map_pages(struct page *page, int numpages, int enable)
-{
-	__kernel_map_pages(page, numpages, enable);
-}
-
 static inline void debug_pagealloc_map_pages(struct page *page,
 					     int numpages, int enable)
 {
@@ -2936,8 +2926,6 @@ static inline void debug_pagealloc_map_p
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
 #else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
-static inline void
-kernel_map_pages(struct page *page, int numpages, int enable) {}
 static inline void debug_pagealloc_map_pages(struct page *page,
 					     int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
--- a/kernel/power/snapshot.c~pm-hibernate-make-direct-map-manipulations-more-explicit
+++ a/kernel/power/snapshot.c
@@ -76,6 +76,34 @@ static inline void hibernate_restore_pro
 static inline void hibernate_restore_unprotect_page(void *page_address) {}
 #endif /* CONFIG_STRICT_KERNEL_RWX  && CONFIG_ARCH_HAS_SET_MEMORY */
 
+static inline void hibernate_map_page(struct page *page, int enable)
+{
+	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
+		unsigned long addr = (unsigned long)page_address(page);
+		int ret;
+
+		/*
+		 * This should not fail because remapping a page here means
+		 * that we only update protection bits in an existing PTE.
+		 * It is still worth to have a warning here if something
+		 * changes and this will no longer be the case.
+		 */
+		if (enable)
+			ret = set_direct_map_default_noflush(page);
+		else
+			ret = set_direct_map_invalid_noflush(page);
+
+		if (ret) {
+			pr_warn_once("Failed to remap page\n");
+			return;
+		}
+
+		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	} else {
+		debug_pagealloc_map_pages(page, 1, enable);
+	}
+}
+
 static int swsusp_page_is_free(struct page *);
 static void swsusp_set_page_forbidden(struct page *);
 static void swsusp_unset_page_forbidden(struct page *);
@@ -1355,9 +1383,9 @@ static void safe_copy_page(void *dst, st
 	if (kernel_page_present(s_page)) {
 		do_copy_page(dst, page_address(s_page));
 	} else {
-		kernel_map_pages(s_page, 1, 1);
+		hibernate_map_page(s_page, 1);
 		do_copy_page(dst, page_address(s_page));
-		kernel_map_pages(s_page, 1, 0);
+		hibernate_map_page(s_page, 0);
 	}
 }
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch

