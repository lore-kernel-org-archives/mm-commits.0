From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:04 -0800
Message-ID: <54dbb9b0.fpsotKaXrK8vBLE1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix snprintf format specifier in dlmdebug.c
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-snprintf-format-specifier-in-dlmdebugc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: fix snprintf format specifier in dlmdebug.c

Use snprintf format specifier "%lu" instead of "%ld" for argument of type
'unsigned long'.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdebug.c~ocfs2-fix-snprintf-format-specifier-in-dlmdebugc fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-fix-snprintf-format-specifier-in-dlmdebugc
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -406,7 +406,7 @@ static int debug_purgelist_print(struct
 	}
 	spin_unlock(&dlm->spinlock);
 
-	out += snprintf(buf + out, len - out, "Total on list: %ld\n", total);
+	out += snprintf(buf + out, len - out, "Total on list: %lu\n", total);
 
 	return out;
 }
@@ -464,7 +464,7 @@ static int debug_mle_print(struct dlm_ct
 	spin_unlock(&dlm->master_lock);
 
 	out += snprintf(buf + out, len - out,
-			"Total: %ld, Longest: %ld\n", total, longest);
+			"Total: %lu, Longest: %lu\n", total, longest);
 	return out;
 }
 
_

Patches currently in -mm which might be from alex.chen@huawei.com are

origin.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

