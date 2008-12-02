From: akpm@linux-foundation.org
Subject: + proc-move-inode-comment-text-file-to-source-file.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:21:20 -0800
Message-ID: <200812022221.mB2MLK00001767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbYLBWV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adobriyan@gmail.com


The patch titled
     proc: move inode comment text file to source file
has been added to the -mm tree.  Its filename is
     proc-move-inode-comment-text-file-to-source-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: move inode comment text file to source file
From: Randy Dunlap <randy.dunlap@oracle.com>

Move fs/proc/inode-alloc.txt comment into a source file so that people
will realize that it exists and can update it as needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   15 +++++++++++++++
 fs/proc/inode-alloc.txt |   14 --------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff -puN fs/proc/generic.c~proc-move-inode-comment-text-file-to-source-file fs/proc/generic.c
--- a/fs/proc/generic.c~proc-move-inode-comment-text-file-to-source-file
+++ a/fs/proc/generic.c
@@ -307,6 +307,21 @@ static DEFINE_SPINLOCK(proc_inum_lock); 
 /*
  * Return an inode number between PROC_DYNAMIC_FIRST and
  * 0xffffffff, or zero on failure.
+ *
+ * Current inode allocations in the proc-fs (hex-numbers):
+ *
+ * 00000000		reserved
+ * 00000001-00000fff	static entries	(goners)
+ *      001		root-ino
+ *
+ * 00001000-00001fff	unused
+ * 0001xxxx-7fffxxxx	pid-dir entries for pid 1-7fff
+ * 80000000-efffffff	unused
+ * f0000000-ffffffff	dynamic entries
+ *
+ * Goal:
+ *	Once we split the thing into several virtual filesystems,
+ *	we will get rid of magical ranges (and this comment, BTW).
  */
 static unsigned int get_inode_number(void)
 {
diff -puN fs/proc/inode-alloc.txt~proc-move-inode-comment-text-file-to-source-file /dev/null
--- a/fs/proc/inode-alloc.txt
+++ /dev/null
@@ -1,14 +0,0 @@
-Current inode allocations in the proc-fs (hex-numbers):
-
-  00000000		reserved
-  00000001-00000fff	static entries	(goners)
-       001		root-ino
-
-  00001000-00001fff	unused
-  0001xxxx-7fffxxxx	pid-dir entries for pid 1-7fff
-  80000000-efffffff	unused
-  f0000000-ffffffff	dynamic entries
-
-Goal:
-	a) once we'll split the thing into several virtual filesystems we
-	will get rid of magical ranges (and this file, BTW).
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
document-hadling-of-bad-memory.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
fix-similar-typos-to-successfull-v2.patch

