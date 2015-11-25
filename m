From: akpm@linux-foundation.org
Subject: + mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch added to
 -mm tree
Date: Tue, 24 Nov 2015 16:40:08 -0800
Message-ID: <56550368.Pm3nhsXkNkhf5Q1T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbbKYAkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 19:40:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, aarcange@redhat.com, benh@kernel.crashing.org, bp@suse.de, catalin.marinas@arm.com, corbet@lwn.net, dzickus@redhat.com, ebiederm@xmission.com, hecmargi@upv.es, hpa@zytor.com, jeffv@google.com, jpoimboe@redhat.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mgorman@suse.de, mingo@kernel.org, n-horiguchi@ah.jp.nec.com, nnk@google.com, ralf@linux-mips.org, rientjes@google.com, salyzyn@android.com, tglx@linutronix.de, will.deacon@arm.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: add new /proc tunable for mmap_base ASLR
has been added to the -mm tree.  Its filename is
     mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: mm: mmap: add new /proc tunable for mmap_base ASLR

Address Space Layout Randomization (ASLR) provides a barrier to
exploitation of user-space processes in the presence of security
vulnerabilities by making it more difficult to find desired code/data
which could help an attack.  This is done by adding a random offset to the
location of regions in the process address space, with a greater range of
potential offset values corresponding to better protection/a larger
search-space for brute force, but also to greater potential for
fragmentation.

The offset added to the mmap_base address, which provides the basis for
the majority of the mappings for a process, is set once on process exec in
arch_pick_mmap_layout() and is done via hard-coded per-arch values, which
reflect, hopefully, the best compromise for all systems.  The trade-off
between increased entropy in the offset value generation and the
corresponding increased variability in address space fragmentation is not
absolute, however, and some platforms may tolerate higher amounts of
entropy.  This patch introduces both new Kconfig values and a sysctl
interface which may be used to change the amount of entropy used for
offset generation on a system.

The direct motivation for this change was in response to the
libstagefright vulnerabilities that affected Android, specifically to
information provided by Google's project zero at:

http://googleprojectzero.blogspot.com/2015/09/stagefrightened.html

The attack presented therein, by Google's project zero, specifically
targeted the limited randomness used to generate the offset added to the
mmap_base address in order to craft a brute-force-based attack. 
Concretely, the attack was against the mediaserver process, which was
limited to respawning every 5 seconds, on an arm device.  The hard-coded 8
bits used resulted in an average expected success rate of defeating the
mmap ASLR after just over 10 minutes (128 tries at 5 seconds a piece). 
With this patch, and an accompanying increase in the entropy value to 16
bits, the same attack would take an average expected time of over 45 hours
(32768 tries), which makes it both less feasible and more likely to be
noticed.

The introduced Kconfig and sysctl options are limited by per-arch minimum
and maximum values, the minimum of which was chosen to match the current
hard-coded value and the maximum of which was chosen so as to give the
greatest flexibility without generating an invalid mmap_base address,
generally a 3-4 bits less than the number of bits in the user-space
accessible virtual address space.

When decided whether or not to change the default value, a system
developer should consider that mmap_base address could be placed anywhere
up to 2^(value) bits away from the non-randomized location, which would
introduce variable-sized areas above and below the mmap_base address such
that the maximum vm_area_struct size may be reduced, preventing very large
allocations. 


This patch (of 4):

ASLR currently only uses 8 bits to generate the random offset for the mmap
base address on 32 bit architectures.  This value was chosen to prevent a
poorly chosen value from dividing the address space in such a way as to
prevent large allocations.  This may not be an issue on all platforms. 
Allow the specification of a minimum number of bits so that platforms
desiring greater ASLR protection may determine where to place the
trade-off.

Signed-off-by: Daniel Cashman <dcashman@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
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

 Documentation/sysctl/vm.txt |   29 +++++++++++++++
 arch/Kconfig                |   64 ++++++++++++++++++++++++++++++++++
 include/linux/mm.h          |   11 +++++
 kernel/sysctl.c             |   22 +++++++++++
 mm/mmap.c                   |   12 ++++++
 5 files changed, 138 insertions(+)

diff -puN Documentation/sysctl/vm.txt~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr
+++ a/Documentation/sysctl/vm.txt
@@ -42,6 +42,8 @@ Currently, these files are in /proc/sys/
 - min_slab_ratio
 - min_unmapped_ratio
 - mmap_min_addr
+- mmap_rnd_bits
+- mmap_rnd_compat_bits
 - nr_hugepages
 - nr_overcommit_hugepages
 - nr_trim_pages         (only if CONFIG_MMU=n)
@@ -485,6 +487,33 @@ against future potential kernel bugs.
 
 ==============================================================
 
+mmap_rnd_bits:
+
+This value can be used to select the number of bits to use to
+determine the random offset to the base address of vma regions
+resulting from mmap allocations on architectures which support
+tuning address space randomization.  This value will be bounded
+by the architecture's minimum and maximum supported values.
+
+This value can be changed after boot using the
+/proc/sys/kernel/mmap_rnd_bits tunable
+
+==============================================================
+
+mmap_rnd_compat_bits:
+
+This value can be used to select the number of bits to use to
+determine the random offset to the base address of vma regions
+resulting from mmap allocations for applications run in
+compatibility mode on architectures which support tuning address
+space randomization.  This value will be bounded by the
+architecture's minimum and maximum supported values.
+
+This value can be changed after boot using the
+/proc/sys/kernel/mmap_rnd_compat_bits tunable
+
+==============================================================
+
 nr_hugepages
 
 Change the minimum size of the hugepage pool.
diff -puN arch/Kconfig~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr arch/Kconfig
--- a/arch/Kconfig~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr
+++ a/arch/Kconfig
@@ -511,6 +511,70 @@ config ARCH_HAS_ELF_RANDOMIZE
 	  - arch_mmap_rnd()
 	  - arch_randomize_brk()
 
+config HAVE_ARCH_MMAP_RND_BITS
+	bool
+	help
+	  An arch should select this symbol if it supports setting a variable
+	  number of bits for use in establishing the base address for mmap
+	  allocations and provides values for both:
+	  - ARCH_MMAP_RND_BITS_MIN
+	  - ARCH_MMAP_RND_BITS_MAX
+
+config ARCH_MMAP_RND_BITS_MIN
+	int
+
+config ARCH_MMAP_RND_BITS_MAX
+	int
+
+config ARCH_MMAP_RND_BITS_DEFAULT
+	int
+
+config ARCH_MMAP_RND_BITS
+	int "Number of bits to use for ASLR of mmap base address" if EXPERT
+	range ARCH_MMAP_RND_BITS_MIN ARCH_MMAP_RND_BITS_MAX
+	default ARCH_MMAP_RND_BITS_DEFAULT if ARCH_MMAP_RND_BITS_DEFAULT
+	default ARCH_MMAP_RND_BITS_MIN
+	depends on HAVE_ARCH_MMAP_RND_BITS
+	help
+	  This value can be used to select the number of bits to use to
+	  determine the random offset to the base address of vma regions
+	  resulting from mmap allocations. This value will be bounded
+	  by the architecture's minimum and maximum supported values.
+
+	  This value can be changed after boot using the
+	  /proc/sys/kernel/mmap_rnd_bits tunable
+
+config HAVE_ARCH_MMAP_RND_COMPAT_BITS
+	bool
+	help
+	  An arch should select this symbol if it supports running applications
+	  in compatibility mode, supports setting a variable number of bits for
+	  use in establishing the base address for mmap allocations, and
+	  provides values for both:
+	  - ARCH_MMAP_RND_COMPAT_BITS_MIN
+	  - ARCH_MMAP_RND_COMPAT_BITS_MAX
+
+config ARCH_MMAP_RND_COMPAT_BITS_MIN
+	int
+
+config ARCH_MMAP_RND_COMPAT_BITS_MAX
+	int
+
+config ARCH_MMAP_RND_COMPAT_BITS
+	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
+	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
+	default ARCH_MMAP_RND_COMPAT_BITS_MIN
+	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
+	help
+	  This value can be used to select the number of bits to use to
+	  determine the random offset to the base address of vma regions
+	  resulting from mmap allocations for compatible applications This
+	  value will be bounded by the architecture's minimum and maximum
+	  supported values.
+
+	  This value can be changed after boot using the
+	  /proc/sys/kernel/mmap_rnd_compat_bits tunable
+
 config HAVE_COPY_THREAD_TLS
 	bool
 	help
diff -puN include/linux/mm.h~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr include/linux/mm.h
--- a/include/linux/mm.h~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr
+++ a/include/linux/mm.h
@@ -51,6 +51,17 @@ extern int sysctl_legacy_va_layout;
 #define sysctl_legacy_va_layout 0
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
+extern int mmap_rnd_bits_min;
+extern int mmap_rnd_bits_max;
+extern int mmap_rnd_bits;
+#endif
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
+extern int mmap_rnd_compat_bits_min;
+extern int mmap_rnd_compat_bits_max;
+extern int mmap_rnd_compat_bits;
+#endif
+
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
diff -puN kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr kernel/sysctl.c
--- a/kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr
+++ a/kernel/sysctl.c
@@ -1568,6 +1568,28 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
+	{
+		.procname	= "mmap_rnd_bits",
+		.data		= &mmap_rnd_bits,
+		.maxlen		= sizeof(mmap_rnd_bits),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &mmap_rnd_bits_min,
+		.extra2		= &mmap_rnd_bits_max,
+	},
+#endif
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
+	{
+		.procname	= "mmap_rnd_compat_bits",
+		.data		= &mmap_rnd_compat_bits,
+		.maxlen		= sizeof(mmap_rnd_compat_bits),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &mmap_rnd_compat_bits_min,
+		.extra2		= &mmap_rnd_compat_bits_max,
+	},
+#endif
 	{ }
 };
 
diff -puN mm/mmap.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr mm/mmap.c
--- a/mm/mmap.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr
+++ a/mm/mmap.c
@@ -58,6 +58,18 @@
 #define arch_rebalance_pgtables(addr, len)		(addr)
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_BITS
+int mmap_rnd_bits_min = CONFIG_ARCH_MMAP_RND_BITS_MIN;
+int mmap_rnd_bits_max = CONFIG_ARCH_MMAP_RND_BITS_MAX;
+int mmap_rnd_bits = CONFIG_ARCH_MMAP_RND_BITS;
+#endif
+#ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
+int mmap_rnd_compat_bits_min = CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN;
+int mmap_rnd_compat_bits_max = CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX;
+int mmap_rnd_compat_bits = CONFIG_ARCH_MMAP_RND_COMPAT_BITS;
+#endif
+
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
_

Patches currently in -mm which might be from dcashman@google.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
x86-mm-support-arch_mmap_rnd_bits.patch

