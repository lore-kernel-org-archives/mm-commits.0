From: akpm@linux-foundation.org
Subject: + cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:49:02 -0700
Message-ID: <200706080049.l580n2f8014057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965033AbXFHAtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: add rating to the governors and pick the one with highest rating by default
has been added to the -mm tree.  Its filename is
     cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuidle: add rating to the governors and pick the one with highest rating by default
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Introduce a governor rating scheme to pick the right governor by default.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governor.c         |   33 ++++++++++++++++++++++++---
 drivers/cpuidle/governors/ladder.c |    1 
 drivers/cpuidle/governors/menu.c   |    1 
 include/linux/cpuidle.h            |    1 
 4 files changed, 33 insertions(+), 3 deletions(-)

diff -puN drivers/cpuidle/governor.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default drivers/cpuidle/governor.c
--- a/drivers/cpuidle/governor.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default
+++ a/drivers/cpuidle/governor.c
@@ -131,7 +131,8 @@ int cpuidle_register_governor(struct cpu
 	if (__cpuidle_find_governor(gov->name) == NULL) {
 		ret = 0;
 		list_add_tail(&gov->governor_list, &cpuidle_governors);
-		if (!cpuidle_curr_governor)
+		if (!cpuidle_curr_governor ||
+		    cpuidle_curr_governor->rating < gov->rating)
 			cpuidle_switch_governor(gov);
 	}
 	mutex_unlock(&cpuidle_lock);
@@ -142,6 +143,29 @@ int cpuidle_register_governor(struct cpu
 EXPORT_SYMBOL_GPL(cpuidle_register_governor);
 
 /**
+ * cpuidle_replace_governor - find a replacement governor
+ * @exclude_rating: the rating that will be skipped while looking for
+ * new governor.
+ */
+struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
+{
+	struct cpuidle_governor *gov;
+	struct cpuidle_governor *ret_gov = NULL;
+	unsigned int max_rating = 0;
+
+	list_for_each_entry(gov, &cpuidle_governors, governor_list) {
+		if (gov->rating == exclude_rating)
+			continue;
+		if (gov->rating > max_rating) {
+			max_rating = gov->rating;
+			ret_gov = gov;
+		}
+	}
+
+	return ret_gov;
+}
+
+/**
  * cpuidle_unregister_governor - unregisters a governor
  * @gov: the governor
  */
@@ -151,8 +175,11 @@ void cpuidle_unregister_governor(struct 
 		return;
 
 	mutex_lock(&cpuidle_lock);
-	if (gov == cpuidle_curr_governor)
-		cpuidle_switch_governor(NULL);
+	if (gov == cpuidle_curr_governor) {
+		struct cpuidle_governor *new_gov;
+		new_gov = cpuidle_replace_governor(gov->rating);
+		cpuidle_switch_governor(new_gov);
+	}
 	list_del(&gov->governor_list);
 	mutex_unlock(&cpuidle_lock);
 }
diff -puN drivers/cpuidle/governors/ladder.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default drivers/cpuidle/governors/ladder.c
--- a/drivers/cpuidle/governors/ladder.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default
+++ a/drivers/cpuidle/governors/ladder.c
@@ -199,6 +199,7 @@ static void ladder_exit_device(struct cp
 
 static struct cpuidle_governor ladder_governor = {
 	.name =		"ladder",
+	.rating =	10,
 	.init =		ladder_init_device,
 	.exit =		ladder_exit_device,
 	.scan =		ladder_scan_device,
diff -puN drivers/cpuidle/governors/menu.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default
+++ a/drivers/cpuidle/governors/menu.c
@@ -153,6 +153,7 @@ static void menu_scan_device(struct cpui
 
 struct cpuidle_governor menu_governor = {
 	.name =		"menu",
+	.rating =	20,
 	.scan =		menu_scan_device,
 	.select =	menu_select,
 	.reflect =	menu_reflect,
diff -puN include/linux/cpuidle.h~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default include/linux/cpuidle.h
--- a/include/linux/cpuidle.h~cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default
+++ a/include/linux/cpuidle.h
@@ -159,6 +159,7 @@ static inline int cpuidle_force_redetect
 struct cpuidle_governor {
 	char			name[CPUIDLE_NAME_LEN];
 	struct list_head 	governor_list;
+	unsigned int		rating;
 
 	int  (*init)		(struct cpuidle_device *dev);
 	void (*exit)		(struct cpuidle_device *dev);
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
