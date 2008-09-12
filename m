From: akpm@linux-foundation.org
Subject: + rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch added to -mm tree
Date: Fri, 12 Sep 2008 13:05:52 -0700
Message-ID: <200809122005.m8CK5sFM001511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724AbYILUGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 16:06:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vonsch@gmail.com, mtk.manpages@googlemail.com, schwab@suse.de


The patch titled
     rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix
has been added to the -mm tree.  Its filename is
     rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix
From: Adam Tkac <vonsch@gmail.com>

When cur > max && cur != INF after adjustment EINVAL is returned.  (cur
can be also set to max but it seems like bad solution for me)

Cc: Andreas Schwab <schwab@suse.de>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix kernel/sys.c
--- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix
+++ a/kernel/sys.c
@@ -1526,12 +1526,11 @@ asmlinkage long sys_setrlimit(unsigned i
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
-		return -EINVAL;
 	old_rlim = current->signal->rlim + resource;
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
+
 	if (resource == RLIMIT_NOFILE) {
 		if (new_rlim.rlim_max == RLIM_INFINITY)
 			new_rlim.rlim_max = sysctl_nr_open;
@@ -1541,6 +1540,9 @@ asmlinkage long sys_setrlimit(unsigned i
 			return -EPERM;
 	}
 
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
+
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)
 		return retval;
_

Patches currently in -mm which might be from vonsch@gmail.com are

rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch
rlimit-permit-setting-rlimit_nofile-to-rlim_infinity-fix.patch

