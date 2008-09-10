From: akpm@linux-foundation.org
Subject: + rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:32:29 -0700
Message-ID: <200809102132.m8ALWTVu027267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYIJVcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vonsch@gmail.com


The patch titled
     rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY
has been added to the -mm tree.  Its filename is
     rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch

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
Subject: rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY
From: Adam Tkac <vonsch@gmail.com>

When a process wants to set the limit of open files to RLIM_INFINITY it
gets EPERM even if it has CAP_SYS_RESOURCE capability.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
--- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
+++ a/kernel/sys.c
@@ -1532,8 +1532,14 @@ asmlinkage long sys_setrlimit(unsigned i
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
-		return -EPERM;
+	if (resource == RLIMIT_NOFILE) {
+		if (new_rlim.rlim_max == RLIM_INFINITY)
+			new_rlim.rlim_max = sysctl_nr_open;
+		if (new_rlim.rlim_cur == RLIM_INFINITY)
+			new_rlim.rlim_cur = sysctl_nr_open;
+		if (new_rlim.rlim_max > sysctl_nr_open)
+			return -EPERM;
+	}
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)
_

Patches currently in -mm which might be from vonsch@gmail.com are

rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch

