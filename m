From: akpm@linux-foundation.org
Subject: [merged] hpet-allow-user-controlled-mmap-for-user-processes.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:44 -0800
Message-ID: <5283e390.5ptG4D4uPNRro2gg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3KMUjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomas.winkler@intel.com, rdunlap@infradead.org, msw@amazon.com, clemens@ladisch.de, prarit@redhat.com

Subject: [merged] hpet-allow-user-controlled-mmap-for-user-processes.patch removed from -mm tree
To: prarit@redhat.com,clemens@ladisch.de,msw@amazon.com,rdunlap@infradead.org,tomas.winkler@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:44 -0800


The patch titled
     Subject: drivers/char/hpet.c: allow user controlled mmap for user processes
has been removed from the -mm tree.  Its filename was
     hpet-allow-user-controlled-mmap-for-user-processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: drivers/char/hpet.c: allow user controlled mmap for user processes

The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
registers to userspace.  The Kconfig help points out that in some cases
this can be a security risk as some systems may erroneously configure the
map such that additional data is exposed to userspace.

This is a problem for distributions -- some users want the MMAP
functionality but it comes with a significant security risk.  In an effort
to mitigate this risk, and due to the low number of users of the MMAP
functionality, I've introduced a kernel parameter, hpet_mmap_enable, that
is required in order to actually have the HPET MMAP exposed.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Matt Wilson <msw@amazon.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +++
 drivers/char/Kconfig                |   10 ++++++++--
 drivers/char/hpet.c                 |   24 ++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~hpet-allow-user-controlled-mmap-for-user-processes Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~hpet-allow-user-controlled-mmap-for-user-processes
+++ a/Documentation/kernel-parameters.txt
@@ -1070,6 +1070,9 @@ bytes respectively. Such letter suffixes
 				VIA, nVidia)
 			verbose: show contents of HPET registers during setup
 
+	hpet_mmap=	[X86, HPET_MMAP] Allow userspace to mmap HPET
+			registers.  Default set by CONFIG_HPET_MMAP_DEFAULT.
+
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
 			On x86-64 and powerpc, this option can be specified
diff -puN drivers/char/Kconfig~hpet-allow-user-controlled-mmap-for-user-processes drivers/char/Kconfig
--- a/drivers/char/Kconfig~hpet-allow-user-controlled-mmap-for-user-processes
+++ a/drivers/char/Kconfig
@@ -522,10 +522,16 @@ config HPET_MMAP
 	  If you say Y here, user applications will be able to mmap
 	  the HPET registers.
 
+config HPET_MMAP_DEFAULT
+	bool "Enable HPET MMAP access by default"
+	default y
+	depends on HPET_MMAP
+	help
 	  In some hardware implementations, the page containing HPET
 	  registers may also contain other things that shouldn't be
-	  exposed to the user.  If this applies to your hardware,
-	  say N here.
+	  exposed to the user.  This option selects the default (if
+	  kernel parameter hpet_mmap is not set) user access to the
+	  registers for applications that require it.
 
 config HANGCHECK_TIMER
 	tristate "Hangcheck timer"
diff -puN drivers/char/hpet.c~hpet-allow-user-controlled-mmap-for-user-processes drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-allow-user-controlled-mmap-for-user-processes
+++ a/drivers/char/hpet.c
@@ -367,12 +367,29 @@ static unsigned int hpet_poll(struct fil
 	return 0;
 }
 
+#ifdef CONFIG_HPET_MMAP
+#ifdef CONFIG_HPET_MMAP_DEFAULT
+static int hpet_mmap_enabled = 1;
+#else
+static int hpet_mmap_enabled = 0;
+#endif
+
+static __init int hpet_mmap_enable(char *str)
+{
+	get_option(&str, &hpet_mmap_enabled);
+	pr_info("HPET mmap %s\n", hpet_mmap_enabled ? "enabled" : "disabled");
+	return 1;
+}
+__setup("hpet_mmap", hpet_mmap_enable);
+
 static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 {
-#ifdef	CONFIG_HPET_MMAP
 	struct hpet_dev *devp;
 	unsigned long addr;
 
+	if (!hpet_mmap_enabled)
+		return -EACCES;
+
 	devp = file->private_data;
 	addr = devp->hd_hpets->hp_hpet_phys;
 
@@ -381,10 +398,13 @@ static int hpet_mmap(struct file *file,
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	return vm_iomap_memory(vma, addr, PAGE_SIZE);
+}
 #else
+static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
+{
 	return -ENOSYS;
-#endif
 }
+#endif
 
 static int hpet_fasync(int fd, struct file *file, int on)
 {
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
linux-next.patch

