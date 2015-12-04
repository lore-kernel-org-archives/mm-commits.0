From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4.patch removed from -mm
 tree
Date: Fri, 04 Dec 2015 15:14:43 -0800
Message-ID: <56621e63.X2TyFOTTYxQVk2cu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbbLDXOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, aarcange@redhat.com, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4.patch

This patch was dropped because it was folded into mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4

ASLR  only uses as few as 8 bits to generate the random offset for the
mmap base address on 32 bit architectures. This value was chosen to
prevent a poorly chosen value from dividing the address space in such
a way as to prevent large allocations. This may not be an issue on all
platforms. Allow the specification of a minimum number of bits so that
platforms desiring greater ASLR protection may determine where to place
the trade-off.

Signed-off-by: Daniel Cashman <dcashman@android.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mark Salyzyn <salyzyn@android.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Borislav Petkov <bp@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc; Heiko Carstens <heiko.carstens@de.ibm.com>
Cc; Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 ++--
 arch/Kconfig                |    8 ++++++--
 include/linux/mm.h          |   12 ++++++------
 kernel/sysctl.c             |   12 ++++++------
 mm/mmap.c                   |   12 ++++++------
 5 files changed, 26 insertions(+), 22 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4
+++ a/Documentation/sysctl/vm.txt
@@ -496,7 +496,7 @@ tuning address space randomization.  Thi
 by the architecture's minimum and maximum supported values.
 
 This value can be changed after boot using the
-/proc/sys/kernel/mmap_rnd_bits tunable
+/proc/sys/vm/mmap_rnd_bits tunable
 
 ==============================================================
 
@@ -510,7 +510,7 @@ space randomization.  This value will be
 architecture's minimum and maximum supported values.
 
 This value can be changed after boot using the
-/proc/sys/kernel/mmap_rnd_compat_bits tunable
+/proc/sys/vm/mmap_rnd_compat_bits tunable
 
 ==============================================================
 
diff -puN arch/Kconfig~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4 arch/Kconfig
--- a/arch/Kconfig~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4
+++ a/arch/Kconfig
@@ -542,7 +542,7 @@ config ARCH_MMAP_RND_BITS
 	  by the architecture's minimum and maximum supported values.
 
 	  This value can be changed after boot using the
-	  /proc/sys/kernel/mmap_rnd_bits tunable
+	  /proc/sys/vm/mmap_rnd_bits tunable
 
 config HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	bool
@@ -560,9 +560,13 @@ config ARCH_MMAP_RND_COMPAT_BITS_MIN
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
 	int
 
+config ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
+	int
+
 config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
+	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help
@@ -573,7 +577,7 @@ config ARCH_MMAP_RND_COMPAT_BITS
 	  supported values.
 
 	  This value can be changed after boot using the
-	  /proc/sys/kernel/mmap_rnd_compat_bits tunable
+	  /proc/sys/vm/mmap_rnd_compat_bits tunable
 
 config HAVE_COPY_THREAD_TLS
 	bool
diff -puN include/linux/mm.h~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4 include/linux/mm.h
--- a/include/linux/mm.h~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4
+++ a/include/linux/mm.h
@@ -52,14 +52,14 @@ extern int sysctl_legacy_va_layout;
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
-extern int mmap_rnd_bits_min;
-extern int mmap_rnd_bits_max;
-extern int mmap_rnd_bits;
+extern const int mmap_rnd_bits_min;
+extern const int mmap_rnd_bits_max;
+extern int mmap_rnd_bits __read_mostly;
 #endif
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
-extern int mmap_rnd_compat_bits_min;
-extern int mmap_rnd_compat_bits_max;
-extern int mmap_rnd_compat_bits;
+extern const int mmap_rnd_compat_bits_min;
+extern const int mmap_rnd_compat_bits_max;
+extern int mmap_rnd_compat_bits __read_mostly;
 #endif
 
 #include <asm/page.h>
diff -puN kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4 kernel/sysctl.c
--- a/kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4
+++ a/kernel/sysctl.c
@@ -1573,10 +1573,10 @@ static struct ctl_table vm_table[] = {
 		.procname	= "mmap_rnd_bits",
 		.data		= &mmap_rnd_bits,
 		.maxlen		= sizeof(mmap_rnd_bits),
-		.mode		= 0644,
+		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &mmap_rnd_bits_min,
-		.extra2		= &mmap_rnd_bits_max,
+		.extra1		= (void *) &mmap_rnd_bits_min,
+		.extra2		= (void *) &mmap_rnd_bits_max,
 	},
 #endif
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
@@ -1584,10 +1584,10 @@ static struct ctl_table vm_table[] = {
 		.procname	= "mmap_rnd_compat_bits",
 		.data		= &mmap_rnd_compat_bits,
 		.maxlen		= sizeof(mmap_rnd_compat_bits),
-		.mode		= 0644,
+		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &mmap_rnd_compat_bits_min,
-		.extra2		= &mmap_rnd_compat_bits_max,
+		.extra1		= (void *) &mmap_rnd_compat_bits_min,
+		.extra2		= (void *) &mmap_rnd_compat_bits_max,
 	},
 #endif
 	{ }
diff -puN mm/mmap.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4 mm/mmap.c
--- a/mm/mmap.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4
+++ a/mm/mmap.c
@@ -59,14 +59,14 @@
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
-int mmap_rnd_bits_min = CONFIG_ARCH_MMAP_RND_BITS_MIN;
-int mmap_rnd_bits_max = CONFIG_ARCH_MMAP_RND_BITS_MAX;
-int mmap_rnd_bits = CONFIG_ARCH_MMAP_RND_BITS;
+const int mmap_rnd_bits_min = CONFIG_ARCH_MMAP_RND_BITS_MIN;
+const int mmap_rnd_bits_max = CONFIG_ARCH_MMAP_RND_BITS_MAX;
+int mmap_rnd_bits __read_mostly = CONFIG_ARCH_MMAP_RND_BITS;
 #endif
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
-int mmap_rnd_compat_bits_min = CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN;
-int mmap_rnd_compat_bits_max = CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX;
-int mmap_rnd_compat_bits = CONFIG_ARCH_MMAP_RND_COMPAT_BITS;
+const int mmap_rnd_compat_bits_min = CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN;
+const int mmap_rnd_compat_bits_max = CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX;
+int mmap_rnd_compat_bits __read_mostly = CONFIG_ARCH_MMAP_RND_COMPAT_BITS;
 #endif
 
 
_

Patches currently in -mm which might be from dcashman@android.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch
arm-mm-support-arch_mmap_rnd_bits-v5.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v5.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

