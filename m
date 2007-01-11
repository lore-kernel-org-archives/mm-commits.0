From: akpm@osdl.org
Subject: + kdump-documentation-update-for-2620.patch added to -mm tree
Date: Wed, 10 Jan 2007 17:11:04 -0800
Message-ID: <200701110111.l0B1B58J013403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965295AbXAKBQa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 20:16:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vgoyal@in.ibm.com, horms@verge.net.au, mohan@in.ibm.com


The patch titled
     Kdump documentation update
has been added to the -mm tree.  Its filename is
     kdump-documentation-update-for-2620.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kdump documentation update
From: Vivek Goyal <vgoyal@in.ibm.com>

o Kdump documentation update.
	- Update details for using relocatable kernel.
	- Start using kexec-tools-testing release as it is latest and old
	  kexec-tools can't load relocatable bzImage file.
	- Also add kdump on ia64 specific details.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Horms <horms@verge.net.au>
Cc: Mohan Kumar M <mohan@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kdump/kdump.txt |  224 +++++++++++++++++++++-----------
 1 files changed, 152 insertions(+), 72 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kdump-documentation-update-for-2620 Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kdump-documentation-update-for-2620
+++ a/Documentation/kdump/kdump.txt
@@ -17,7 +17,7 @@ You can use common Linux commands, such 
 memory image to a dump file on the local disk, or across the network to
 a remote system.
 
-Kdump and kexec are currently supported on the x86, x86_64, and ppc64
+Kdump and kexec are currently supported on the x86, x86_64, ppc64 and IA64
 architectures.
 
 When the system kernel boots, it reserves a small section of memory for
@@ -54,59 +54,64 @@ memory," in two ways:
 Setup and Installation
 ======================
 
-Install kexec-tools and the Kdump patch
----------------------------------------
+Install kexec-tools
+-------------------
 
 1) Login as the root user.
 
 2) Download the kexec-tools user-space package from the following URL:
 
-   http://www.xmission.com/~ebiederm/files/kexec/kexec-tools-1.101.tar.gz
+http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/kexec-tools-testing-20061214.tar.gz
 
-3) Unpack the tarball with the tar command, as follows:
-
-   tar xvpzf kexec-tools-1.101.tar.gz
-
-4) Download the latest consolidated Kdump patch from the following URL:
-
-   http://lse.sourceforge.net/kdump/
+Note: Latest kexec-tools-testing git tree is available at
 
-   (This location is being used until all the user-space Kdump patches
-   are integrated with the kexec-tools package.)
+git://git.kernel.org/pub/scm/linux/kernel/git/horms/kexec-tools-testing.git
+or
+http://www.kernel.org/git/?p=linux/kernel/git/horms/kexec-tools-testing.git;a=summary
 
-5) Change to the kexec-tools-1.101 directory, as follows:
+3) Unpack the tarball with the tar command, as follows:
 
-   cd kexec-tools-1.101
+   tar xvpzf kexec-tools-testing-20061214.tar.gz
 
-6) Apply the consolidated patch to the kexec-tools-1.101 source tree
-   with the patch command, as follows. (Modify the path to the downloaded
-   patch as necessary.)
+4) Change to the kexec-tools-1.101 directory, as follows:
 
-   patch -p1 < /path-to-kdump-patch/kexec-tools-1.101-kdump.patch
+   cd kexec-tools-testing-20061214
 
-7) Configure the package, as follows:
+5) Configure the package, as follows:
 
    ./configure
 
-8) Compile the package, as follows:
+6) Compile the package, as follows:
 
    make
 
-9) Install the package, as follows:
+7) Install the package, as follows:
 
    make install
 
 
-Download and build the system and dump-capture kernels
-------------------------------------------------------
+Build the system and dump-capture kernels
+-----------------------------------------
+There are two possible methods of using Kdump.
+
+1) Build a separate custom dump-capture kernel for capturing the
+   kernel core dump.
+
+2) Or use the system kernel binary itself as dump-capture kernel and there is
+   no need to build a separate dump-capture kernel. This is possible
+   only with the architecutres which support a relocatable kernel. As
+   of today i386 and ia64 architectures support relocatable kernel.
+
+Building a relocatable kernel is advantageous from the point of view that
+one does not have to build a second kernel for capturing the dump. But
+at the same time one might want to build a custom dump capture kernel
+suitable to his needs.
 
