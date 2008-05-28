From: akpm@linux-foundation.org
Subject: + tmpfs-support-aio.patch added to -mm tree
Date: Wed, 28 May 2008 16:58:25 -0700
Message-ID: <200805282358.m4SNwPpm006806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbYE1X7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, hans-christoph.rohland@sap.com, leg@google.com, pbadari@us.ibm.com, zach.brown@oracle.com


The patch titled
     tmpfs: support aio
has been added to the -mm tree.  Its filename is
     tmpfs-support-aio.patch

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
Subject: tmpfs: support aio
From: Hugh Dickins <hugh@veritas.com>

We have a request for tmpfs to support the AIO interface: easily done, no
more than replacing the old shmem_file_read by shmem_file_aio_read,
cribbed from generic_file_aio_read.  (In 2.6.25 its write side was already
changed to use generic_file_aio_write.)

Tests out fine with LTP's ltp-aiodio.sh, given hacks (not included) to
support O_DIRECT.  tmpfs cannot honestly support O_DIRECT: its
cache-avoiding-IO nature is at odds with direct IO-avoiding-cache.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Lawrence Greenfield <leg@google.com>
Cc: Christoph Rohland <hans-christoph.rohland@sap.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   57 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff -puN mm/shmem.c~tmpfs-support-aio mm/shmem.c
--- a/mm/shmem.c~tmpfs-support-aio
+++ a/mm/shmem.c
@@ -1690,26 +1690,42 @@ static void do_shmem_file_read(struct fi
 	file_accessed(filp);
 }
 
-static ssize_t shmem_file_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
+static ssize_t shmem_file_aio_read(struct kiocb *iocb,
+		const struct iovec *iov, unsigned long nr_segs, loff_t pos)
 {
-	read_descriptor_t desc;
-
-	if ((ssize_t) count < 0)
-		return -EINVAL;
-	if (!access_ok(VERIFY_WRITE, buf, count))
-		return -EFAULT;
-	if (!count)
-		return 0;
-
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.buf = buf;
-	desc.error = 0;
-
-	do_shmem_file_read(filp, ppos, &desc, file_read_actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
+	struct file *filp = iocb->ki_filp;
+	ssize_t retval;
+	unsigned long seg;
+	size_t count;
+	loff_t *ppos = &iocb->ki_pos;
+
+	count = 0;
+	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (retval)
+		return retval;
+
+	retval = 0;
+	if (count) {
+		for (seg = 0; seg < nr_segs; seg++) {
+			read_descriptor_t desc;
+
+			desc.written = 0;
+			desc.arg.buf = iov[seg].iov_base;
+			desc.count = iov[seg].iov_len;
+			if (desc.count == 0)
+				continue;
+			desc.error = 0;
+			do_shmem_file_read(filp, ppos, &desc, file_read_actor);
+			retval += desc.written;
+			if (desc.error) {
+				retval = retval ?: desc.error;
+				break;
+			}
+			if (desc.count > 0)
+				break;
+		}
+	}
+	return retval;
 }
 
 static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -2369,8 +2385,9 @@ static const struct file_operations shme
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
 	.llseek		= generic_file_llseek,
-	.read		= shmem_file_read,
+	.read		= do_sync_read,
 	.write		= do_sync_write,
+	.aio_read	= shmem_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.fsync		= simple_sync_file,
 	.splice_read	= generic_file_splice_read,
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
tmpfs-support-aio.patch
tmpfs-support-aio-cleanup.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
prio_tree-debugging-patch.patch

