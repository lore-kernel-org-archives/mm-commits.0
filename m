From: akpm@linux-foundation.org
Subject: - dontdiff-more-updates-to-be-closer-to-gitignore.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:55 -0700
Message-ID: <200810182311.m9INBtf7027825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbYJRXMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Uwe.Kleine-Koenig@digi.com, bart.vanassche@gmail.com, daniel@danielguilak.com, den@openvz.org, eduard.munteanu@linux360.ro, efault@gmx.de, etienne_lorrain@yah


The patch titled
     dontdiff: more updates to be closer to gitignore
has been removed from the -mm tree.  Its filename was
     dontdiff-more-updates-to-be-closer-to-gitignore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dontdiff: more updates to be closer to gitignore
From: Randy Dunlap <randy.dunlap@oracle.com>

defkeymap.c_shipped should be diffed if it is changed.
Reported-by: Mike Galbraith <efault@gmx.de>

COPYING, CREDITS, .mailmap should be diffed if they are changed.
keywords.c_shipped & lex.c_shipped should be diffed when changed.
parse.[ch]_shipped should be diffed when changed.
Reported-by: Sam Ravnborg <sam@ravnborg.org>

vsyscall* updates from a .gitignore patch by "Denis V. Lunev" <den@openvz.org>.

*.so.dbg from a .gitignore patch by Thomas Gleixner <tglx@linutronix.de>.

binoffset from a .gitignore patch by Uwe Kleine-Koenig
<Uwe.Kleine-Koenig@digi.com>.

Module.markers from a .gitignore patch by Matthew Wilcox
<willy@linux.intel.com>.

vmlinux*.lds* should be diffed if changed.
Reported-by: Etienne Lorrain <etienne_lorrain@yahoo.fr>

vmlinux.lds from a .gitignore patch by Daniel Guilak
<daniel@danielguilak.com>.

*.scr should be diffed if changed.

Lots of updates from http://lkml.org/lkml/2008/5/20/32 Reported-by: Bart
Van Assche <bart.vanassche@gmail.com>

Use ncscope.* instead of *cscope* since the latter may catch too many files.

Add *.elf, from a .gitignore patch by Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>.

Make firmware entries match .gitignore entries.

Make some entries less greedy by removing trailing '*'.

Remove "make_times_h" (no such file).
Remove "filelist" (no such file).
Remove "dummy_sym.c" (no such file).
Remove "gen-kdb_cmds.c" (no such file).
Remove "gentbl" (no such file).
Remove "kconfig.tk" (no such file).
Remove "tkparse" (no such file).
Remove "sim710_d.h" (no such file).
Remove "53c8xx_d.h" (no such file).
Add "syscalltab.h" (generated file).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dontdiff |   59 +++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff -puN Documentation/dontdiff~dontdiff-more-updates-to-be-closer-to-gitignore Documentation/dontdiff
--- a/Documentation/dontdiff~dontdiff-more-updates-to-be-closer-to-gitignore
+++ a/Documentation/dontdiff
@@ -2,11 +2,13 @@
 *.aux
 *.bin
 *.cpio
-*.css
+*.csp
+*.dsp
 *.dvi
+*.elf
 *.eps
-*.fw.gen.S
 *.fw
+*.gen.S
 *.gif
 *.grep
 *.grp
@@ -30,6 +32,7 @@
 *.s
 *.sgml
 *.so
+*.so.dbg
 *.symtypes
 *.tab.c
 *.tab.h
@@ -38,24 +41,17 @@
 *.xml
 *_MODULES
 *_vga16.c
-*cscope*
 *~
 *.9
 *.9.gz
 .*
-.cscope
-.gitignore
-.mailmap
 .mm
 53c700_d.h
-53c8xx_d.h*
-COPYING
-CREDITS
 CVS
 ChangeSet
 Image
 Kerntypes
-MODS.txt
+Module.markers
 Module.symvers
 PENDING
 SCCS
@@ -73,7 +69,9 @@ autoconf.h*
 bbootsect
 bin2c
 binkernel.spec
+binoffset
 bootsect
+bounds.h
 bsetup
 btfixupprep
 build
@@ -89,39 +87,36 @@ config_data.h*
 config_data.gz*
 conmakehash
 consolemap_deftbl.c*
+cpustr.h
 crc32table.h*
 cscope.*
-defkeymap.c*
+defkeymap.c
 devlist.h*
 docproc
-dummy_sym.c*
 elf2ecoff
 elfconfig.h*
-filelist
 fixdep
 fore200e_mkfirm
 fore200e_pca_fw.c*
 gconf
 gen-devlist
-gen-kdb_cmds.c*
 gen_crc32table
 gen_init_cpio
 genksyms
-gentbl
 *_gray256.c
+ihex2fw
 ikconfig.h*
 initramfs_data.cpio
 initramfs_data.cpio.gz
 initramfs_list
 kallsyms
 kconfig
-kconfig.tk
-keywords.c*
+keywords.c
 ksym.c*
 ksym.h*
 kxgettext
 lkc_defs.h
-lex.c*
+lex.c
 lex.*.c
 logo_*.c
 logo_*_clut224.c
@@ -130,7 +125,6 @@ lxdialog
 mach-types
 mach-types.h
 machtypes.h
-make_times_h
 map
 maui_boot.h
 mconf
@@ -138,6 +132,7 @@ miboot*
 mk_elfconfig
 mkboot
 mkbugboot
+mkcpustr
 mkdep
 mkprep
 mktables
@@ -145,11 +140,12 @@ mktree
 modpost
 modules.order
 modversions.h*
+ncscope.*
 offset.h
 offsets.h
 oui.c*
-parse.c*
-parse.h*
+parse.c
+parse.h
 patches*
 pca200e.bin
 pca200e_ecd.bin2
@@ -157,7 +153,7 @@ piggy.gz
 piggyback
 pnmtologo
 ppc_defs.h*
-promcon_tbl.c*
+promcon_tbl.c
 pss_boot.h
 qconf
 raid6altivec*.c
@@ -168,27 +164,38 @@ series
 setup
 setup.bin
 setup.elf
-sim710_d.h*
 sImage
 sm_tbl*
 split-include
+syscalltab.h
 tags
 tftpboot.img
 timeconst.h
 times.h*
-tkparse
 trix_boot.h
 utsrelease.h*
+vdso-syms.lds
 vdso.lds
+vdso32-int80-syms.lds
+vdso32-syms.lds
+vdso32-syscall-syms.lds
+vdso32-sysenter-syms.lds
+vdso32.lds
+vdso32.so.dbg
+vdso64.lds
+vdso64.so.dbg
 version.h*
 vmlinux
 vmlinux-*
 vmlinux.aout
-vmlinux*.lds*
-vmlinux*.scr
+vmlinux.lds
 vsyscall.lds
+vsyscall_32.lds
 wanxlfw.inc
 uImage
 unifdef
+wakeup.bin
+wakeup.elf
+wakeup.lds
 zImage*
 zconf.hash.c
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

