From: akpm@linux-foundation.org
Subject: - nommu-supply-get_unmapped_area-to-fix-nommu-sysv-shm.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:02 -0800
Message-ID: <200703260105.l2Q152gI008680@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314AbXCZBFM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, agl@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     NOMMU: supply get_unmapped_area() to fix NOMMU SYSV SHM
has been removed from the -mm tree.  Its filename was
     nommu-supply-get_unmapped_area-to-fix-nommu-sysv-shm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NOMMU: supply get_unmapped_area() to fix NOMMU SYSV SHM
From: David Howells <dhowells@redhat.com>

Supply a get_unmapped_area() to fix NOMMU SYSV SHM support.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN mm/nommu.c~nommu-supply-get_unmapped_area-to-fix-nommu-sysv-shm mm/nommu.c
--- a/mm/nommu.c~nommu-supply-get_unmapped_area-to-fix-nommu-sysv-shm
+++ a/mm/nommu.c
@@ -1193,6 +1193,28 @@ void unmap_mapping_range(struct address_
 EXPORT_SYMBOL(unmap_mapping_range);
 
 /*
+ * ask for an unmapped area at which to create a mapping on a file
+ */
+unsigned long get_unmapped_area(struct file *file, unsigned long addr,
+				unsigned long len, unsigned long pgoff,
+				unsigned long flags)
+{
+	unsigned long (*get_area)(struct file *, unsigned long, unsigned long,
+				  unsigned long, unsigned long);
+
+	get_area = current->mm->get_unmapped_area;
+	if (file && file->f_op && file->f_op->get_unmapped_area)
+		get_area = file->f_op->get_unmapped_area;
+
+	if (!get_area)
+		return -ENOSYS;
+
+	return get_area(file, addr, len, pgoff, flags);
+}
+
+EXPORT_SYMBOL(get_unmapped_area);
+
+/*
  * Check that a process has enough memory to allocate a new virtual
  * mapping. 0 means there is enough memory for the allocation to
  * succeed and -ENOMEM implies there is not.
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
nommu-hide-vm_mm-in-nommu-mode.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
mutex-subsystem-synchro-test-module.patch
