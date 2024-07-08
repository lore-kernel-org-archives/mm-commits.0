Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC97A29
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 22:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720476272; cv=none; b=Tx5kMyPY/RCUDWtgcSib99xBtzryfhJDQ6tG+V7TiNZj7lHtzg4clNpK+mZOlWm1CBa0lOfFjJabk2F1yT2LdN+7uSCO7uzh1q8eHNRSkmKMRF6o11sNwBGRxgkV6fIZObCAkPEoHra+3Q2ref/R8E9At38btE4MbiODeMEIv1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720476272; c=relaxed/simple;
	bh=h67hN0s0MSwiAxSu2VVwPHycj1afUuy0B4m98J7RjFE=;
	h=Date:To:From:Subject:Message-Id; b=QHCm4Vj+wntrERQpFNyxnXW6o248/6g70ohn+FegIrH5ms56O5zVZaC5At5vPyA5mHepxc03LHqY0OTh5MV/acqE2z26beYT7myw6FIGKIQ4+IjO5A+QOCxppTnMfFvMBEztBfmLnk1Z7oIZgFPqYXmL86POhpQZdyPku4+Fzv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bMprJUF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bMprJUF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D3BC116B1;
	Mon,  8 Jul 2024 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720476271;
	bh=h67hN0s0MSwiAxSu2VVwPHycj1afUuy0B4m98J7RjFE=;
	h=Date:To:From:Subject:From;
	b=bMprJUF/sMI9opZDyhKMUh7DzNVFuTR+1kVNRA5JzIj02kU1OKXAxxjPmPuwLQZfS
	 DPXo4Errc8QVnuTclJXUBiZ81bG8wgQ1s9x4cZIbJ3OFvONuHFn424zq6d/vW3MIPe
	 JoqknwhD+XmxDubtf7FP0zQiotak9k5G5hrOTItQ=
Date: Mon, 08 Jul 2024 15:04:31 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,masahiroy@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-modpost-conditionally-check-section-mismatch-to-__meminit.patch added to mm-nonmm-unstable branch
Message-Id: <20240708220431.D6D3BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/modpost: conditionally check section mismatch to __meminit*
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-modpost-conditionally-check-section-mismatch-to-__meminit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-modpost-conditionally-check-section-mismatch-to-__meminit.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init/modpost: conditionally check section mismatch to __meminit*
Date: Sun, 7 Jul 2024 01:05:06 +0900

This reverts commit eb8f689046b8 ("Use separate sections for __dev/
_cpu/__mem code/data").

Check section mismatch to __meminit* only when CONFIG_MEMORY_HOTPLUG=n.

With this change, the linker script and modpost become simpler, and we
can get rid of the __ref annotations from the memory hotplug code.

Link: https://lkml.kernel.org/r/20240706160511.2331061-2-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   18 ++----------------
 include/linux/init.h              |   14 +++++++++-----
 scripts/mod/modpost.c             |   19 ++++---------------
 3 files changed, 15 insertions(+), 36 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h~init-modpost-conditionally-check-section-mismatch-to-__meminit
+++ a/include/asm-generic/vmlinux.lds.h
@@ -141,14 +141,6 @@
  * often happens at runtime)
  */
 
-#if defined(CONFIG_MEMORY_HOTPLUG)
-#define MEM_KEEP(sec)    *(.mem##sec)
-#define MEM_DISCARD(sec)
-#else
-#define MEM_KEEP(sec)
-#define MEM_DISCARD(sec) *(.mem##sec)
-#endif
-
 #ifndef CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
 #define KEEP_PATCHABLE		KEEP(*(__patchable_function_entries))
 #define PATCHABLE_DISCARDS
@@ -357,7 +349,6 @@
 	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
