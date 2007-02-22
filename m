From: akpm@linux-foundation.org
Subject: + ia64-sync-compat-getdents-on-ia64-and-parisc.patch added to -mm tree
Date: Wed, 21 Feb 2007 17:03:46 -0800
Message-ID: <200702220103.l1M13kRh032270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXBVBDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 20:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aandreev@openvz.org, adobriyan@openvz.org, tony.luck@intel.com


The patch titled
     ia64: sync compat getdents
has been added to the -mm tree.  Its filename is
     ia64-sync-compat-getdents-on-ia64-and-parisc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/ia64/ia32/sys_ia32.c    |   10 +++++++---
 parisc/kernel/sys_parisc32.c |    0 
 2 files changed, 7 insertions(+), 3 deletions(-)

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
diff -puN arch/parisc/kernel/sys_parisc32.c~ia64-sync-compat-getdents-on-ia64-and-parisc arch/parisc/kernel/sys_parisc32.c
_

Patches currently in -mm which might be from aandreev@openvz.org are

ia64-sync-compat-getdents-on-ia64-and-parisc.patch
parisc-sync-compat-getdents-on-ia64-and-parisc.patch
