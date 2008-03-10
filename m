From: akpm@linux-foundation.org
Subject: + use-warn_on_secs-in-rcupreempth.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:52:08 -0700
Message-ID: <200803102052.m2AKq82h004938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbYCJUwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, paulmck@linux.vnet.ibm.com


The patch titled
     Use WARN_ON_SECS in rcupreempt.h
has been added to the -mm tree.  Its filename is
     use-warn_on_secs-in-rcupreempth.patch

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
Subject: Use WARN_ON_SECS in rcupreempt.h
From: Dave Young <hidave.darkstar@gmail.com>

Use WARN_ON_SECS in rcupreempt.h to avoid warning flood

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupreempt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/rcupreempt.h~use-warn_on_secs-in-rcupreempth include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~use-warn_on_secs-in-rcupreempth
+++ a/include/linux/rcupreempt.h
@@ -88,7 +88,7 @@ DECLARE_PER_CPU(long, dynticks_progress_
 static inline void rcu_enter_nohz(void)
 {
 	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
+	WARN_ON_SECS(__get_cpu_var(dynticks_progress_counter) & 0x1, 10);
 	mb();
 }
 
@@ -96,7 +96,7 @@ static inline void rcu_exit_nohz(void)
 {
 	mb();
 	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
+	WARN_ON_SECS(!(__get_cpu_var(dynticks_progress_counter) & 0x1), 10);
 }
 
 #else /* CONFIG_NO_HZ */
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
git-net.patch
isolate-ratelimit-from-printkc-for-other-use.patch
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

