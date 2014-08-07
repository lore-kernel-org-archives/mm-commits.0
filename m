From: akpm@linux-foundation.org
Subject: [merged] shmem-update-memory-reservation-on-truncate.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:07 -0700
Message-ID: <53e3dbf3.n4cO0on/o53sOGyE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:34465 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:08 -0400
Received: by mail-vc0-f201.google.com with SMTP id le20so610808vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: update memory reservation on truncate
has been removed from the -mm tree.  Its filename was
     shmem-update-memory-reservation-on-truncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: shmem: update memory reservation on truncate

A shared anonymous mapping created without MAP_NORESERVE holds memory
reservation for whole range of shmem segment.  Usually there is no way to
change its size, but /proc/<pid>/map_files/...  (available if
CONFIG_CHECKPOINT_RESTORE=y) allows that.

This patch adjusts the memory reservation in shmem_setattr().

exploit:

#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	unsigned long addr;
	char path[100];

	/* charge 4KiB */
	addr = (unsigned long)mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
	sprintf(path, "/proc/self/map_files/%lx-%lx", addr, addr + 4096);
	truncate(path, 1 << 30);
	/* uncharge 1GiB */
}

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN mm/shmem.c~shmem-update-memory-reservation-on-truncate mm/shmem.c
--- a/mm/shmem.c~shmem-update-memory-reservation-on-truncate
+++ a/mm/shmem.c
@@ -149,6 +149,19 @@ static inline void shmem_unacct_size(uns
 		vm_unacct_memory(VM_ACCT(size));
 }
 
+static inline int shmem_reacct_size(unsigned long flags,
+		loff_t oldsize, loff_t newsize)
+{
+	if (!(flags & VM_NORESERVE)) {
+		if (VM_ACCT(newsize) > VM_ACCT(oldsize))
+			return security_vm_enough_memory_mm(current->mm,
+					VM_ACCT(newsize) - VM_ACCT(oldsize));
+		else if (VM_ACCT(newsize) < VM_ACCT(oldsize))
+			vm_unacct_memory(VM_ACCT(oldsize) - VM_ACCT(newsize));
+	}
+	return 0;
+}
+
 /*
  * ... whereas tmpfs objects are accounted incrementally as
  * pages are allocated, in order to allow huge sparse files.
@@ -549,6 +562,10 @@ static int shmem_setattr(struct dentry *
 		loff_t newsize = attr->ia_size;
 
 		if (newsize != oldsize) {
+			error = shmem_reacct_size(SHMEM_I(inode)->flags,
+					oldsize, newsize);
+			if (error)
+				return error;
 			i_size_write(inode, newsize);
 			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 		}
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch

