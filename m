From: akpm@linux-foundation.org
Subject: - create-arch-kconfig.patch removed from -mm tree
Date: Thu, 15 Nov 2007 18:08:55 -0800
Message-ID: <200711160208.lAG28uVh027178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758658AbXKPCJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 21:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, linux-arch@vger.kernel.org, sam@ravnborg.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Create arch/Kconfig
has been removed from the -mm tree.  Its filename was
     create-arch-kconfig.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Create arch/Kconfig
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Puts the content of arch/Kconfig in the "General setup" menu.

Linus:

> Should it come with a re-duplication of it's content into each
> architecture, which was the case previously ? The oprofile and kprobes
> menu entries were litteraly cut and pasted from one architecture to
> another. Should we put its content in init/Kconfig then ?

I don't think it's a good idea to go back to making it per-architecture,
although that extensive "depends on <list-of-archiectures-here>" might
indicate that there certainly is room for cleanup there.

And I don't think it's wrong keeping it in kernel/Kconfig.xyz per se, I
just think it's wrong to (a) lump the code together when it really doesn't
necessarily need to and (b) show it to users as some kind of choice that
is tied together (whether it then has common code or not).

On the per-architecture side, I do think it would be better to *not* have
internal architecture knowledge in a generic file, and as such a line like

        depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32

really shouldn't exist in a file like kernel/Kconfig.instrumentation.

It would be much better to do

        depends on ARCH_SUPPORTS_KPROBES

in that generic file, and then architectures that do support it would just
have a

        bool ARCH_SUPPORTS_KPROBES
                default y

in *their* architecture files. That would seem to be much more logical,
and is readable both for arch maintainers *and* for people who have no
clue - and don't care - about which architecture is supposed to support
which interface...


Sam Ravnborg:

Stuff it into a new file: arch/Kconfig
We can then extend this file to include all the 'trailing'
Kconfig things that are anyway equal for all ARCHs.

But it should be kept clean - so if we introduce such a file
then we should use ARCH_HAS_whatever in the arch specific Kconfig
files to enable stuff that is not shared.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    3 +++
 init/Kconfig |    2 ++
 2 files changed, 5 insertions(+)

diff -puN /dev/null arch/Kconfig
--- /dev/null
+++ a/arch/Kconfig
@@ -0,0 +1,3 @@
+#
+# General architecture dependent options
+#
diff -puN init/Kconfig~create-arch-kconfig init/Kconfig
--- a/init/Kconfig~create-arch-kconfig
+++ a/init/Kconfig
@@ -673,6 +673,8 @@ config PROC_PAGE_MONITOR
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
 
+source "arch/Kconfig"
+
 endmenu		# General setup
 
 config RT_MUTEXES
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
create-arch-kconfig.patch
add-arch_supports_oprofile.patch
add-arch_supports_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
