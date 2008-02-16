From: akpm@linux-foundation.org
Subject: + h8300-config_kallsyms-fix.patch added to -mm tree
Date: Fri, 15 Feb 2008 22:44:12 -0800
Message-ID: <200802160644.m1G6iC95012839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbYBPGo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 01:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp, sam@ravnborg.org


The patch titled
     h8300: CONFIG_KALLSYMS fix
has been added to the -mm tree.  Its filename is
     h8300-config_kallsyms-fix.patch

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
Subject: h8300: CONFIG_KALLSYMS fix
From: Yoshinori Sato <ysato@users.sourceforge.jp>

Please comment "C_SYMBOL_PREFIX".

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile           |    3 ++-
 arch/h8300/Kconfig |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN Makefile~h8300-config_kallsyms-fix Makefile
--- a/Makefile~h8300-config_kallsyms-fix
+++ a/Makefile
@@ -755,7 +755,8 @@ endef
 # Generate .S file with all kernel symbols
 quiet_cmd_kallsyms = KSYM    $@
       cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
-                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
+                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) \
+                     $(if $(CONFIG_C_SYMBOL_PREFIX),--symbol-prefix='_') > $@
 
 .tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
 	$(call if_changed_dep,as_o_S)
diff -puN arch/h8300/Kconfig~h8300-config_kallsyms-fix arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~h8300-config_kallsyms-fix
+++ a/arch/h8300/Kconfig
@@ -87,6 +87,10 @@ config HZ
 	int
 	default 100
 
+config C_SYMBOL_PREFIX
+	bool
+	default y
+
 source "init/Kconfig"
 
 source "arch/h8300/Kconfig.cpu"
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-signalc-typo-fix.patch
h8300-uaccessh-update.patch
h8300-config_kallsyms-fix.patch
h8300-irq-handling-update.patch
h8300-defconfig-update.patch
inflate-refactor-inflate-malloc-code.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
