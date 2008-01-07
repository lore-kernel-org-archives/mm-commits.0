From: akpm@linux-foundation.org
Subject: - fix-computation-of-skb-size-for-quota-messages.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:06 -0800
Message-ID: <200801072138.m07Lck7A013499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbYAGViv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:38:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Fix computation of SKB size for quota messages
has been removed from the -mm tree.  Its filename was
     fix-computation-of-skb-size-for-quota-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix computation of SKB size for quota messages
From: Jan Kara <jack@suse.cz>

Fix computation of size of skb needed for quota message.  We should use
netlink provided functions and not just an ad-hoc number.  Also don't print
the return value from nla_put_foo() as it is always -1.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/dquot.c~fix-computation-of-skb-size-for-quota-messages fs/dquot.c
--- a/fs/dquot.c~fix-computation-of-skb-size-for-quota-messages
+++ a/fs/dquot.c
@@ -895,9 +895,6 @@ out_lock:
 
 #ifdef CONFIG_QUOTA_NETLINK_INTERFACE
 
-/* Size of quota netlink message - actually an upperbound for buffer size */
-#define QUOTA_NL_MSG_SIZE 32
-
 /* Netlink family structure for quota */
 static struct genl_family quota_genl_family = {
 	.id = GENL_ID_GENERATE,
@@ -914,11 +911,13 @@ static void send_warning(const struct dq
 	struct sk_buff *skb;
 	void *msg_head;
 	int ret;
+	int msg_size = 4 * nla_total_size(sizeof(u32)) +
+		       2 * nla_total_size(sizeof(u64));
 
 	/* We have to allocate using GFP_NOFS as we are called from a
 	 * filesystem performing write and thus further recursion into
 	 * the fs to free some data could cause deadlocks. */
-	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
+	skb = genlmsg_new(msg_size, GFP_NOFS);
 	if (!skb) {
 		printk(KERN_ERR
 		  "VFS: Not enough memory to send quota warning.\n");
@@ -959,7 +958,7 @@ static void send_warning(const struct dq
 			"VFS: Failed to send notification message: %d\n", ret);
 	return;
 attr_err_out:
-	printk(KERN_ERR "VFS: Failed to compose quota message: %d\n", ret);
+	printk(KERN_ERR "VFS: Not enough space to compose quota message!\n");
 err_out:
 	kfree_skb(skb);
 }
_

Patches currently in -mm which might be from jack@suse.cz are

git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
use-pgoff_t-instead-of-unsigned-long.patch
