From: akpm@linux-foundation.org
Subject: [merged] mips-add-entry-for-new-mlock2-syscall.patch removed from -mm tree
Date: Tue, 10 Nov 2015 12:32:59 -0800
Message-ID: <5642547b.nkDxPtSER7Op/987%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbKJUdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org, heiko.carstens@de.ibm.com, kirill.shutemov@linux.intel.com, linux@roeck-us.net, mhocko@suse.cz, mtk.manpages@gmail.com, ralf@linux-mips.org, sfr@canb.auug.org.au, shuahkh@osg.samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: add entry for new mlock2 syscall
has been removed from the -mm tree.  Its filename was
     mips-add-entry-for-new-mlock2-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: mips: add entry for new mlock2 syscall

A previous commit introduced the new mlock2 syscall, add entries for the
MIPS architecture.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/uapi/asm/unistd.h |   15 +++++++++------
 arch/mips/kernel/scall32-o32.S      |    1 +
 arch/mips/kernel/scall64-64.S       |    1 +
 arch/mips/kernel/scall64-n32.S      |    1 +
 arch/mips/kernel/scall64-o32.S      |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff -puN arch/mips/include/uapi/asm/unistd.h~mips-add-entry-for-new-mlock2-syscall arch/mips/include/uapi/asm/unistd.h
--- a/arch/mips/include/uapi/asm/unistd.h~mips-add-entry-for-new-mlock2-syscall
+++ a/arch/mips/include/uapi/asm/unistd.h
@@ -379,16 +379,17 @@
 #define __NR_execveat			(__NR_Linux + 356)
 #define __NR_userfaultfd		(__NR_Linux + 357)
 #define __NR_membarrier			(__NR_Linux + 358)
+#define __NR_mlock2			(__NR_Linux + 359)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		358
+#define __NR_Linux_syscalls		359
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		358
+#define __NR_O32_Linux_syscalls		359
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -715,16 +716,17 @@
 #define __NR_execveat			(__NR_Linux + 316)
 #define __NR_userfaultfd		(__NR_Linux + 317)
 #define __NR_membarrier			(__NR_Linux + 318)
+#define __NR_mlock2			(__NR_Linux + 319)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		318
+#define __NR_Linux_syscalls		319
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		318
+#define __NR_64_Linux_syscalls		319
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1055,15 +1057,16 @@
 #define __NR_execveat			(__NR_Linux + 320)
 #define __NR_userfaultfd		(__NR_Linux + 321)
 #define __NR_membarrier			(__NR_Linux + 322)
+#define __NR_mlock2			(__NR_Linux + 323)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		322
+#define __NR_Linux_syscalls		323
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		322
+#define __NR_N32_Linux_syscalls		323
 
 #endif /* _UAPI_ASM_UNISTD_H */
diff -puN arch/mips/kernel/scall32-o32.S~mips-add-entry-for-new-mlock2-syscall arch/mips/kernel/scall32-o32.S
--- a/arch/mips/kernel/scall32-o32.S~mips-add-entry-for-new-mlock2-syscall
+++ a/arch/mips/kernel/scall32-o32.S
@@ -594,3 +594,4 @@ EXPORT(sys_call_table)
 	PTR	sys_execveat
 	PTR	sys_userfaultfd
 	PTR	sys_membarrier
+	PTR	sys_mlock2
diff -puN arch/mips/kernel/scall64-64.S~mips-add-entry-for-new-mlock2-syscall arch/mips/kernel/scall64-64.S
--- a/arch/mips/kernel/scall64-64.S~mips-add-entry-for-new-mlock2-syscall
+++ a/arch/mips/kernel/scall64-64.S
@@ -432,4 +432,5 @@ EXPORT(sys_call_table)
 	PTR	sys_execveat
 	PTR	sys_userfaultfd
 	PTR	sys_membarrier
+	PTR	sys_mlock2
 	.size	sys_call_table,.-sys_call_table
diff -puN arch/mips/kernel/scall64-n32.S~mips-add-entry-for-new-mlock2-syscall arch/mips/kernel/scall64-n32.S
--- a/arch/mips/kernel/scall64-n32.S~mips-add-entry-for-new-mlock2-syscall
+++ a/arch/mips/kernel/scall64-n32.S
@@ -422,4 +422,5 @@ EXPORT(sysn32_call_table)
 	PTR	compat_sys_execveat		/* 6320 */
 	PTR	sys_userfaultfd
 	PTR	sys_membarrier
+	PTR	sys_mlock2
 	.size	sysn32_call_table,.-sysn32_call_table
diff -puN arch/mips/kernel/scall64-o32.S~mips-add-entry-for-new-mlock2-syscall arch/mips/kernel/scall64-o32.S
--- a/arch/mips/kernel/scall64-o32.S~mips-add-entry-for-new-mlock2-syscall
+++ a/arch/mips/kernel/scall64-o32.S
@@ -577,4 +577,5 @@ EXPORT(sys32_call_table)
 	PTR	compat_sys_execveat
 	PTR	sys_userfaultfd
 	PTR	sys_membarrier
+	PTR	sys_mlock2
 	.size	sys32_call_table,.-sys32_call_table
_

Patches currently in -mm which might be from emunson@akamai.com are


