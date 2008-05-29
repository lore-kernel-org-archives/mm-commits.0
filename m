From: akpm@linux-foundation.org
Subject: + generic_file_aio_read-cleanups.patch added to -mm tree
Date: Thu, 29 May 2008 14:08:19 -0700
Message-ID: <200805292108.m4TL8J9j022626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbYE2VKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 17:10:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, hans-christoph.rohland@sap.com, leg@google.com, nickpiggin@yahoo.com.au, pbadari@us.ibm.com, zach.brown@oracle.com


The patch titled
     generic_file_aio_read() cleanups
has been added to the -mm tree.  Its filename is
     generic_file_aio_read-cleanups.patch

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
Subject: generic_file_aio_read() cleanups
From: Hugh Dickins <hugh@veritas.com>

As akpm points out, there's really no need for generic_file_aio_read to
make a special case of count 0: just loop through nr_segs doing nothing. 
And as Harvey Harrison points out, there's no need to reset retval to 0
where it's already 0.

Setting count (or ocount) to 0 before calling generic_segment_checks is
unnecessary too; but reluctantly I'll leave that removal to someone with a
wider range of gcc versions to hand - 4.1.2 and 4.2.1 don't warn about it,
but perhaps others do - I forget which are the warniest versions.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Lawrence Greenfield <leg@google.com>
Cc: Christoph Rohland <hans-christoph.rohland@sap.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff -puN mm/filemap.c~generic_file_aio_read-cleanups mm/filemap.c
--- a/mm/filemap.c~generic_file_aio_read-cleanups
+++ a/mm/filemap.c
@@ -1206,7 +1206,6 @@ generic_file_aio_read(struct kiocb *iocb
 
 		mapping = filp->f_mapping;
 		inode = mapping->host;
-		retval = 0;
 		if (!count)
 			goto out; /* skip atime */
 		size = i_size_read(inode);
@@ -1218,33 +1217,30 @@ generic_file_aio_read(struct kiocb *iocb
 			}
 			if (retval > 0)
 				*ppos = pos + retval;
-		}
-		if (likely(retval != 0)) {
-			file_accessed(filp);
-			goto out;
+			if (retval) {
+				file_accessed(filp);
+				goto out;
+			}
 		}
 	}
 
-	retval = 0;
-	if (count) {
-		for (seg = 0; seg < nr_segs; seg++) {
-			read_descriptor_t desc;
-
-			desc.written = 0;
-			desc.arg.buf = iov[seg].iov_base;
-			desc.count = iov[seg].iov_len;
-			if (desc.count == 0)
-				continue;
-			desc.error = 0;
-			do_generic_file_read(filp,ppos,&desc,file_read_actor);
-			retval += desc.written;
-			if (desc.error) {
-				retval = retval ?: desc.error;
-				break;
-			}
-			if (desc.count > 0)
-				break;
+	for (seg = 0; seg < nr_segs; seg++) {
+		read_descriptor_t desc;
+
+		desc.written = 0;
+		desc.arg.buf = iov[seg].iov_base;
+		desc.count = iov[seg].iov_len;
+		if (desc.count == 0)
+			continue;
+		desc.error = 0;
+		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		retval += desc.written;
+		if (desc.error) {
+			retval = retval ?: desc.error;
+			break;
 		}
+		if (desc.count > 0)
+			break;
 	}
 out:
 	return retval;
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
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
prio_tree-debugging-patch.patch

