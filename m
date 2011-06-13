From: akpm@linux-foundation.org
Subject: + alpha-fix-several-security-issues.patch added to -mm tree
Date: Mon, 13 Jun 2011 16:34:07 -0700
Message-ID: <201106132334.p5DNY7Xo028885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289Ab1FMXeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 19:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: fix several security issues
has been added to the -mm tree.  Its filename is
     alpha-fix-several-security-issues.patch

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
Subject: alpha: fix several security issues
From: Dan Rosenberg <drosenberg@vsecurity.com>

Fix several security issues in Alpha-specific syscalls.  Untested, but
mostly trivial.

1. Signedness issue in osf_getdomainname allows copying out-of-bounds
kernel memory to userland.

2. Signedness issue in osf_sysinfo allows copying large amounts of
kernel memory to userland.

3. Typo (?) in osf_getsysinfo bounds minimum instead of maximum copy
size, allowing copying large amounts of kernel memory to userland.

4. Usage of user pointer in osf_wait4 while under KERNEL_DS allows
privilege escalation via writing return value of sys_wait4 to kernel
memory.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/alpha/kernel/osf_sys.c~alpha-fix-several-security-issues arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~alpha-fix-several-security-issues
+++ a/arch/alpha/kernel/osf_sys.c
@@ -409,7 +409,7 @@ SYSCALL_DEFINE2(osf_getdomainname, char 
 		return -EFAULT;
 
 	len = namelen;
-	if (namelen > 32)
+	if (len > 32)
 		len = 32;
 
 	down_read(&uts_sem);
@@ -594,7 +594,7 @@ SYSCALL_DEFINE3(osf_sysinfo, int, comman
 	down_read(&uts_sem);
 	res = sysinfo_table[offset];
 	len = strlen(res)+1;
-	if (len > count)
+	if ((unsigned long)len > (unsigned long)count)
 		len = count;
 	if (copy_to_user(buf, res, len))
 		err = -EFAULT;
@@ -649,7 +649,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned
 		return 1;
 
 	case GSI_GET_HWRPB:
-		if (nbytes < sizeof(*hwrpb))
+		if (nbytes > sizeof(*hwrpb))
 			return -EINVAL;
 		if (copy_to_user(buffer, hwrpb, nbytes) != 0)
 			return -EFAULT;
@@ -1008,6 +1008,7 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, i
 {
 	struct rusage r;
 	long ret, err;
+	unsigned int status = 0;
 	mm_segment_t old_fs;
 
 	if (!ur)
@@ -1016,13 +1017,15 @@ SYSCALL_DEFINE4(osf_wait4, pid_t, pid, i
 	old_fs = get_fs();
 		
 	set_fs (KERNEL_DS);
-	ret = sys_wait4(pid, ustatus, options, (struct rusage __user *) &r);
+	ret = sys_wait4(pid, (unsigned int __user *) &status, options,
+			(struct rusage __user *) &r);
 	set_fs (old_fs);
 
 	if (!access_ok(VERIFY_WRITE, ur, sizeof(*ur)))
 		return -EFAULT;
 
 	err = 0;
+	err |= put_user(status, ustatus);
 	err |= __put_user(r.ru_utime.tv_sec, &ur->ru_utime.tv_sec);
 	err |= __put_user(r.ru_utime.tv_usec, &ur->ru_utime.tv_usec);
 	err |= __put_user(r.ru_stime.tv_sec, &ur->ru_stime.tv_sec);
_

Patches currently in -mm which might be from drosenberg@vsecurity.com are

alpha-fix-several-security-issues.patch
drivers-scsi-pmcraid-reject-negative-request-size.patch

