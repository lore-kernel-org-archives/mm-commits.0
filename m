From: akpm@linux-foundation.org
Subject: - ia64-sync-compat-getdents-on-ia64-and-parisc.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:20 -0800
Message-ID: <200703070422.l274MKUW018982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbXCGEWX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aandreev@openvz.org, adobriyan@openvz.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: sync compat getdents
has been removed from the -mm tree.  Its filename was
     ia64-sync-compat-getdents-on-ia64-and-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: sync compat getdents
From: Alexandr Andreev <aandreev@openvz.org>

Add VERIFY_WRITE check in the beginning like compat_sys_getdents() (EINVAL vs
EFAULT).

Signed-off-by: Alexandr Andreev <aandreev@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/sys_ia32.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/ia64/ia32/sys_ia32.c~ia64-sync-compat-getdents-on-ia64-and-parisc arch/ia64/ia32/sys_ia32.c
--- a/arch/ia64/ia32/sys_ia32.c~ia64-sync-compat-getdents-on-ia64-and-parisc
+++ a/arch/ia64/ia32/sys_ia32.c
@@ -1267,6 +1267,10 @@ sys32_getdents (unsigned int fd, struct 
 	struct getdents32_callback buf;
 	int error;
 
+	error = -EFAULT;
+	if (!access_ok(VERIFY_WRITE, dirent, count))
+		goto out;
+
 	error = -EBADF;
 	file = fget(fd);
 	if (!file)
@@ -1283,10 +1287,10 @@ sys32_getdents (unsigned int fd, struct 
 	error = buf.error;
 	lastdirent = buf.previous;
 	if (lastdirent) {
-		error = -EINVAL;
 		if (put_user(file->f_pos, &lastdirent->d_off))
-			goto out_putf;
-		error = count - buf.count;
+			error = -EFAULT;
+		else
+			error = count - buf.count;
 	}
 
 out_putf:
_

Patches currently in -mm which might be from aandreev@openvz.org are

origin.patch
git-parisc.patch
x86_64-wire-up-compat-sched_rr_get_interval2.patch
