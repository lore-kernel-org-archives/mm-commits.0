From: akpm@linux-foundation.org
Subject: + power-management-implement-pm_opsvalid-for-everybody-fix.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:48:44 -0700
Message-ID: <200704280048.l3S0mi3j011821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757972AbXD1Atf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, david-b@pacbell.net, greg@kroah.com, pavel@ucw.cz, rjw@sisk.pl, rmk@arm.linux.org.uk


The patch titled
     re-add pnx4008 standby mode
has been added to the -mm tree.  Its filename is
     power-management-implement-pm_opsvalid-for-everybody-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: re-add pnx4008 standby mode
From: Johannes Berg <johannes@sipsolutions.net>

I just noticed that when I was cleaning up the pm_ops implementations I
accidentally removed the standby mode from pnx4008 by not marking it
valid. This patch adds it back and also removes some useless related
code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pnx4008/pm.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/arm/mach-pnx4008/pm.c~power-management-implement-pm_opsvalid-for-everybody-fix arch/arm/mach-pnx4008/pm.c
--- a/arch/arm/mach-pnx4008/pm.c~power-management-implement-pm_opsvalid-for-everybody-fix
+++ a/arch/arm/mach-pnx4008/pm.c
@@ -107,17 +107,19 @@ static int pnx4008_pm_enter(suspend_stat
 	case PM_SUSPEND_MEM:
 		pnx4008_suspend();
 		break;
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-	default:
-		return -EINVAL;
 	}
 	return 0;
 }
 
+static int pnx4008_pm_valid(suspend_state_t state)
+{
+	return (state == PM_SUSPEND_STANDBY) ||
+	       (state == PM_SUSPEND_MEM);
+}
+
 static struct pm_ops pnx4008_pm_ops = {
 	.enter = pnx4008_pm_enter,
-	.valid = pm_valid_only_mem,
+	.valid = pnx4008_pm_valid,
 };
 
 static int __init pnx4008_pm_init(void)
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
power-management-implement-pm_opsvalid-for-everybody-fix.patch
power-management-force-pm_opsvalid-callback-to-be.patch
git-alsa.patch
git-powerpc.patch
git-powerpc-arch-powerpc-sysdev-timerc-build-fix.patch
s2ram-add-arch-irq-disable-enable-hooks.patch
git-netdev-all-export-ieee80211_debug_level.patch
git-net.patch
remove-software_suspend.patch
power-management-change-sys-power-disk-display.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
kernel-doc-html-mode-struct-highlights.patch
