From: akpm@linux-foundation.org
Subject: [merged] kconfig-do-not-hardcode-config-filename.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:53:44 -0700
Message-ID: <200906101753.n5AHri5F006319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbZFJR4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: do not hardcode ".config" filename
has been removed from the -mm tree.  Its filename was
     kconfig-do-not-hardcode-config-filename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: do not hardcode ".config" filename
From: Markus Heidelberg <markus.heidelberg@web.de>

Rather than hardcoding ".config" use conf_get_configname(), which also
respects the environment variable KCONFIG_CONFIG.

This fixes "make silentoldconfig" when KCONFIG_CONFIG is used and also
suggests the given filename for "Load" and "Save as" in qconf.

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/conf.c   |    7 ++++---
 scripts/kconfig/qconf.cc |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN scripts/kconfig/conf.c~kconfig-do-not-hardcode-config-filename scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~kconfig-do-not-hardcode-config-filename
+++ a/scripts/kconfig/conf.c
@@ -498,14 +498,15 @@ int main(int ac, char **av)
 	conf_parse(name);
 	//zconfdump(stdout);
 	if (sync_kconfig) {
-		if (stat(".config", &tmpstat)) {
+		name = conf_get_configname();
+		if (stat(name, &tmpstat)) {
 			fprintf(stderr, _("***\n"
 				"*** You have not yet configured your kernel!\n"
-				"*** (missing kernel .config file)\n"
+				"*** (missing kernel config file \"%s\")\n"
 				"***\n"
 				"*** Please run some configurator (e.g. \"make oldconfig\" or\n"
 				"*** \"make menuconfig\" or \"make xconfig\").\n"
-				"***\n"));
+				"***\n"), name);
 			exit(1);
 		}
 	}
diff -puN scripts/kconfig/qconf.cc~kconfig-do-not-hardcode-config-filename scripts/kconfig/qconf.cc
--- a/scripts/kconfig/qconf.cc~kconfig-do-not-hardcode-config-filename
+++ a/scripts/kconfig/qconf.cc
@@ -1448,7 +1448,7 @@ ConfigMainWindow::ConfigMainWindow(void)
 
 void ConfigMainWindow::loadConfig(void)
 {
-	QString s = QFileDialog::getOpenFileName(".config", NULL, this);
+	QString s = QFileDialog::getOpenFileName(conf_get_configname(), NULL, this);
 	if (s.isNull())
 		return;
 	if (conf_read(QFile::encodeName(s)))
@@ -1464,7 +1464,7 @@ void ConfigMainWindow::saveConfig(void)
 
 void ConfigMainWindow::saveConfigAs(void)
 {
-	QString s = QFileDialog::getSaveFileName(".config", NULL, this);
+	QString s = QFileDialog::getSaveFileName(conf_get_configname(), NULL, this);
 	if (s.isNull())
 		return;
 	if (conf_write(QFile::encodeName(s)))
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

linux-next.patch

