From: akpm@linux-foundation.org
Subject: - cpufreq-state-info-wrong-after-resume.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:01 -0700
Message-ID: <200804300551.m3U5p12g030177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759217AbYD3FvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: state info wrong after resume
has been removed from the -mm tree.  Its filename was
     cpufreq-state-info-wrong-after-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: state info wrong after resume
From: Shaohua Li <shaohua.li@intel.com>

Sometimes old_index != stat->last_index, see cpufreq_update_policy, bios can
change cpu setting in resume.  In my test, after resume cpu is in lowest
speed, but the stat info shows cpu is in full speed.  This patch makes the
stat info correct after a resume.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_stats.c~cpufreq-state-info-wrong-after-resume drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~cpufreq-state-info-wrong-after-resume
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -288,7 +288,7 @@ cpufreq_stat_notifier_trans (struct noti
 	if (!stat)
 		return 0;
 
-	old_index = freq_table_get_index(stat, freq->old);
+	old_index = stat->last_index;
 	new_index = freq_table_get_index(stat, freq->new);
 
 	cpufreq_stats_update(freq->cpu);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
git-kvm.patch

