From: akpm@linux-foundation.org
Subject: + cpufreq-initialise-default-governor-before-use.patch added to -mm tree
Date: Sat, 22 Dec 2007 13:59:48 -0800
Message-ID: <200712222159.lBMLxmKZ021824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbXLVWAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 17:00:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, davej@codemonkey.org.uk, rjw@sisk.pl, venkatesh.pallipadi@intel.com


The patch titled
     cpufreq: Initialise default governor before use
has been added to the -mm tree.  Its filename is
     cpufreq-initialise-default-governor-before-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: Initialise default governor before use
From: Johannes Weiner <hannes@saeurebad.de>

When the cpufreq driver starts up at boot time, it calls into the default
governor which might not be initialised yet.  This hurts when the
governor's worker function relies on memory that is not yet set up by its
init function.

This migrates all governors from module_init() to fs_initcall() when being
the default, as was already done in cpufreq_performance when it was the
only possible choice.  The performance governor is always initialized early
because it might be used as fallback even when not being the default.

Fixes at least one actual oops where ondemand is the default governor and
cpufreq_governor_dbs() uses the uninitialised kondemand_wq work-queue
during boot-time.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_conservative.c |    4 ++++
 drivers/cpufreq/cpufreq_ondemand.c     |    5 ++++-
 drivers/cpufreq/cpufreq_userspace.c    |    4 ++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_conservative.c~cpufreq-initialise-default-governor-before-use drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~cpufreq-initialise-default-governor-before-use
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -603,5 +603,9 @@ MODULE_DESCRIPTION ("'cpufreq_conservati
 		"optimised for use in a battery environment");
 MODULE_LICENSE ("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+fs_initcall(cpufreq_gov_dbs_init);
+#else
 module_init(cpufreq_gov_dbs_init);
+#endif
 module_exit(cpufreq_gov_dbs_exit);
diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-initialise-default-governor-before-use drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-initialise-default-governor-before-use
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -610,6 +610,9 @@ MODULE_DESCRIPTION("'cpufreq_ondemand' -
                    "Low Latency Frequency Transition capable processors");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+fs_initcall(cpufreq_gov_dbs_init);
+#else
 module_init(cpufreq_gov_dbs_init);
+#endif
 module_exit(cpufreq_gov_dbs_exit);
-
diff -puN drivers/cpufreq/cpufreq_userspace.c~cpufreq-initialise-default-governor-before-use drivers/cpufreq/cpufreq_userspace.c
--- a/drivers/cpufreq/cpufreq_userspace.c~cpufreq-initialise-default-governor-before-use
+++ a/drivers/cpufreq/cpufreq_userspace.c
@@ -205,5 +205,9 @@ MODULE_AUTHOR ("Dominik Brodowski <linux
 MODULE_DESCRIPTION ("CPUfreq policy governor 'userspace'");
 MODULE_LICENSE ("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
 fs_initcall(cpufreq_gov_userspace_init);
+#else
+module_init(cpufreq_gov_userspace_init);
+#endif
 module_exit(cpufreq_gov_userspace_exit);
_

Patches currently in -mm which might be from hannes@saeurebad.de are

cpufreq-initialise-default-governor-before-use.patch
