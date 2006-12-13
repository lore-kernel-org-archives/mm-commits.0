From: akpm@osdl.org
Subject: - clocksource-add-usage-of-config_sysfs.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:38 -0800
Message-ID: <200612130655.kBD6tcio030659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58438 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbWLMHEJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 02:04:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: add usage of CONFIG_SYSFS
has been removed from the -mm tree.  Its filename was
     clocksource-add-usage-of-config_sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: add usage of CONFIG_SYSFS
From: Daniel Walker <dwalker@mvista.com>

Simply adds some ifdefs to remove clocksoure sysfs code when CONFIG_SYSFS
isn't turn on.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/clocksource.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/time/clocksource.c~clocksource-add-usage-of-config_sysfs kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-usage-of-config_sysfs
+++ a/kernel/time/clocksource.c
@@ -186,6 +186,7 @@ void clocksource_reselect(void)
 }
 EXPORT_SYMBOL(clocksource_reselect);
 
+#ifdef CONFIG_SYSFS
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
  * @dev:	unused
@@ -307,6 +308,7 @@ static int __init init_clocksource_sysfs
 }
 
 device_initcall(init_clocksource_sysfs);
+#endif /* CONFIG_SYSFS */
 
 /**
  * boot_override_clocksource - boot clock override
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch

