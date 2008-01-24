From: akpm@linux-foundation.org
Subject: + cpufreq-fix-obvious-condition-statement-error.patch added to -mm tree
Date: Thu, 24 Jan 2008 06:19:23 -0800
Message-ID: <200801241419.m0OEJHOU029311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbYAXOUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jan 2008 09:20:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yi.y.yang@intel.com, akpm@linux-foundation.org, davej@codemonkey.org.uk, stable@kernel.org


The patch titled
     cpufreq: fix obvious condition statement error
has been added to the -mm tree.  Its filename is
     cpufreq-fix-obvious-condition-statement-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: fix obvious condition statement error
From: Yi Yang <yi.y.yang@intel.com>

The function __cpufreq_set_policy in file drivers/cpufreq/cpufreq.c
has a very obvious error:

        if (policy->min > data->min && policy->min > policy->max) {
                ret = -EINVAL;
                goto error_out;
        }

This condtion statement is wrong because it returns -EINVAL only if
policy->min is greater than policy->max (in this case,
"policy->min > data->min" is true for ever.). In fact, it should
return -EINVAL as well if policy->max is less than data->min.

The correct condition should be:

	if (policy->min > data->max || policy->max < data->min) {

The following test result testifies the above conclusion:

Before applying this patch:

[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
2394000 1596000
[root@yangyi-dev /]# echo 1596000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
1596000
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
1596000
[root@yangyi-dev /]# echo "2000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
-bash: echo: write error: Invalid argument
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
1596000
[root@yangyi-dev /]# echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
1596000
[root@yangyi-dev /]# echo "1595000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
1596000
[root@yangyi-dev /]#

After applying this patch:

[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
2394000 1596000
[root@yangyi-dev /]# echo 1596000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
1596000
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
1596000
[root@localhost /]# echo "2000000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
-bash: echo: write error: Invalid argument
[root@localhost /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
1596000
[root@localhost /]# echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
-bash: echo: write error: Invalid argument
[root@localhost /]# echo "1595000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
-bash: echo: write error: Invalid argument
[root@localhost /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
1596000
[root@localhost /]# echo "1596000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
[root@localhost /]# echo "2394000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
[root@localhost /]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
2394000
[root@localhost /]

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: <stable@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-fix-obvious-condition-statement-error drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-fix-obvious-condition-statement-error
+++ a/drivers/cpufreq/cpufreq.c
@@ -1635,7 +1635,7 @@ static int __cpufreq_set_policy(struct c
 	memcpy(&policy->cpuinfo, &data->cpuinfo,
 				sizeof(struct cpufreq_cpuinfo));
 
-	if (policy->min > data->min && policy->min > policy->max) {
+	if (policy->min > data->max || policy->max < data->min) {
 		ret = -EINVAL;
 		goto error_out;
 	}
_

Patches currently in -mm which might be from yi.y.yang@intel.com are

git-acpi.patch
cpufreq-fix-obvious-condition-statement-error.patch
