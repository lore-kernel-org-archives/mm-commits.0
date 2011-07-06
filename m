From: akpm@linux-foundation.org
Subject: + oom-make-deprecated-use-of-oom_adj-more-verbose.patch added to -mm tree
Date: Wed, 06 Jul 2011 16:53:44 -0700
Message-ID: <201107062353.p66NriOh010888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139Ab1GGAB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 20:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: make deprecated use of oom_adj more verbose
has been added to the -mm tree.  Its filename is
     oom-make-deprecated-use-of-oom_adj-more-verbose.patch

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
Subject: oom: make deprecated use of oom_adj more verbose
From: David Rientjes <rientjes@google.com>

/proc/pid/oom_adj is deprecated and scheduled for removal in August 2012
according to Documentation/feature-removal-schedule.txt.

This patch makes the warning more verbose by making it appear as a more
serious problem (the presence of a stack trace and being multiline should
attract more attention) so that applications still using the old interface
can get fixed.

Very popular users of the old interface have been converted since the oom
killer rewrite has been introduced.  udevd switched to the
/proc/pid/oom_score_adj interface for v162, kde switched in 4.6.1, and
opensshd switched in 5.7p1.

At the start of 2012, this should be changed into a WARN() to emit all
such incidents and then finally remove the tunable in August 2012 as
scheduled.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~oom-make-deprecated-use-of-oom_adj-more-verbose fs/proc/base.c
--- a/fs/proc/base.c~oom-make-deprecated-use-of-oom_adj-more-verbose
+++ a/fs/proc/base.c
@@ -1118,10 +1118,9 @@ static ssize_t oom_adjust_write(struct f
 	 * Warn that /proc/pid/oom_adj is deprecated, see
 	 * Documentation/feature-removal-schedule.txt.
 	 */
-	printk_once(KERN_WARNING "%s (%d): /proc/%d/oom_adj is deprecated, "
-			"please use /proc/%d/oom_score_adj instead.\n",
-			current->comm, task_pid_nr(current),
-			task_pid_nr(task), task_pid_nr(task));
+	WARN_ONCE(1, "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
+		  current->comm, task_pid_nr(current), task_pid_nr(task),
+		  task_pid_nr(task));
 	task->signal->oom_adj = oom_adjust;
 	/*
 	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi-remove-nid_inval.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
oom-remove-references-to-old-badness-function.patch
oom-make-deprecated-use-of-oom_adj-more-verbose.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch

