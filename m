From: akpm@linux-foundation.org
Subject: - create-arch-kconfig.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:46 -0800
Message-ID: <200802032022.m13KMR9Q030019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44151 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbYBCU1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ananth@in.ibm.com, dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Create arch/Kconfig
has been removed from the -mm tree.  Its filename was
     create-arch-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[...]

The above suggestion is actually not exactly the best way to do it...
First the naming..
A quick grep shows following usage today (in Kconfig files)
ARCH_HAS        51
ARCH_SUPPORTS   4
HAVE_ARCH       7

ARCH_HAS is the clear winner.

In the common Kconfig file do:

config FOO
        depends on ARCH_HAS_FOO
        bool "bla bla"

config ARCH_HAS_FOO
        def_bool n

In the arch specific Kconfig file in a suitable place do:

config SUITABLE_OPTION
        select ARCH_HAS_FOO

The naming of ARCH_HAS_ is fixed and shall be:
ARCH_HAS_<config option it will enable>

Only a single line added pr. architecture.
And we will end up with a (maybe even commented) list of trivial selects.

- Yet another update :

Moving to HAVE_* now.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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
@@ -672,6 +672,8 @@ config PROC_PAGE_MONITOR
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
 
+source "arch/Kconfig"
+
 endmenu		# General setup
 
 config SLABINFO
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-kbuild.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
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
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
modules-handle-symbols-that-have-a-zero-value.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