-	MEM_KEEP(init.data*)						\
 	*(.data.unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
@@ -542,7 +533,6 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		MEM_KEEP(init.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
@@ -593,8 +583,7 @@
 		*(.text.unknown .text.unknown.*)			\
 		NOINSTR_TEXT						\
 		*(.ref.text)						\
-		*(.text.asan.* .text.tsan.*)				\
-	MEM_KEEP(init.text*)						\
+		*(.text.asan.* .text.tsan.*)
 
 
 /* sched.text is aling to function alignment to secure we have same
@@ -701,7 +690,6 @@
 #define INIT_DATA							\
 	KEEP(*(SORT(___kentry+*)))					\
 	*(.init.data .init.data.*)					\
-	MEM_DISCARD(init.data*)						\
 	KERNEL_CTORS()							\
 	MCOUNT_REC()							\
 	*(.init.rodata .init.rodata.*)					\
@@ -709,7 +697,6 @@
 	TRACE_SYSCALLS()						\
 	KPROBE_BLACKLIST()						\
 	ERROR_INJECT_WHITELIST()					\
-	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	RESERVEDMEM_OF_TABLES()						\
 	TIMER_OF_TABLES()						\
@@ -727,8 +714,7 @@
 
 #define INIT_TEXT							\
 	*(.init.text .init.text.*)					\
-	*(.text.startup)						\
-	MEM_DISCARD(init.text*)
+	*(.text.startup)
 
 #define EXIT_DATA							\
 	*(.exit.data .exit.data.*)					\
--- a/include/linux/init.h~init-modpost-conditionally-check-section-mismatch-to-__meminit
+++ a/include/linux/init.h
@@ -84,11 +84,15 @@
 
 #define __exit          __section(".exit.text") __exitused __cold notrace
 
-/* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(".meminit.text") __cold notrace \
-						  __latent_entropy
-#define __meminitdata    __section(".meminit.data")
-#define __meminitconst   __section(".meminit.rodata")
+#ifdef CONFIG_MEMORY_HOTPLUG
+#define __meminit
+#define __meminitdata
+#define __meminitconst
+#else
+#define __meminit	__init
+#define __meminitdata	__initdata
+#define __meminitconst	__initconst
+#endif
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
--- a/scripts/mod/modpost.c~init-modpost-conditionally-check-section-mismatch-to-__meminit
+++ a/scripts/mod/modpost.c
@@ -776,17 +776,14 @@ static void check_section(const char *mo
 
 
 #define ALL_INIT_DATA_SECTIONS \
-	".init.setup", ".init.rodata", ".meminit.rodata", \
-	".init.data", ".meminit.data"
+	".init.setup", ".init.rodata", ".init.data"
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
 	".pci_fixup_enable", ".pci_fixup_resume", \
 	".pci_fixup_resume_early", ".pci_fixup_suspend"
 
-#define ALL_XXXINIT_SECTIONS ".meminit.*"
-
-#define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
+#define ALL_INIT_SECTIONS ".init.*"
 #define ALL_EXIT_SECTIONS ".exit.*"
 
 #define DATA_SECTIONS ".data", ".data.rel"
@@ -797,9 +794,7 @@ static void check_section(const char *mo
 		".fixup", ".entry.text", ".exception.text", \
 		".coldtext", ".softirqentry.text"
 
-#define INIT_SECTIONS      ".init.*"
-
-#define ALL_TEXT_SECTIONS  ".init.text", ".meminit.text", ".exit.text", \
+#define ALL_TEXT_SECTIONS  ".init.text", ".exit.text", \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
 
 enum mismatch {
@@ -839,12 +834,6 @@ static const struct sectioncheck section
 	.bad_tosec = { ALL_INIT_SECTIONS, ALL_EXIT_SECTIONS, NULL },
 	.mismatch = TEXTDATA_TO_ANY_INIT_EXIT,
 },
-/* Do not reference init code/data from meminit code/data */
-{
-	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
-	.bad_tosec = { INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_SOME_INIT,
-},
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
@@ -859,7 +848,7 @@ static const struct sectioncheck section
 },
 {
 	.fromsec = { ALL_PCI_INIT_SECTIONS, NULL },
-	.bad_tosec = { INIT_SECTIONS, NULL },
+	.bad_tosec = { ALL_INIT_SECTIONS, NULL },
 	.mismatch = ANY_INIT_TO_ANY_EXIT,
 },
 {
_

Patches currently in -mm which might be from masahiroy@kernel.org are

init-remove-unused-__meminit-macros.patch
init-modpost-conditionally-check-section-mismatch-to-__meminit.patch

