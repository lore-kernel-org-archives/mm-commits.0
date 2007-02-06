From: akpm@linux-foundation.org
Subject: - rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:11:07 -0800
Message-ID: <200702060012.l160CA0Y003840@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40794 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbXBFAMj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:12:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, davej@codemonkey.org.uk, ego@in.ibm.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix 3
has been removed from the -mm tree.  Its filename was
     rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch

This patch was dropped because it was folded into rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch

------------------------------------------------------
Subject: rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix 3
From: Mattia Dongili <malattia@linux.it>

On Sat, Jan 06, 2007 at 08:44:51AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 04 Jan 2007 22:02:00 PST, Andrew Morton said:
> > 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc3/2.6.20-rc3-mm1/
>
> One of these 3 patches:
>
> rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
> rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
> ondemand-governor-restructure-the-work-callback.patch
>
> causes an oops in kref_put during early boot ("unable to handle paging
> request at 00078").
>
> Dell Latitude D820 laptop, Core2 T7200 with a 64-bit kernel.
>
> Hand-copied trace of the oops:
>
> kobject_put+0x19/0x1b
> cpufreq_cpu_put+0xd/0x1e
> cpufreq_get+0x45/0x51
> handle_cpufreq_delayed_get+0x1e/0x41
> run_workqueue+0x9c/0x14e
> worker_thread+0x0/0x145
> worker_thread+0x10e/0x145
> default_wake_function+0x0/0xf
> worker_thread+0x0/0x145
> kthread+0x8/0x10b
> schedule_tail+0x38/0xa1
> child_rip+0xa/0x12
> kthread+0x0/0x10b
> child_rip+0x0/0x12

Does the following help?

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/cpufreq/cpufreq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3 drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3
+++ a/drivers/cpufreq/cpufreq.c
@@ -1122,14 +1122,15 @@ unsigned int cpufreq_get(unsigned int cp
 		goto out;
 
 	if (unlikely(lock_policy_rwsem_read(cpu)))
-		goto out;
+		goto out_policy;
 
 	ret_freq = __cpufreq_get(cpu);
 
 	unlock_policy_rwsem_read(cpu);
 
-out:
+out_policy:
 	cpufreq_cpu_put(policy);
+out:
 	return (ret_freq);
 }
 EXPORT_SYMBOL(cpufreq_get);
_

Patches currently in -mm which might be from malattia@linux.it are

sony_acpi-addacpi_bus_generate-event.patch
sony_acpi-add-lanpower-and-audiopower-controls.patch
sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
fix-x86_64-mm-i386-config-core2.patch
