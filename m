From: akpm@linux-foundation.org
Subject: + cpufreq-state-info-wrong-after-resume.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:46:56 -0700
Message-ID: <200804272046.m3RKkuF8024110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYD0Uri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, davej@codemonkey.org.uk


The patch titled
     cpufreq: state info wrong after resume
has been added to the -mm tree.  Its filename is
     cpufreq-state-info-wrong-after-resume.patch

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
cpufreq-state-info-wrong-after-resume.patch
git-kvm.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

