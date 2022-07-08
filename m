Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F60C43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 23:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiGHXGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238153AbiGHXGu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 19:06:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2933C151
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 16:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28339B82A16
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 23:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9B7C341C0;
        Fri,  8 Jul 2022 23:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657321606;
        bh=mM7dzLaiFWnY9XzitsQQVTUWCM8B09a5JliHRdDPYRc=;
        h=Date:To:From:Subject:From;
        b=HvWBkyDlLGzeECbFNDYcBBC23FvSEfVXmnR2sWFgUDY/BMvDMkScEcsauY/yAHSQF
         Q8MQr2NzBppc5ofCnyQvXGFboc+uyJUXqTIVFo8ETEd5iN+J1VmzBTTVYaVyvHnHde
         HZfsLLS3hAdtK5qU107RGQwiF/OVeBa6NvFO0jO0=
Date:   Fri, 08 Jul 2022 16:06:46 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        lkp@intel.com, hch@lst.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-move-protection_map-inside-the-platform-fix.patch added to mm-unstable branch
Message-Id: <20220708230646.CA9B7C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-move-protection_map-inside-the-platform-fix
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-move-protection_map-inside-the-platform-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-move-protection_map-inside-the-platform-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-mm-move-protection_map-inside-the-platform-fix
Date: Sat Jul  2 01:22:52 PM PDT 2022

fix "no previous prototype for add_encrypt_protection_map"

Reported-by: kernel test robot <lkp@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mem_encrypt.h |    2 ++
 arch/x86/mm/mem_encrypt_amd.c      |    3 +--
 arch/x86/mm/pgprot.c               |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/mem_encrypt.h~x86-mm-move-protection_map-inside-the-platform-fix
+++ a/arch/x86/include/asm/mem_encrypt.h
@@ -89,6 +89,8 @@ static inline void mem_encrypt_free_decr
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_init(void);
 
+void add_encrypt_protection_map(void);
+
 /*
  * The __sme_pa() and __sme_pa_nodebug() macros are meant for use when
  * writing to or comparing values from the cr3 register.  Having the
--- a/arch/x86/mm/mem_encrypt_amd.c~x86-mm-move-protection_map-inside-the-platform-fix
+++ a/arch/x86/mm/mem_encrypt_amd.c
@@ -26,6 +26,7 @@
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 #include <asm/setup.h>
+#include <asm/mem_encrypt.h>
 #include <asm/bootparam.h>
 #include <asm/set_memory.h>
 #include <asm/cacheflush.h>
@@ -484,8 +485,6 @@ void __init early_set_mem_enc_dec_hyperc
 	enc_dec_hypercall(vaddr, npages, enc);
 }
 
-void add_encrypt_protection_map(void);
-
 void __init sme_early_init(void)
 {
 	if (!sme_me_mask)
--- a/arch/x86/mm/pgprot.c~x86-mm-move-protection_map-inside-the-platform-fix
+++ a/arch/x86/mm/pgprot.c
@@ -3,6 +3,7 @@
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <asm/pgtable.h>
+#include <asm/mem_encrypt.h>
 
 static pgprot_t protection_map[16] __ro_after_init = {
 	[VM_NONE]					= PAGE_NONE,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
x86-mm-move-protection_map-inside-the-platform-fix.patch

