Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D488DC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 20:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbiCIUpm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 15:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiCIUpm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 15:45:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E610660DB9
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 12:44:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A26B61A1D
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 20:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACAAC340E8;
        Wed,  9 Mar 2022 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646858680;
        bh=5VxZXqmdSpBHKExqsZ0wW8iHJm5AqmT7Za9qzOZdoi4=;
        h=Date:To:From:Subject:From;
        b=2vxGMhxXyRB1B7u3O8PQJ74ljEvWkTWsxw1rAru7m5M5oaDqMJsiA2uDoda49v8Xy
         22iNNzdBR/qaAYsdLgnAH3yc2XIqrjsx/k/0PM9UQ1fg3AmAwUki2Lay/7iQAEzBvf
         r9WRyFJ2nQB4GSfhGAU1rJZpZ+75IcgJeqwnCKtE=
Date:   Wed, 09 Mar 2022 12:44:40 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] arch-x86-kernel-resourcec-needs-spinlockh.patch removed from -mm tree
Message-Id: <20220309204440.DACAAC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/resource.c: needs spinlock.h
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-resourcec-needs-spinlockh.patch

This patch was dropped because an alternative patch was merged

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

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

