From: akpm@linux-foundation.org
Subject: [merged] proc-move-inode-comment-text-file-to-source-file.patch removed from -mm tree
Date: Wed, 14 Jan 2009 12:42:00 -0800
Message-ID: <200901142042.n0EKg0gP008738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbZANUmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 15:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: move inode comment text file to source file
has been removed from the -mm tree.  Its filename was
     proc-move-inode-comment-text-file-to-source-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
update-of-documentation-vmtxt-and-proctxt.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
jbd-fix-missing-kernel-doc.patch
resources-fix-parameter-name-and-kernel-doc.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
kbuild-fix-kbuildtxt-typos.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

