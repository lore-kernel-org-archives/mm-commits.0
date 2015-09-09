From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:09:17 -0700
Message-ID: <55f0ae0d.9ONo3do6wRdZppHs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbIIWJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch

This patch was dropped because it was folded into fs-coda-fix-readlink-buffer-overflow.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes

ERROR: need consistent spacing around '+' (ctx:VxW)
#35: FILE: fs/coda/upcall.c:356:
+		     INSIZE(readlink), OUTSIZE(readlink)+ *length);
 		                                        ^

ERROR: space prohibited after that open parenthesis '('
#45: FILE: fs/coda/upcall.c:364:
+		if ( retlen >= *length )

ERROR: space prohibited before that close parenthesis ')'
#45: FILE: fs/coda/upcall.c:364:
+		if ( retlen >= *length )

total: 3 errors, 0 warnings, 18 lines checked

./patches/fs-coda-fix-readlink-buffer-overflow.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/coda/upcall.c~fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes
+++ a/fs/coda/upcall.c
@@ -361,7 +361,7 @@ int venus_readlink(struct super_block *s
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		retlen = outp->coda_readlink.count;
-		if ( retlen >= *length )
+		if (retlen >= *length)
 			retlen = *length - 1;
 		*length = retlen;
 		result =  (char *)outp + (long)outp->coda_readlink.data;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

