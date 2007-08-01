From: akpm@linux-foundation.org
Subject: + block-hide-the-contents-of-linux-bioh-if-config_block=n.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:34:33 -0700
Message-ID: <200708012334.l71NYXg4023034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbXHAXfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, James.Bottomley@steeleye.com, jens.axboe@oracle.com


The patch titled
     BLOCK: Hide the contents of linux/bio.h if CONFIG_BLOCK=n
has been added to the -mm tree.  Its filename is
     block-hide-the-contents-of-linux-bioh-if-config_block=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: BLOCK: Hide the contents of linux/bio.h if CONFIG_BLOCK=n
From: David Howells <dhowells@redhat.com>

Hide the contents of linux/bio.h if CONFIG_BLOCK=n as there shouldn't be
compiled that uses it.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    3 +++
 1 files changed, 3 insertions(+)

diff -puN include/linux/bio.h~block-hide-the-contents-of-linux-bioh-if-config_block=n include/linux/bio.h
--- a/include/linux/bio.h~block-hide-the-contents-of-linux-bioh-if-config_block=n
+++ a/include/linux/bio.h
@@ -24,6 +24,8 @@
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
 
+#ifdef CONFIG_BLOCK
+
 /* Platforms may set this to teach the BIO layer about IOMMU hardware. */
 #include <asm/io.h>
 
@@ -361,4 +363,5 @@ static inline char *__bio_kmap_irq(struc
 	__bio_kmap_irq((bio), (bio)->bi_idx, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
+#endif /* CONFIG_BLOCK */
 #endif /* __LINUX_BIO_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-connect-up-fallocate.patch
changing-include-asm-generic-pgtableh-for-non-mmu.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
block-hide-the-contents-of-linux-bioh-if-config_block=n.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
fs-afs-possible-cleanups.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
mutex-subsystem-synchro-test-module.patch
