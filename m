From: akpm@linux-foundation.org
Subject: + cpufreq-fix-race-condition-in-store_scaling_governor.patch added to -mm tree
Date: Wed, 12 May 2010 15:00:45 -0700
Message-ID: <201005122200.o4CM0jrI023217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab0ELWBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 18:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrej.gelenberg@udo.edu, ashok.raj@intel.com, davej@redhat.com, linux@dominikbrodowski.net, trenn@suse.de, xiyou.wangcong@gmail.com


The patch titled
     cpufreq: fix race condition in store_scaling_governor
has been added to the -mm tree.  Its filename is
     cpufreq-fix-race-condition-in-store_scaling_governor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: fix race condition in store_scaling_governor
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>

Wrap store_scaling_governor() with mutex lock cpufreq_governor_mutex(). 
Fix kernel panic when switching the scaling governor very quickly.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15948

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-fix-race-condition-in-store_scaling_governor drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-fix-race-condition-in-store_scaling_governor
+++ a/drivers/cpufreq/cpufreq.c
@@ -399,8 +399,6 @@ static int cpufreq_parse_governor(char *
 	} else if (cpufreq_driver->target) {
 		struct cpufreq_governor *t;
 
-		mutex_lock(&cpufreq_governor_mutex);
-
 		t = __find_governor(str_governor);
 
 		if (t == NULL) {
@@ -425,8 +423,6 @@ static int cpufreq_parse_governor(char *
 			*governor = t;
 			err = 0;
 		}
-
-		mutex_unlock(&cpufreq_governor_mutex);
 	}
 out:
 	return err;
@@ -517,7 +513,7 @@ static ssize_t show_scaling_governor(str
 /**
  * store_scaling_governor - store policy for the specified CPU
  */
-static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
+static ssize_t _store_scaling_governor(struct cpufreq_policy *policy,
 					const char *buf, size_t count)
 {
 	unsigned int ret = -EINVAL;
@@ -549,6 +545,16 @@ static ssize_t store_scaling_governor(st
 		return count;
 }
 
+static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
+					const char *buf, size_t count)
+{
+	ssize_t ret;
+	mutex_lock(&cpufreq_governor_mutex);
+	ret = _store_scaling_governor(policy, buf, count);
+	mutex_unlock(&cpufreq_governor_mutex);
+	return ret;
+}
+
 /**
  * show_scaling_driver - show the cpufreq driver currently loaded
  */
_

Patches currently in -mm which might be from andrej.gelenberg@udo.edu are

origin.patch
cpufreq-fix-race-condition-in-store_scaling_governor.patch
cpufreq-fix-race-condition-in-store_scaling_governor-fix.patch

