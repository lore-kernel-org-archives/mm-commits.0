From: akpm@linux-foundation.org
Subject: + strip-config_-automatically-in-kernel-configuration-search.patch added to -mm tree
Date: Tue, 19 Jun 2007 13:53:21 -0700
Message-ID: <200706192053.l5JKrLgl020942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbXFSUyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 16:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, sam@ravnborg.org


The patch titled
     Strip 'CONFIG_' automatically in kernel configuration search
has been added to the -mm tree.  Its filename is
     strip-config_-automatically-in-kernel-configuration-search.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Strip 'CONFIG_' automatically in kernel configuration search
From: Bernhard Walle <bwalle@suse.de>

Modify the ncurses configuration tool ('make menuconfig') in a way that the
user can enter the search string (/) both with or without the leading
'CONFIG_'.

This simplifies using copy & paste from .config files because you can
select the whole word.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/mconf.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/mconf.c~strip-config_-automatically-in-kernel-configuration-search scripts/kconfig/mconf.c
--- a/scripts/kconfig/mconf.c~strip-config_-automatically-in-kernel-configuration-search
+++ a/scripts/kconfig/mconf.c
@@ -419,11 +419,13 @@ static void search_conf(void)
 {
 	struct symbol **sym_arr;
 	struct gstr res;
+	char *dialog_input;
 	int dres;
 again:
 	dialog_clear();
 	dres = dialog_inputbox(_("Search Configuration Parameter"),
-			      _("Enter CONFIG_ (sub)string to search for (omit CONFIG_)"),
+			      _("Enter CONFIG_ (sub)string to search for "
+				"(with or without \"CONFIG\")"),
 			      10, 75, "");
 	switch (dres) {
 	case 0:
@@ -435,7 +437,12 @@ again:
 		return;
 	}
 
-	sym_arr = sym_re_search(dialog_input_result);
+	/* strip CONFIG_ if necessary */
+	dialog_input = dialog_input_result;
+	if (strncasecmp(dialog_input_result, "CONFIG_", 7) == 0)
+		dialog_input += 7;
+
+	sym_arr = sym_re_search(dialog_input);
 	res = get_relations_str(sym_arr);
 	free(sym_arr);
 	show_textbox(_("Search Results"), str_get(&res), 0, 0);
_

Patches currently in -mm which might be from bwalle@suse.de are

strip-config_-automatically-in-kernel-configuration-search.patch
git-scsi-misc.patch
blink-only-blink-when-parameter-is-set.patch
blink-only-blink-when-parameter-is-set-fix.patch
