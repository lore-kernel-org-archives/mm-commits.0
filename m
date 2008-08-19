From: akpm@linux-foundation.org
Subject: + cpusetc-remove-extra-variable.patch added to -mm tree
Date: Mon, 18 Aug 2008 21:16:28 -0700
Message-ID: <200808190416.m7J4GS0J030158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYHSERD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 00:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, pj@sgi.com


The patch titled
     cpuset.c: remove extra variable
has been added to the -mm tree.  Its filename is
     cpusetc-remove-extra-variable.patch

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
Subject: cpuset.c: remove extra variable
From: "Rakib Mullick" <rakib.mullick@gmail.com>

Remove the use of int cpus_nonempty variable from 'update_flag' function.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpusetc-remove-extra-variable kernel/cpuset.c
--- a/kernel/cpuset.c~cpusetc-remove-extra-variable
+++ a/kernel/cpuset.c
@@ -1110,7 +1110,7 @@ static int update_flag(cpuset_flagbits_t
 {
 	struct cpuset trialcs;
 	int err;
-	int cpus_nonempty, balance_flag_changed;
+	int balance_flag_changed;
 
 	trialcs = *cs;
 	if (turning_on)
@@ -1122,7 +1122,6 @@ static int update_flag(cpuset_flagbits_t
 	if (err < 0)
 		return err;
 
-	cpus_nonempty = !cpus_empty(trialcs.cpus_allowed);
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 		 			is_sched_load_balance(&trialcs));
 
@@ -1130,7 +1129,7 @@ static int update_flag(cpuset_flagbits_t
 	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);
 
-	if (cpus_nonempty && balance_flag_changed)
+	if (!cpus_empty(trialcs.cpus_allowed) && balance_flag_changed)
 		rebuild_sched_domains();
 
 	return 0;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

cpusetc-remove-extra-variable.patch

