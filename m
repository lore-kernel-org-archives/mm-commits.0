Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B144FC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 03:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiB1D1F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 22:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiB1D1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 22:27:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F1853718
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 19:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 824FA60F2F
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 03:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC33C340E9;
        Mon, 28 Feb 2022 03:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646018785;
        bh=L/pTO3GKFTFcBA4PF0OMkPPNu8eD903AYOL6+8DOhxU=;
        h=Date:To:From:Subject:From;
        b=L8gw8K6tj0LkpmpBpIdYegIWpkZAyGTbXz+GATzdo/68V2OBqrdieCs3Ye1971Qzv
         uN4b4TIQmlL6qWgmZXmLbDdCTaX3wBX5zx3VQ9JDRVojqBgb2/H3+3YtzfGukDzCwI
         kS617TQDjNs3JtknzoSDuHyJW/FpVoDYxnTm2Om8=
Date:   Sun, 27 Feb 2022 19:26:25 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-x86-kernel-resourcec-needs-spinlockh.patch added to -mm tree
Message-Id: <20220228032625.CFC33C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/resource.c: needs spinlock.h
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-resourcec-needs-spinlockh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-x86-kernel-resourcec-needs-spinlockh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-kernel-resourcec-needs-spinlockh.patch

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
Subject: arch/x86/kernel/resource.c: needs spinlock.h

fix recent breaking in -next.  x86_64 allnoconfig.

In file included from arch/x86/kernel/resource.c:4:
./arch/x86/include/asm/pci_x86.h:105:8: error: unknown type name 'raw_spinlock_t'
  105 | extern raw_spinlock_t pci_config_lock;
      |        ^~~~~~~~~~~~~~

am too lazy to hunt down the offending commit.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/resource.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/resource.c~arch-x86-kernel-resourcec-needs-spinlockh
+++ a/arch/x86/kernel/resource.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/ioport.h>
+#include <linux/spinlock.h>
 #include <asm/e820/api.h>
 #include <asm/pci_x86.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

