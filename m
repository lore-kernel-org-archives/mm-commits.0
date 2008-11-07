From: akpm@linux-foundation.org
Subject: + doc-add-printk-formatstxt.patch added to -mm tree
Date: Fri, 07 Nov 2008 14:37:23 -0800
Message-ID: <200811072237.mA7MbNu2002149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbYKGWhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 17:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, adobriyan@gmail.com


The patch titled
     DOC: add printk-formats.txt
has been added to the -mm tree.  Its filename is
     doc-add-printk-formatstxt.patch

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
Subject: DOC: add printk-formats.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Add printk-formats.txt so that we don't have to keep fixing the
same things over and over again.  <wishful thinking>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX           |    2 +
 Documentation/printk-formats.txt |   36 +++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

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
@@ -0,0 +1,36 @@
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
+Written by Alexey Dobriyan <adobriyan@gmail.com>
+Updated by Randy Dunlap <rdunlap@xenotime.net>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
doc-add-printk-formatstxt.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-update-scheduler-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

