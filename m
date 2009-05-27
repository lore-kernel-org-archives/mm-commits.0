From: akpm@linux-foundation.org
Subject: + clocksource-disallow-setting-jiffies-as-the-clocksource.patch added to -mm tree
Date: Tue, 26 May 2009 19:32:45 -0700
Message-ID: <200905270232.n4R2WjAS005489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbZE0CdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 22:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luming.yu@gmail.com, johnstul@us.ibm.com, luming.yu@intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource: disallow setting jiffies as the clocksource
has been added to the -mm tree.  Its filename is
     clocksource-disallow-setting-jiffies-as-the-clocksource.patch

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
Subject: clocksource: disallow setting jiffies as the clocksource
From: Luming Yu <luming.yu@gmail.com>

As reported in https://bugzilla.redhat.com/show_bug.cgi?id=496028,

	echo jiffies > clocksource0/current_clocksource

makes the system crash.

I reproduced the problem with upstream kernel.  The root cause is that
jiffies is just a variable in memory, it relies on other clock source to
tick, and it never ticks on itself.

Signed-off-by: Yu Luming <luming.yu@intel.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/time/clocksource.c~clocksource-disallow-setting-jiffies-as-the-clocksource kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-disallow-setting-jiffies-as-the-clocksource
+++ a/kernel/time/clocksource.c
@@ -504,8 +504,9 @@ static ssize_t sysfs_override_clocksourc
 		/* try to select it: */
 		list_for_each_entry(cs, &clocksource_list, list) {
 			if (strlen(cs->name) == len &&
-			    !strcmp(cs->name, override_name))
-				ovr = cs;
+			    !strcmp(cs->name, override_name) &&
+				cs != &clocksource_jiffies)
+					ovr = cs;
 		}
 	}
 
_

Patches currently in -mm which might be from luming.yu@gmail.com are

clocksource-disallow-setting-jiffies-as-the-clocksource.patch

