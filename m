Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F90C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A5A61179
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhDIFhs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233153AbhDIFhs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA1A61165;
        Fri,  9 Apr 2021 05:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617946656;
        bh=7vLI5pHgMmv5LxUG5v6h6eFyj0WoSFusvOj2tmRSJj8=;
        h=Date:From:To:Subject:From;
        b=blWibNsyJDnfGbrqfR8NWpKdEZpHYT9AtU7R3THZFHEID3BGoixVlm1/gobLwYjPP
         4YwFuCi6UvGXqMsTlx7Mmk3M7Gyky7+lMPjLrB3aX+IU1meoD4AtkHl0eyX02SnHyj
         VCTWOUbimLWUiQrkgWU2zP26JeEY/2gCLVnPYqMk=
Date:   Thu, 08 Apr 2021 22:37:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  + kernelh-split-out-panic-and-oops-helpers-fix.patch
 added to -mm tree
Message-ID: <20210409053735.vZ81PYZ8Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernelh-split-out-panic-and-oops-helpers-fix
has been added to the -mm tree.  Its filename is
     kernelh-split-out-panic-and-oops-helpers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-split-out-panic-and-oops-helpers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-split-out-panic-and-oops-helpers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernelh-split-out-panic-and-oops-helpers-fix

more files need panic_notifier.h

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c        |    1 +
 drivers/video/fbdev/hyperv_fb.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/xen/enlighten.c~kernelh-split-out-panic-and-oops-helpers-fix
+++ a/arch/x86/xen/enlighten.c
@@ -6,6 +6,7 @@
 #include <linux/cpu.h>
 #include <linux/kexec.h>
 #include <linux/slab.h>
+#include <linux/panic_notifier.h>
 
 #include <xen/xen.h>
 #include <xen/features.h>
--- a/drivers/video/fbdev/hyperv_fb.c~kernelh-split-out-panic-and-oops-helpers-fix
+++ a/drivers/video/fbdev/hyperv_fb.c
@@ -52,6 +52,7 @@
 #include <linux/completion.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+#include <linux/panic_notifier.h>
 #include <linux/efi.h>
 #include <linux/console.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

