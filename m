Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56D3C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 03:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiA0DN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 22:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiA0DN4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 22:13:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE391C06161C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 19:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A2046173C
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 03:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902F9C340E7;
        Thu, 27 Jan 2022 03:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643253235;
        bh=4a7axO7SExOQ+jpUB089A6Cma136pOYQYKwPlniXFzc=;
        h=Date:From:To:Subject:From;
        b=lFVhr5Od04lqiILSPCwRzAgaX/M2Gx2kR3jqi+GyzWB0o6EkXFp8RlY7IabuCmCs1
         ywUxBiOjQTNWkijZ39CXQW8fzRB+VwAyqLueh1kXTr7GdSa9kOIYtdQ2Eg9PF2b7Xl
         s9A1C3u4mlAVQ/T9Y5ZxiLRWQBrn3EHDGrBT8ceM=
Date:   Wed, 26 Jan 2022 19:13:55 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete]
 arch-x86-include-asm-pgtableh-needs-spinlockh.patch removed from -mm tree
Message-ID: <20220127031355.ruPU2Si2Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/include/asm/pgtable.h needs spinlock.h
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-pgtableh-needs-spinlockh.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/include/asm/pgtable.h needs spinlock.h

In file included from ./include/linux/pgtable.h:6,
                 from ./include/linux/kasan.h:30,
                 from mm/kasan/common.c:14:
./arch/x86/include/asm/pgtable.h:56:8: error: unknown type name 'spinlock_t'
   56 | extern spinlock_t pgd_lock;
      |        ^~~~~~~~~~


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    1 +
 mm/kasan/common.c              |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/include/asm/pgtable.h~arch-x86-include-asm-pgtableh-needs-spinlockh
+++ a/arch/x86/include/asm/pgtable.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_PGTABLE_H
 
 #include <linux/mem_encrypt.h>
+#include <linux/spinlock.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
 
--- a/mm/kasan/common.c~arch-x86-include-asm-pgtableh-needs-spinlockh
+++ a/mm/kasan/common.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/linkage.h>
 #include <linux/memblock.h>
+#include <linux/spinlock.h>
 #include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

