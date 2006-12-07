From: akpm@osdl.org
Subject: - profile-fix-uaccess-handling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:56 -0800
Message-ID: <200612072302.kB7N2ulU029909@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163696AbWLGXDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     profile: fix uaccess handling
has been removed from the -mm tree.  Its filename was
     profile-fix-uaccess-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: profile: fix uaccess handling
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/profile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/profile.c~profile-fix-uaccess-handling kernel/profile.c
--- a/kernel/profile.c~profile-fix-uaccess-handling
+++ a/kernel/profile.c
@@ -442,7 +442,8 @@ read_profile(struct file *file, char __u
 	read = 0;
 
 	while (p < sizeof(unsigned int) && count > 0) {
-		put_user(*((char *)(&sample_step)+p),buf);
+		if (put_user(*((char *)(&sample_step)+p),buf))
+			return -EFAULT;
 		buf++; p++; count--; read++;
 	}
 	pnt = (char *)prof_buffer + p - sizeof(atomic_t);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-workqueue-fixes.patch
scsi-fix-uaccess-handling.patch

