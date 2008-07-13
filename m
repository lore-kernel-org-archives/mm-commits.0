From: akpm@linux-foundation.org
Subject: + inith-remove-obsolete-content-from.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:50:13 -0700
Message-ID: <200807130650.m6D6oDJn008777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbYGMGuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     init.h: remove obsolete content from
has been added to the -mm tree.  Its filename is
     inith-remove-obsolete-content-from.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init.h: remove obsolete content from
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Remove apparently obsolete content from init.h referring to gcc 2.9x
and to "no_module_init".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN include/linux/init.h~inith-remove-obsolete-content-from include/linux/init.h
--- a/include/linux/init.h~inith-remove-obsolete-content-from
+++ a/include/linux/init.h
@@ -285,13 +285,7 @@ void __init parse_early_param(void);
 
 #define security_initcall(fn)		module_init(fn)
 
-/* These macros create a dummy inline: gcc 2.9x does not count alias
- as usage, hence the `unused function' warning when __init functions
- are declared static. We use the dummy __*_module_inline functions
- both to kill the warning and check the type of the init/cleanup
- function. */
-
-/* Each module must use one module_init(), or one no_module_init */
+/* Each module must use one module_init(). */
 #define module_init(initfn)					\
 	static inline initcall_t __inittest(void)		\
 	{ return initfn; }					\
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
m32r-remove-the-unused-nohighmem-option.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
alpha-remove-the-unused-alpha_core_agp-option.patch
remove-include-linux-pm_legacyh.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
spi-kconfig-simplifications.patch
pty-remove-unused-unix98_pty_count-options.patch
inith-remove-obsolete-content-from.patch

