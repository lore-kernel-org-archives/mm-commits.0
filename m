From: akpm@osdl.org
Subject: - mm-search_binary_handler-mem-limit-fix.patch removed from -mm tree
Date: Mon, 29 Jan 2007 09:35:48 -0800
Message-ID: <200701291735.l0THZmpL025119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXA2Rfu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 12:35:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     mm: search_binary_handler() mem limit fix
has been removed from the -mm tree.  Its filename was
     mm-search_binary_handler-mem-limit-fix.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: mm: search_binary_handler() mem limit fix
From: Dmitriy Monakhov <dmonakhov@openvz.org>

The function changes mem limit to USER_DS before possible modprobe, but
never restored it again.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/exec.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~mm-search_binary_handler-mem-limit-fix fs/exec.c
--- a/fs/exec.c~mm-search_binary_handler-mem-limit-fix
+++ a/fs/exec.c
@@ -1018,6 +1018,7 @@ int search_binary_handler(struct linux_b
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
+	mm_segment_t oldfs;
 #ifdef __alpha__
 	/* handle /sbin/loader.. */
 	{
@@ -1059,11 +1060,12 @@ int search_binary_handler(struct linux_b
 
 	/* kernel module loader fixup */
 	/* so we don't try to load run modprobe in kernel space. */
+	oldfs = get_fs();
 	set_fs(USER_DS);
 
 	retval = audit_bprm(bprm);
 	if (retval)
-		return retval;
+		goto out;
 
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
@@ -1084,7 +1086,7 @@ int search_binary_handler(struct linux_b
 				bprm->file = NULL;
 				current->did_exec = 1;
 				proc_exec_connector(current);
-				return retval;
+				goto out;
 			}
 			read_lock(&binfmt_lock);
 			put_binfmt(fmt);
@@ -1092,7 +1094,7 @@ int search_binary_handler(struct linux_b
 				break;
 			if (!bprm->file) {
 				read_unlock(&binfmt_lock);
-				return retval;
+				goto out;
 			}
 		}
 		read_unlock(&binfmt_lock);
@@ -1110,6 +1112,8 @@ int search_binary_handler(struct linux_b
 #endif
 		}
 	}
+out:
+	set_fs(oldfs);
 	return retval;
 }
 
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

broadcom-4400-resume-small-fix-v2.patch
mm-search_binary_handler-mem-limit-fix.patch
ext-jbd-layer-function-called-instead-of-fs-specific-one.patch
