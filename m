From: akpm@linux-foundation.org
Subject: [to-be-updated] jffs2-fix-unbalanced-locking.patch removed from
 -mm tree
Date: Thu, 13 Feb 2014 13:08:43 -0800
Message-ID: <52fd345b.cs0zQqgMfrXN9OO3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaBMVIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 16:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com, lizefan@huawei.com

Subject: [to-be-updated] jffs2-fix-unbalanced-locking.patch removed from -mm tree
To: lizefan@huawei.com,artem.bityutskiy@linux.intel.com,computersforpeace@gmail.com,dwmw2@infradead.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 13:08:43 -0800


The patch titled
     Subject: jffs2: fix unbalanced locking
has been removed from the -mm tree.  Its filename was
     jffs2-fix-unbalanced-locking.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: jffs2: fix unbalanced locking

This was found by our internal debugging feature on runtime, but this bug
won't lead to deadlock, as the structure that this lock is embedded in is
freed on error.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/readinode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/jffs2/readinode.c~jffs2-fix-unbalanced-locking fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~jffs2-fix-unbalanced-locking
+++ a/fs/jffs2/readinode.c
@@ -1143,6 +1143,7 @@ static int jffs2_do_read_inode_internal(
 		JFFS2_ERROR("cannot read nodes for ino %u, returned error is %d\n", f->inocache->ino, ret);
 		if (f->inocache->state == INO_STATE_READING)
 			jffs2_set_inocache_state(c, f->inocache, INO_STATE_CHECKEDABSENT);
+		mutex_unlock(&f->sem);
 		return ret;
 	}
 
@@ -1159,6 +1160,7 @@ static int jffs2_do_read_inode_internal(
 			jffs2_free_tmp_dnode_info(rii.mdata_tn);
 			rii.mdata_tn = NULL;
 		}
+		mutex_unlock(&f->sem);
 		return ret;
 	}
 
@@ -1183,6 +1185,7 @@ static int jffs2_do_read_inode_internal(
 			if (!rii.fds) {
 				if (f->inocache->state == INO_STATE_READING)
 					jffs2_set_inocache_state(c, f->inocache, INO_STATE_CHECKEDABSENT);
+				mutex_unlock(&f->sem);
 				return -EIO;
 			}
 			JFFS2_NOTICE("but it has children so we fake some modes for it\n");
_

Patches currently in -mm which might be from lizefan@huawei.com are

jffs2-fix-unbalanced-locking-v2.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
jffs2-remove-wait-queue-after-schedule.patch
linux-next.patch

