Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE17AE7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjJDUTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbjJDUS7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05555BF
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6E4C433C7;
        Wed,  4 Oct 2023 20:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450735;
        bh=kIxoF9oqHpd14LdNN4tfn7Ts04cAPNNqoRletQcurRI=;
        h=Date:To:From:Subject:From;
        b=NHh3YX+fx58NrmuPMRyaELRtqCITwn6VKNlNFq4/8MtUZyyqiURFsB9wO4gvbVENa
         R3NJlvTiWP6+kYdqQkloeRY7dH4iifosZMjCIkXLhg1a24MzTQTe6wv/fed0fLpTV5
         FaHlHx8xaGAWPQrydfp8MH3v9qHMphHb+9E8OCVY=
Date:   Wed, 04 Oct 2023 13:18:54 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, vbabka@suse.cz,
        thomas.lendacky@amd.com, rppt@linux.ibm.com, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, dyoung@redhat.com,
        dave.hansen@intel.com, bp@alien8.de, bhe@redhat.com,
        ardb@kernel.org, adrian.hunter@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch removed from -mm tree
Message-Id: <20231004201855.6A6E4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: efi/unaccepted: do not let /proc/vmcore try to access unaccepted memory
has been removed from the -mm tree.  Its filename was
     efi-unaccepted-do-not-let-proc-vmcore-try-to-access-unaccepted-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4054,4 +4054,11 @@ static inline void accept_memory(phys_ad
 
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


