Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C2CA0EC6
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbjIKWWv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244025AbjIKSrJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:47:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DAE1AD
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:47:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79A4C433C8;
        Mon, 11 Sep 2023 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694458023;
        bh=tKu5a9Vpc19RX++0VPswaemAuAvIFwBKG88ilWQ4P7w=;
        h=Date:To:From:Subject:From;
        b=xSHzqdlc2d4Udno5bFeNs9p1oPfJtLWa5oDVTP7BFRLgK+TNvzYo5kfF7oxG1hgwn
         obRBwycWY+lCsHV/YVTCxTI6o3galqUOltLSxnQ0d3W23VIjHyRShud9ZE8NoBrm4Y
         Lfqs4sOcSX46K7FSrfl4KlRPVPal5TXgSD4pFO6Q=
Date:   Mon, 11 Sep 2023 11:47:03 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, vbabka@suse.cz,
        thomas.lendacky@amd.com, rppt@linux.ibm.com, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, dyoung@redhat.com,
        dave.hansen@intel.com, bp@alien8.de, bhe@redhat.com,
        ardb@kernel.org, adrian.hunter@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch added to mm-unstable branch
Message-Id: <20230911184703.C79A4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: efi/unaccepted: do not let /proc/vmcore try to access unaccepted memory
has been added to the -mm mm-unstable branch.  Its filename is
     efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch

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
From: Adrian Hunter <adrian.hunter@intel.com>
Subject: efi/unaccepted: do not let /proc/vmcore try to access unaccepted memory
Date: Mon, 11 Sep 2023 14:21:13 +0300

Patch series "Do not try to access unaccepted memory", v2.

Support for unaccepted memory was added recently, refer commit
dcdfdd40fa82 ("mm: Add support for unaccepted memory"), whereby
a virtual machine may need to accept memory before it can be used.

Plug a few gaps where RAM is exposed without checking if it is
unaccepted memory.


This patch (of 2):

Support for unaccepted memory was added recently, refer commit
dcdfdd40fa82 ("mm: Add support for unaccepted memory"), whereby a virtual
machine may need to accept memory before it can be used.

Do not let /proc/vmcore try to access unaccepted memory because it can
cause the guest to fail.

For /proc/vmcore, which is read-only, this means a read or mmap of
unaccepted memory will return zeros.

Link: https://lkml.kernel.org/r/20230911112114.91323-1-adrian.hunter@intel.com
Link: https://lkml.kernel.org/r/20230911112114.91323-2-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/unaccepted_memory.c |   20 ++++++++++++++++++++
 include/linux/mm.h                       |    7 +++++++
 2 files changed, 27 insertions(+)

--- a/drivers/firmware/efi/unaccepted_memory.c~efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory
+++ a/drivers/firmware/efi/unaccepted_memory.c
@@ -3,6 +3,7 @@
 #include <linux/efi.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
+#include <linux/crash_dump.h>
 #include <asm/unaccepted_memory.h>
 
 /* Protects unaccepted memory bitmap */
@@ -145,3 +146,22 @@ bool range_contains_unaccepted_memory(ph
 
 	return ret;
 }
+
+#ifdef CONFIG_PROC_VMCORE
+static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
+						unsigned long pfn)
+{
+	return !pfn_is_unaccepted_memory(pfn);
+}
+
+static struct vmcore_cb vmcore_cb = {
+	.pfn_is_ram = unaccepted_memory_vmcore_pfn_is_ram,
+};
+
+static int __init unaccepted_memory_init_kdump(void)
+{
+	register_vmcore_cb(&vmcore_cb);
+	return 0;
+}
+core_initcall(unaccepted_memory_init_kdump);
+#endif /* CONFIG_PROC_VMCORE */
--- a/include/linux/mm.h~efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory
+++ a/include/linux/mm.h
@@ -4055,4 +4055,11 @@ static inline void accept_memory(phys_ad
 
 #endif
 
+static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
+{
+	phys_addr_t paddr = pfn << PAGE_SHIFT;
+
+	return range_contains_unaccepted_memory(paddr, paddr + PAGE_SIZE);
+}
+
 #endif /* _LINUX_MM_H */
_

Patches currently in -mm which might be from adrian.hunter@intel.com are

efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch
proc-kcore-do-not-try-to-access-unaccepted-memory.patch

