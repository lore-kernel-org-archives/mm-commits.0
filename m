From: akpm@linux-foundation.org
Subject: - menuconfig-distinguish-between-selected-by-another-options-and-comments.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:44 -0700
Message-ID: <200710102110.l9ALAimd025952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbXJJVWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: strohel@gmail.com, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     menuconfig: distinguish between selected-by-another options and comments
has been removed from the -mm tree.  Its filename was
     menuconfig-distinguish-between-selected-by-another-options-and-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: menuconfig: distinguish between selected-by-another options and comments
From: Matej Laitl <strohel@gmail.com>

menuconfig currently represents options implied by another option ('select'
directive in Kconfig) by prefixing them with '---'.  Unfortunately the same
notation is used for comments.  If the implied option is module capable,
user can still switch between Y and M, all without any feedback until she
visits option's help.  (try saying M to MAC80211 and then toggling
CFG80211)

This patch changes notation of selected-by-another items by introducing 2
new representations for implied options: {*} or {M} for options selected by
another modularized one, thus builtin or module capable, -*- or -M- for
options that cannot be at the moment changed by user.

The idea is to represent actual capability of the option by braces (dashes)
around and to always report actual state by * or M inside.

Signed-off-by: Matej Laitl <strohel@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/mconf.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN scripts/kconfig/mconf.c~menuconfig-distinguish-between-selected-by-another-options-and-comments scripts/kconfig/mconf.c
--- a/scripts/kconfig/mconf.c~menuconfig-distinguish-between-selected-by-another-options-and-comments
+++ a/scripts/kconfig/mconf.c
@@ -35,9 +35,13 @@ static const char mconf_readme[] = N_(
 "kernel parameters which are not really features, but must be\n"
 "entered in as decimal or hexadecimal numbers or possibly text.\n"
 "\n"
-"Menu items beginning with [*], <M> or [ ] represent features\n"
-"configured to be built in, modularized or removed respectively.\n"
-"Pointed brackets <> represent module capable features.\n"
+"Menu items beginning with following braces represent features that\n"
+"  [ ] can be built in or removed\n"
+"  < > can be built in, modularized or removed\n"
+"  { } can be built in or modularized (selected by other feature)\n"
+"  - - are selected by other feature,\n"
+"while *, M or whitespace inside braces means to build in, build as\n"
+"a module or to exclude the feature respectively.\n"
 "\n"
 "To change any of these features, highlight it with the cursor\n"
 "keys and press <Y> to build it in, <M> to make it a module or\n"
@@ -569,7 +573,7 @@ static void build_conf(struct menu *menu
 				if (sym_is_changable(sym))
 					item_make("[%c]", val == no ? ' ' : '*');
 				else
-					item_make("---");
+					item_make("-%c-", val == no ? ' ' : '*');
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
@@ -579,10 +583,13 @@ static void build_conf(struct menu *menu
 				case mod: ch = 'M'; break;
 				default:  ch = ' '; break;
 				}
-				if (sym_is_changable(sym))
-					item_make("<%c>", ch);
-				else
-					item_make("---");
+				if (sym_is_changable(sym)) {
+					if (sym->rev_dep.tri == mod)
+						item_make("{%c}", ch);
+					else
+						item_make("<%c>", ch);
+				} else
+					item_make("-%c-", ch);
 				item_set_tag('t');
 				item_set_data(menu);
 				break;
_

Patches currently in -mm which might be from strohel@gmail.com are

git-kbuild.patch
