From: akpm@osdl.org
Subject: - some-kbuild-fix.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:31 -0800
Message-ID: <200612130651.kBD6pVXE030353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964967AbWLMGwI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, ak@suse.de, dsd@gentoo.org, horst@schirmeier.com, jbeulich@novell.com, jpdenheijer@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: don't put temp files in source
has been removed from the -mm tree.  Its filename was
     some-kbuild-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kbuild: don't put temp files in source
From: Roman Zippel <zippel@linux-m68k.org>

The as-instr/ld-option need to create temporary files, but create them in the
output directory, when compiling external modules.  Reformat them a bit and
use $(CC) instead of $(AS) as the former is used by kbuild to assemble files.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <jpdenheijer@gmail.com>
Cc: Horst Schirmeier <horst@schirmeier.com>
Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/Kbuild.include |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN scripts/Kbuild.include~some-kbuild-fix scripts/Kbuild.include
--- a/scripts/Kbuild.include~some-kbuild-fix
+++ a/scripts/Kbuild.include
@@ -56,6 +56,9 @@ endef
 # gcc support functions
 # See documentation in Documentation/kbuild/makefiles.txt
 
+# output directory for tests below
+TMPOUT := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/)
+
 # as-option
 # Usage: cflags-y += $(call as-option, -Wa$(comma)-isa=foo,)
 
@@ -66,9 +69,11 @@ as-option = $(shell if $(CC) $(CFLAGS) $
 # as-instr
 # Usage: cflags-y += $(call as-instr, instr, option1, option2)
 
-as-instr = $(shell if echo -e "$(1)" | $(AS) >/dev/null 2>&1 -W -Z -o astest$$$$.out ; \
-		   then echo "$(2)"; else echo "$(3)"; fi; \
-	           rm -f astest$$$$.out)
+as-instr = $(shell if echo -e "$(1)" | \
+		      $(CC) $(AFLAGS) -c -xassembler - \
+			    -o $(TMPOUT)astest$$$$.out > /dev/null 2>&1; \
+		   then rm $(TMPOUT)astest$$$$.out; echo "$(2)"; \
+		   else echo "$(3)"; fi)
 
 # cc-option
 # Usage: cflags-y += $(call cc-option, -march=winchip-c6, -march=i586)
@@ -97,10 +102,10 @@ cc-ifversion = $(shell if [ $(call cc-ve
 
 # ld-option
 # Usage: ldflags += $(call ld-option, -Wl$(comma)--hash-style=both)
-ld-option = $(shell if $(CC) $(1) \
-			     -nostdlib -o ldtest$$$$.out -xc /dev/null \
-             > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi; \
-	     rm -f ldtest$$$$.out)
+ld-option = $(shell if $(CC) $(1) -nostdlib -xc /dev/null \
+			     -o $(TMPOUT)ldtest$$$$.out > /dev/null 2>&1; \
+             then rm $(TMPOUT)ldtest$$$$.out; echo "$(1)"; \
+             else echo "$(2)"; fi)
 
 ###
 # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.build obj=
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
kconfig-new-function-bool-conf_get_changedvoid.patch
kconfig-make-sym_change_count-static-let-it-be-altered-by-2-functions-only.patch
kconfig-add-void-conf_set_changed_callbackvoid-fnvoid-use-it-in-qconfcc.patch
kconfig-set-gconfs-save-widgets-sensitivity-according-to-configs-changed-state.patch
git-lxdialog.patch
m68k-work-around-binutils-tokenizer-change.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-high-res-timers-core.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
updated-dynticks-core-code.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-debugging-feature-timer-stats.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

