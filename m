From: akpm@linux-foundation.org
Subject: - cpufreq-fix-null-object-access-on-transmeta-cpu.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:30 -0700
Message-ID: <200806081948.m58JmUwG017513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490AbYFHTtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: masaki.chikama@gmail.com, cebbert@redhat.com, davej@codemonkey.org.uk, linux@dominikbrodowski.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cpufreq: fix null object access on Transmeta CPU
has been removed from the -mm tree.  Its filename was
     cpufreq-fix-null-object-access-on-transmeta-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: fix null object access on Transmeta CPU
From: CHIKAMA masaki <masaki.chikama@gmail.com>

If cpu specific cpufreq driver(i.e.  longrun) has "setpolicy" function,
governor object isn't set into cpufreq_policy object at "__cpufreq_set_policy"
function in driver/cpufreq/cpufreq.c .

This causes a null object access at "store_scaling_setspeed" and
"show_scaling_setspeed" function in driver/cpufreq/cpufreq.c when reading or
writing through /sys interface (ex.  cat
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed)

Addresses:
	http://bugzilla.kernel.org/show_bug.cgi?id=10654
	https://bugzilla.redhat.com/show_bug.cgi?id=443354

Signed-off-by: CHIKAMA Masaki <masaki.chikama@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-fix-null-object-access-on-transmeta-cpu drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-fix-null-object-access-on-transmeta-cpu
+++ a/drivers/cpufreq/cpufreq.c
@@ -625,7 +625,7 @@ static ssize_t store_scaling_setspeed(st
 	unsigned int freq = 0;
 	unsigned int ret;
 
-	if (!policy->governor->store_setspeed)
+	if (!policy->governor || !policy->governor->store_setspeed)
 		return -EINVAL;
 
 	ret = sscanf(buf, "%u", &freq);
@@ -639,7 +639,7 @@ static ssize_t store_scaling_setspeed(st
 
 static ssize_t show_scaling_setspeed(struct cpufreq_policy *policy, char *buf)
 {
-	if (!policy->governor->show_setspeed)
+	if (!policy->governor || !policy->governor->show_setspeed)
 		return sprintf(buf, "<unsupported>\n");
 
 	return policy->governor->show_setspeed(policy, buf);
_

Patches currently in -mm which might be from masaki.chikama@gmail.com are

origin.patch

