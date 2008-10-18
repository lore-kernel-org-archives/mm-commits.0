From: akpm@linux-foundation.org
Subject: - utsname-completely-overwrite-prior-information.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:59 -0700
Message-ID: <200810182311.m9INBxaF027834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbYJRXMD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     utsname: completely overwrite prior information
has been removed from the -mm tree.  Its filename was
     utsname-completely-overwrite-prior-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utsname: completely overwrite prior information
From: Vegard Nossum <vegard.nossum@gmail.com>

On sethostname() and setdomainname(), previous information may be retained
if it was longer than than the new hostname/domainname.

This can be demonstrated trivially by calling sethostname() first with a
long name, then with a short name, and then calling uname() to retrieve
the full buffer that contains the hostname (and possibly parts of the old
hostname), one just has to look past the terminating zero.

I don't know if we should really care that much (hence the RFC); the only
scenarios I can possibly think of is administrator putting something
sensitive in the hostname (or domain name) by accident, and changing it
back will not undo the mistake entirely, though it's not like we can
recover gracefully from "rm -rf /" either...  The other scenario is
namespaces (CLONE_NEWUTS) where some information may be unintentionally
"inherited" from the previous namespace (a program wants to hide the
original name and does clone + sethostname, but some information is still
left).

I think the patch may be defended on grounds of the principle of least
surprise.  But I am not adamant :-)

(I guess the question now is whether userspace should be able to
write embedded NULs into the buffer or not...)

At least the observation has been made and the patch has been presented.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~utsname-completely-overwrite-prior-information kernel/sys.c
--- a/kernel/sys.c~utsname-completely-overwrite-prior-information
+++ a/kernel/sys.c
@@ -1350,7 +1350,8 @@ asmlinkage long sys_sethostname(char __u
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
 		memcpy(utsname()->nodename, tmp, len);
-		utsname()->nodename[len] = 0;
+		memset(utsname()->nodename + len, 0,
+			sizeof(utsname()->nodename) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
@@ -1396,7 +1397,8 @@ asmlinkage long sys_setdomainname(char _
 	errno = -EFAULT;
 	if (!copy_from_user(tmp, name, len)) {
 		memcpy(utsname()->domainname, tmp, len);
-		utsname()->domainname[len] = 0;
+		memset(utsname()->domainname + len, 0,
+			sizeof(utsname()->domainname) - len);
 		errno = 0;
 	}
 	up_write(&uts_sem);
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch

