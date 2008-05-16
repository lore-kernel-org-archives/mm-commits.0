From: akpm@linux-foundation.org
Subject: + spufs-use-the-new-vm_ops-access.patch added to -mm tree
Date: Thu, 15 May 2008 17:22:20 -0700
Message-ID: <200805160022.m4G0MKDH018074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922AbYEPAWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, airlied@linux.ie, arnd@arndb.de, benh@kernel.crashing.org, hugh@veritas.com, paulus@samba.org


The patch titled
     spufs: use new vm_ops->access to allow local state access from gdb
has been added to the -mm tree.  Its filename is
     spufs-use-the-new-vm_ops-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spufs: use new vm_ops->access to allow local state access from gdb
From: Rik van Riel <riel@redhat.com>

This uses the new vm_ops->access to allow gdb to access the SPU local
store.  We currently prevent access to problem state registers, this can
be done later if really needed but it's safer not to.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |   23 +++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~spufs-use-the-new-vm_ops-access arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~spufs-use-the-new-vm_ops-access
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -287,9 +287,32 @@ spufs_mem_mmap_fault(struct vm_area_stru
 	return VM_FAULT_NOPAGE;
 }
 
+static int spufs_mem_mmep_access(struct vm_area_struct *vma,
+				unsigned long address,
+				void *buf, int len, int write)
+{
+	struct spu_context *ctx = vma->vm_file->private_data;
+	unsigned long offset = address - vma->vm_start;
+	char *local_store;
+
+	if (write && !(vma->vm_flags & VM_WRITE))
+		return -EACCES;
+	if (spu_acquire(ctx))
+		return -EINTR;
+	if ((offset + len) > vma->vm_end)
+		len = vma->vm_end - offset;
+	local_store = ctx->ops->get_ls(ctx);
+	if (write)
+		memcpy_toio(local_store + offset, buf, len);
+	else
+		memcpy_fromio(buf, local_store + offset, len);
+	spu_release(ctx);
+	return len;
+}
 
 static struct vm_operations_struct spufs_mem_mmap_vmops = {
 	.fault = spufs_mem_mmap_fault,
+	.access = spufs_mem_mmep_access,
 };
 
 static int spufs_mem_mmap(struct file *file, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from riel@redhat.com are

access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
make-mm-rmapc-anon_vma_cachep-static.patch

