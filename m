From: akpm@linux-foundation.org
Subject: + jffs2-fix-unbalanced-locking.patch added to -mm tree
Date: Tue, 11 Feb 2014 15:56:25 -0800
Message-ID: <52fab8a9.zaz5HOufVEbGUyLO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBKX40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 18:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dwmw2@infradead.org, lizefan@huawei.com

Subject: + jffs2-fix-unbalanced-locking.patch added to -mm tree
To: lizefan@huawei.com,dwmw2@infradead.org,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 15:56:25 -0800


The patch titled
     Subject: jffs2: fix unbalanced locking
has been added to the -mm tree.  Its filename is
     jffs2-fix-unbalanced-locking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jffs2-fix-unbalanced-locking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jffs2-fix-unbalanced-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: jffs2: fix unbalanced locking

This was found by our internal debugging feature on runtime, but this bug
won't lead to deadlock, as the structure that this lock is embedded in is
freed on error.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
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

jffs2-fix-unbalanced-locking.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch
jffs2-remove-wait-queue-after-schedule.patch
linux-next.patch

