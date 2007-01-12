From: akpm@osdl.org
Subject: - qconf-fix-sigsegv-on-empty-menu-items.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:17:38 -0800
Message-ID: <200701122217.l0CMHc1Q030742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161137AbXALWRw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:17:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     qconf: (re)fix SIGSEGV on empty menu items
has been removed from the -mm tree.  Its filename was
     qconf-fix-sigsegv-on-empty-menu-items.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qconf: (re)fix SIGSEGV on empty menu items
From: Roman Zippel <zippel@linux-m68k.org>

Back out the recent fix for this bug, fix it by correctly initialising
ConfigInfoView.sym.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/kconfig/qconf.cc |   15 ++++-----------
 scripts/kconfig/qconf.h  |    2 --
 2 files changed, 4 insertions(+), 13 deletions(-)

diff -puN scripts/kconfig/qconf.cc~qconf-fix-sigsegv-on-empty-menu-items scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~qconf-fix-sigsegv-on-empty-menu-items
+++ a/scripts/kconfig/qconf.cc
@@ -917,7 +917,7 @@ void ConfigView::updateListAll(void)
 }
 
 ConfigInfoView::ConfigInfoView(QWidget* parent, const char *name)
-	: Parent(parent, name), menu(0)
+	: Parent(parent, name), menu(0), sym(0)
 {
 	if (name) {
 		configSettings->beginGroup(name);
@@ -925,8 +925,6 @@ ConfigInfoView::ConfigInfoView(QWidget* 
 		configSettings->endGroup();
 		connect(configApp, SIGNAL(aboutToQuit()), SLOT(saveSettings()));
 	}
-
-	has_dbg_info = 0;
 }
 
 void ConfigInfoView::saveSettings(void)
@@ -955,13 +953,11 @@ void ConfigInfoView::setInfo(struct menu
 	if (menu == m)
 		return;
 	menu = m;
-	if (!menu) {
-		has_dbg_info = 0;
+	sym = NULL;
+	if (!menu)
 		clear();
-	} else {
-		has_dbg_info = 1;
+	else
 		menuInfo();
-       }
 }
 
 void ConfigInfoView::setSource(const QString& name)
@@ -996,9 +992,6 @@ void ConfigInfoView::symbolInfo(void)
 {
 	QString str;
 
-	if (!has_dbg_info)
-		return;
-
 	str += "<big>Symbol: <b>";
 	str += print_filter(sym->name);
 	str += "</b></big><br><br>value: ";
diff -puN scripts/kconfig/qconf.h~qconf-fix-sigsegv-on-empty-menu-items scripts/kconfig/qconf.h
--- a/scripts/kconfig/qconf.h~qconf-fix-sigsegv-on-empty-menu-items
+++ a/scripts/kconfig/qconf.h
@@ -273,8 +273,6 @@ protected:
 	struct symbol *sym;
 	struct menu *menu;
 	bool _showDebug;
-
-	int has_dbg_info;
 };
 
 class ConfigSearchWindow : public QDialog {
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
kbuild-dont-ignore-localversion-files-if-the-path-includes-a.patch
qconf-relocate-search-command.patch
git-lxdialog.patch
m68k-work-around-binutils-tokenizer-change.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
clockevents-core.patch
clockevents-i386-drivers.patch
high-res-timers-core.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
