From: akpm@linux-foundation.org
Subject: + tty-termios-locking-functions-break-with-new-termios.patch added to -mm tree
Date: Mon, 10 Sep 2007 21:57:42 -0700
Message-ID: <200709110457.l8B4vgB0026306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbXIKE6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 00:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, alan@redhat.com


The patch titled
     tty: termios locking functions break with new termios type
has been added to the -mm tree.  Its filename is
     tty-termios-locking-functions-break-with-new-termios.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: termios locking functions break with new termios type
From: David Miller <davem@davemloft.net>

I ran into a few problems.

n_tty_ioctl() for instance:

drivers/char/tty_ioctl.c:799: error: $,1rxstruct termios$,1ry has no
member named $,1rxc_ispeed$,1ry

This is calling the copy interface that is supposed to be using
a termios2 when the new interfaces are defined, however:

		case TIOCGLCKTRMIOS:
			if (kernel_termios_to_user_termios((struct
termios __user *)arg, real_tty->termios_locked)) return -EFAULT;
			return 0;

This is going to write over the end of the userspace
structure by a few bytes, and wasn't caught by you yet
because the i386 implementation is simply copy_to_user()
which does zero type checking.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-termios-locking-functions-break-with-new-termios drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-termios-locking-functions-break-with-new-termios
+++ a/drivers/char/tty_ioctl.c
@@ -796,14 +796,14 @@ int n_tty_ioctl(struct tty_struct * tty,
 				retval = inq_canon(tty);
 			return put_user(retval, (unsigned int __user *) arg);
 		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
+			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
 				return -EFAULT;
 			return 0;
 
 		case TIOCSLCKTRMIOS:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EPERM;
-			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
+			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
 				return -EFAULT;
 			return 0;
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
futex_compat-fix-list-traversal-bugs.patch
tty-termios-locking-functions-break-with-new-termios.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-powerpc.patch
infiniband-work-around-gcc-slub-problem.patch
git-net.patch
net-atm-lecc-printk-warning-fix.patch
e1000e-incorporate-napi_struct-changes-from-net-2624git.patch
git-scsi-misc.patch
git-block.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
i386-optimize-memset-of-6-and-8-bytes.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
sparc64-sparsemem_vmemmap-support.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
i-oat-new-device-ids.patch
i-oat-rename-the-source-file.patch
i-oat-code-cleanup-from-checkpatch-output.patch
i-oat-split-pci-startup-from-dma-handling-code.patch
i-oat-add-support-for-msi-and-msi-x.patch
dca-add-direct-cache-access-driver.patch
i-oat-add-dca-services.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
bitops-introduce-lock-ops.patch
