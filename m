From: akpm@linux-foundation.org
Subject: - doc-add-printk-formatstxt.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:00 -0800
Message-ID: <200811132127.mADLR0uM027614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbYKMV1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     DOC: add printk-formats.txt
has been removed from the -mm tree.  Its filename was
     doc-add-printk-formatstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DOC: add printk-formats.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Add printk-formats.txt so that we don't have to keep fixing the
same things over and over again.  <wishful thinking>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX           |    2 +
 Documentation/printk-formats.txt |   35 +++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN Documentation/00-INDEX~doc-add-printk-formatstxt Documentation/00-INDEX
--- a/Documentation/00-INDEX~doc-add-printk-formatstxt
+++ a/Documentation/00-INDEX
@@ -290,6 +290,8 @@ powerpc/
 	- directory with info on using Linux with the PowerPC.
 preempt-locking.txt
 	- info on locking under a preemptive kernel.
+printk-formats.txt
+	- how to get printk format specifiers right
 prio_tree.txt
 	- info on radix-priority-search-tree use for indexing vmas.
 ramdisk.txt
diff -puN /dev/null Documentation/printk-formats.txt
--- /dev/null
+++ a/Documentation/printk-formats.txt
@@ -0,0 +1,35 @@
+If variable is of Type,		use printk format specifier:
+---------------------------------------------------------
+		int			%d or %x
+		unsigned int		%u or %x
+		long			%ld or %lx
+		unsigned long		%lu or %lx
+		long long		%lld or %llx
+		unsigned long long	%llu or %llx
+		size_t			%zu or %zx
+		ssize_t			%zd or %zx
+
+Raw pointer value SHOULD be printed with %p.
+
+u64 SHOULD be printed with %llu/%llx, (unsigned long long):
+
+	printk("%llu", (unsigned long long)u64_var);
+
+s64 SHOULD be printed with %lld/%llx, (long long):
+
+	printk("%lld", (long long)s64_var);
+
+If <type> is dependent on a config option for its size (e.g., sector_t,
+blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
+for its size (e.g., tcflag_t), use a format specifier of its largest
+possible type and explicitly cast to it.  Example:
+
+	printk("test: sector number/total blocks: %llu/%llu\n",
+		(unsigned long long)sector, (unsigned long long)blockcount);
+
+Reminder: sizeof() result is of type size_t.
+
+Thank you for your cooperation and attention.
+
+
+By Randy Dunlap <rdunlap@xenotime.net>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

