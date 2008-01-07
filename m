From: akpm@linux-foundation.org
Subject: - kconfig-obey-kconfig_allconfig-choices-with-randconfig.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:22 -0800
Message-ID: <200801072139.m07Ld2iT013531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbYAGVjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: obey KCONFIG_ALLCONFIG choices with randconfig.
has been removed from the -mm tree.  Its filename was
     kconfig-obey-kconfig_allconfig-choices-with-randconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: obey KCONFIG_ALLCONFIG choices with randconfig.
From: Paul Mundt <lethal@linux-sh.org>

Currently when using KCONFIG_ALLCONFIG with randconfig the choice options
are clobbered.  As recommended by Roman, this adds an is_new test to see
whether to select a new option or obey the existing one.

This is a resend of the earlier patch a couple of weeks ago, since there
was no reply.  Original thread is at http://lkml.org/lkml/2007/11/28/94

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/conf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/kconfig/conf.c~kconfig-obey-kconfig_allconfig-choices-with-randconfig scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~kconfig-obey-kconfig_allconfig-choices-with-randconfig
+++ a/scripts/kconfig/conf.c
@@ -374,7 +374,8 @@ static int conf_choice(struct menu *menu
 				continue;
 			break;
 		case set_random:
-			def = (random() % cnt) + 1;
+			if (is_new)
+				def = (random() % cnt) + 1;
 		case set_default:
 		case set_yes:
 		case set_mod:
_

Patches currently in -mm which might be from lethal@linux-sh.org are

git-acpi.patch
hp6xx-hp7xx-clean-up-drivers-input-keyboardtouchscreen-kconfigs.patch
git-sh.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
avoid-overflows-in-kernel-timec.patch
rtc-ds1302-rtc-support.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fb-defio-nopage.patch
use-bootmem_exclusive-for-kdump.patch
sanitize-the-type-of-struct-useru_ar0.patch
