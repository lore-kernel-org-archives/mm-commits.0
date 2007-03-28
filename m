From: akpm@linux-foundation.org
Subject: - x86_64-shut-up-vm862.patch removed from -mm tree
Date: Wed, 28 Mar 2007 12:51:52 -0700
Message-ID: <200703281951.l2SJprO7018701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56702 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965724AbXC1Tv6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 15:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: shut up vm86(2)
has been removed from the -mm tree.  Its filename was
     x86_64-shut-up-vm862.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: x86_64: shut up vm86(2)
From: Alexey Dobriyan <adobriyan@gmail.com>

Change from originally rate-limited printk, to just printk, to current
version.  Everybody had enough time to learn about vm86(2) absense.  Also
remove possibility of dmesg spamming.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32entry.S |    4 ++--
 arch/x86_64/ia32/sys_ia32.c  |   12 ------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN arch/x86_64/ia32/ia32entry.S~x86_64-shut-up-vm862 arch/x86_64/ia32/ia32entry.S
--- a/arch/x86_64/ia32/ia32entry.S~x86_64-shut-up-vm862
+++ a/arch/x86_64/ia32/ia32entry.S
@@ -512,7 +512,7 @@ ia32_sys_call_table:
 	.quad stub32_iopl		/* 110 */
 	.quad sys_vhangup
 	.quad quiet_ni_syscall	/* old "idle" system call */
-	.quad sys32_vm86_warning	/* vm86old */ 
+	.quad quiet_ni_syscall	/* vm86old */
 	.quad compat_sys_wait4
 	.quad sys_swapoff		/* 115 */
 	.quad compat_sys_sysinfo
@@ -565,7 +565,7 @@ ia32_sys_call_table:
 	.quad sys_mremap
 	.quad sys_setresuid16
 	.quad sys_getresuid16	/* 165 */
-	.quad sys32_vm86_warning	/* vm86 */ 
+	.quad quiet_ni_syscall	/* vm86 */
 	.quad quiet_ni_syscall	/* query_module */
 	.quad sys_poll
 	.quad compat_sys_nfsservctl
diff -puN arch/x86_64/ia32/sys_ia32.c~x86_64-shut-up-vm862 arch/x86_64/ia32/sys_ia32.c
--- a/arch/x86_64/ia32/sys_ia32.c~x86_64-shut-up-vm862
+++ a/arch/x86_64/ia32/sys_ia32.c
@@ -842,18 +842,6 @@ long sys32_fadvise64_64(int fd, __u32 of
 			       advice); 
 } 
 
-long sys32_vm86_warning(void)
-{ 
-	struct task_struct *me = current;
-	static char lastcomm[sizeof(me->comm)];
-	if (strncmp(lastcomm, me->comm, sizeof(lastcomm))) {
-		compat_printk(KERN_INFO "%s: vm86 mode not supported on 64 bit kernel\n",
-		       me->comm);
-		strncpy(lastcomm, me->comm, sizeof(lastcomm));
-	} 
-	return -ENOSYS;
-} 
-
 long sys32_lookup_dcookie(u32 addr_low, u32 addr_high,
 			  char __user * buf, size_t len)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
x86_64-shut-up-vm862.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
