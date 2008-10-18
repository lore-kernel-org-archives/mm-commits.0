From: akpm@linux-foundation.org
Subject: - rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:49 -0700
Message-ID: <200810182311.m9INBnoS027804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbYJRXLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vonsch@gmail.com, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY
has been removed from the -mm tree.  Its filename was
     rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rlimit: permit setting RLIMIT_NOFILE to RLIM_INFINITY
From: Adam Tkac <vonsch@gmail.com>

When a process wants to set the limit of open files to RLIM_INFINITY it
gets EPERM even if it has CAP_SYS_RESOURCE capability.

For example, BIND does:

...
#elif defined(NR_OPEN) && defined(__linux__)
        /*
         * Some Linux kernels don't accept RLIM_INFINIT; the maximum
         * possible value is the NR_OPEN defined in linux/fs.h.
         */
        if (resource == isc_resource_openfiles && rlim_value == RLIM_INFINITY) {
                rl.rlim_cur = rl.rlim_max = NR_OPEN;
                unixresult = setrlimit(unixresource, &rl);
                if (unixresult == 0)
                        return (ISC_R_SUCCESS);
        }
#elif ...

If we allow setting RLIMIT_NOFILE to RLIM_INFINITY we increase portability
- you don't have to check if OS is linux and then use different schema for
limits.

The spec says "Specifying RLIM_INFINITY as any resource limit value on a
successful call to setrlimit() shall inhibit enforcement of that resource
limit." and we're presently not doing that.

Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
--- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
+++ a/kernel/sys.c
@@ -1450,14 +1450,22 @@ asmlinkage long sys_setrlimit(unsigned i
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
-		return -EINVAL;
 	old_rlim = current->signal->rlim + resource;
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
-		return -EPERM;
+
+	if (resource == RLIMIT_NOFILE) {
+		if (new_rlim.rlim_max == RLIM_INFINITY)
+			new_rlim.rlim_max = sysctl_nr_open;
+		if (new_rlim.rlim_cur == RLIM_INFINITY)
+			new_rlim.rlim_cur = sysctl_nr_open;
+		if (new_rlim.rlim_max > sysctl_nr_open)
+			return -EPERM;
+	}
+
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)
_

Patches currently in -mm which might be from vonsch@gmail.com are

origin.patch