-Download the mainline (vanilla) kernel source code (2.6.13-rc1 or newer)
-from http://www.kernel.org. Two kernels must be built: a system kernel
-and a dump-capture kernel. Use the following steps to configure these
-kernels with the necessary kexec and Kdump features:
+Following are the configuration setting required for system and
+dump-capture kernels for enabling kdump support.
 
-System kernel
--------------
+System kernel config options
+----------------------------
 
 1) Enable "kexec system call" in "Processor type and features."
 
@@ -132,88 +137,160 @@ System kernel
    analysis tools require a vmlinux with debug symbols in order to read
    and analyze a dump file.
 
-4) Make and install the kernel and its modules. Update the boot loader
-   (such as grub, yaboot, or lilo) configuration files as necessary.
+Dump-capture kernel config options (Arch Independent)
+-----------------------------------------------------
 
-5) Boot the system kernel with the boot parameter "crashkernel=Y@X",
-   where Y specifies how much memory to reserve for the dump-capture kernel
-   and X specifies the beginning of this reserved memory. For example,
-   "crashkernel=64M@16M" tells the system kernel to reserve 64 MB of memory
-   starting at physical address 0x01000000 for the dump-capture kernel.
-
-   On x86 and x86_64, use "crashkernel=64M@16M".
-
-   On ppc64, use "crashkernel=128M@32M".
+1) Enable "kernel crash dumps" support under "Processor type and
+   features":
 
+   CONFIG_CRASH_DUMP=y
 
-The dump-capture kernel
------------------------
+2) Enable "/proc/vmcore support" under "Filesystems" -> "Pseudo filesystems".
 
-1) Under "General setup," append "-kdump" to the current string in
-   "Local version."
+   CONFIG_PROC_VMCORE=y
+   (CONFIG_PROC_VMCORE is set by default when CONFIG_CRASH_DUMP is selected.)
 
-2) On x86, enable high memory support under "Processor type and
+Dump-capture kernel config options (Arch Dependent, i386)
+--------------------------------------------------------
+1) On x86, enable high memory support under "Processor type and
    features":
 
    CONFIG_HIGHMEM64G=y
    or
    CONFIG_HIGHMEM4G
 
-3) On x86 and x86_64, disable symmetric multi-processing support
+2) On x86 and x86_64, disable symmetric multi-processing support
    under "Processor type and features":
 
    CONFIG_SMP=n
+
    (If CONFIG_SMP=y, then specify maxcpus=1 on the kernel command line
    when loading the dump-capture kernel, see section "Load the Dump-capture
    Kernel".)
 
-4) On ppc64, disable NUMA support and enable EMBEDDED support:
+3) If one wants to build and use a relocatable kernel,
+   Enable "Build a relocatable kernel" support under "Processor type and
+   features"
 
-   CONFIG_NUMA=n
-   CONFIG_EMBEDDED=y
-   CONFIG_EEH=N for the dump-capture kernel
+   CONFIG_RELOCATABLE=y
 
-5) Enable "kernel crash dumps" support under "Processor type and
-   features":
+4) Use a suitable value for "Physical address where the kernel is
+   loaded" (under "Processor type and features"). This only appears when
+   "kernel crash dumps" is enabled. A suitable value depends upon
+   whether kernel is relocatable or not.
 
-   CONFIG_CRASH_DUMP=y
+   If you are using a relocatable kernel use CONFIG_PHYSICAL_START=0x100000
+   This will compile the kernel for physical address 1MB, but given the fact
+   kernel is relocatable, it can be run from any physical address hence
+   kexec boot loader will load it in memory region reserved for dump-capture
+   kernel.
+
+   Otherwise it should be the start of memory region reserved for
+   second kernel using boot parameter "crashkernel=Y@X". Here X is
+   start of memory region reserved for dump-capture kernel.
+   Generally X is 16MB (0x1000000). So you can set
+   CONFIG_PHYSICAL_START=0x1000000
+
+5) Make and install the kernel and its modules. DO NOT add this kernel
+   to the boot loader configuration files.
+
+Dump-capture kernel config options (Arch Dependent, x86_64)
+----------------------------------------------------------
+1) On x86 and x86_64, disable symmetric multi-processing support
+   under "Processor type and features":
+
+   CONFIG_SMP=n
+
+   (If CONFIG_SMP=y, then specify maxcpus=1 on the kernel command line
+   when loading the dump-capture kernel, see section "Load the Dump-capture
+   Kernel".)
 
-6) Use a suitable value for "Physical address where the kernel is
+2) Use a suitable value for "Physical address where the kernel is
    loaded" (under "Processor type and features"). This only appears when
    "kernel crash dumps" is enabled. By default this value is 0x1000000
    (16MB). It should be the same as X in the "crashkernel=Y@X" boot
-   parameter discussed above.
+   parameter.
 
-   On x86 and x86_64, use "CONFIG_PHYSICAL_START=0x1000000".
+   For x86_64, normally "CONFIG_PHYSICAL_START=0x1000000".
 
-   On ppc64 the value is automatically set at 32MB when
-   CONFIG_CRASH_DUMP is set.
-
-6) Optionally enable "/proc/vmcore support" under "Filesystems" ->
-   "Pseudo filesystems".
+3) Make and install the kernel and its modules. DO NOT add this kernel
+   to the boot loader configuration files.
 
-   CONFIG_PROC_VMCORE=y
-   (CONFIG_PROC_VMCORE is set by default when CONFIG_CRASH_DUMP is selected.)
+Dump-capture kernel config options (Arch Dependent, ppc64)
+----------------------------------------------------------
 
-7) Make and install the kernel and its modules. DO NOT add this kernel
+-  Make and install the kernel and its modules. DO NOT add this kernel
    to the boot loader configuration files.
 
+Dump-capture kernel config options (Arch Dependent, ia64)
+----------------------------------------------------------
+(To be filled)
+
+
+Boot into System Kernel
+=======================
+
+1) Make and install the kernel and its modules. Update the boot loader
+   (such as grub, yaboot, or lilo) configuration files as necessary.
+
+2) Boot the system kernel with the boot parameter "crashkernel=Y@X",
+   where Y specifies how much memory to reserve for the dump-capture kernel
+   and X specifies the beginning of this reserved memory. For example,
+   "crashkernel=64M@16M" tells the system kernel to reserve 64 MB of memory
+   starting at physical address 0x01000000 (16MB) for the dump-capture kernel.
+
+   On x86 and x86_64, use "crashkernel=64M@16M".
+
+   On ppc64, use "crashkernel=128M@32M".
 
 Load the Dump-capture Kernel
 ============================
 
-After booting to the system kernel, load the dump-capture kernel using
-the following command:
+After booting to the system kernel, dump-capture kernel needs to be
+loaded.
+
+Based on the architecture and type of image (relocatable or not), one
+can choose to load the uncompressed vmlinux or compressed bzImage/vmlinuz
+of dump-capture kernel. Following is the summary.
+
+For i386:
+	- Use vmlinux if kernel is not relocatable.
+	- Use bzImage/vmlinuz if kernel is relocatable.
+For x86_64:
+	- Use vmlinux
+For ppc64:
+	- Use vmlinux
+For ia64:
+	(To be filled)
+
+If you are using a uncompressed vmlinux image then use following command
+to load dump-capture kernel.
 
-   kexec -p <dump-capture-kernel> \
+   kexec -p <dump-capture-kernel-vmlinux-image> \
    --initrd=<initrd-for-dump-capture-kernel> --args-linux \
-   --append="root=<root-dev> init 1 irqpoll"
+   --append="root=<root-dev> <arch-specific-options>"
 
+If you are using a compressed bzImage/vmlinuz, then use following command
+to load dump-capture kernel.
 
-Notes on loading the dump-capture kernel:
+   kexec -p <dump-capture-kernel-bzImage> \
+   --initrd=<initrd-for-dump-capture-kernel> \
+   --append="root=<root-dev> <arch-specific-options>"
+
+Following are the arch specific command line options to be used while
+loading dump-capture kernel.
+
+For i386 and x86_64:
+	"init 1 irqpoll maxcpus=1"
+
+For ppc64:
+	"init 1 maxcpus=1 noirqdistrib"
 
-* <dump-capture-kernel> must be a vmlinux image (that is, an
-  uncompressed ELF image). bzImage does not work at this time.
+For IA64
+	(To be filled)
+
+
+Notes on loading the dump-capture kernel:
 
 * By default, the ELF headers are stored in ELF64 format to support
   systems with more than 4GB memory. The --elf32-core-headers option can
@@ -231,6 +308,9 @@ Notes on loading the dump-capture kernel
 * "init 1" boots the dump-capture kernel into single-user mode without
   networking. If you want networking, use "init 3."
 
+* We generally don' have to bring up a SMP kernel just to capture the
+  dump. Hence generally it is useful either to build a UP dump-capture
+  kernel or specify maxcpus=1 option while loading dump-capture kernel.
 
 Kernel Panic
 ============
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
