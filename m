From: akpm@linux-foundation.org
Subject: + x86-fix-section-mismatch-warnings-in-mtrr.patch added to -mm tree
Date: Sun, 20 May 2007 20:42:45 -0700
Message-ID: <200705210342.l4L3giM7001718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUDoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org


The patch titled
     x86: fix section mismatch warnings in mtrr
has been added to the -mm tree.  Its filename is
     x86-fix-section-mismatch-warnings-in-mtrr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fix section mismatch warnings in mtrr
From: Sam Ravnborg <sam@ravnborg.org>

Following section mismatch warnings were reported by Andrey Borzenkov:

WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:amd_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967a) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:cyrix_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x967f) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text:centaur_init_mtrr from .text between 'mtrr_bp_init' (at offset 0x9684) and 'mtrr_attrib_to_str'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa735) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa749) and 'generic_get_mtrr'
WARNING: arch/i386/kernel/built-in.o - Section mismatch: reference to .init.text: from .text between 'get_mtrr_state' (at offset 0xa770) and 'generic_get_mtrr'

It was tracked down to a few functions missing __init tag.
Compile tested only.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/generic.c~x86-fix-section-mismatch-warnings-in-mtrr arch/i386/kernel/cpu/mtrr/generic.c
--- a/arch/i386/kernel/cpu/mtrr/generic.c~x86-fix-section-mismatch-warnings-in-mtrr
+++ a/arch/i386/kernel/cpu/mtrr/generic.c
@@ -78,7 +78,7 @@ static void __cpuinit print_fixed(unsign
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void get_mtrr_state(void)
+void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
diff -puN arch/i386/kernel/cpu/mtrr/main.c~x86-fix-section-mismatch-warnings-in-mtrr arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~x86-fix-section-mismatch-warnings-in-mtrr
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void mtrr_bp_init(void)
+void __init mtrr_bp_init(void)
 {
 	init_ifs();
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

git-kbuild.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
