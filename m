From: akpm@linux-foundation.org
Subject: + fsnotify-remove-pointless-null-initializers.patch added to -mm
 tree
Date: Wed, 11 Dec 2013 13:51:22 -0800
Message-ID: <52a8de5a.QRgRNEPJXSQ8rOeW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LKVvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 16:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de, eparis@parisplace.org, jack@suse.cz

Subject: + fsnotify-remove-pointless-null-initializers.patch added to -mm tree
To: jack@suse.cz,eparis@parisplace.org,hch@lst.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 13:51:22 -0800


The patch titled
     Subject: fsnotify: remove pointless NULL initializers
has been added to the -mm tree.  Its filename is
     fsnotify-remove-pointless-null-initializers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-remove-pointless-null-initializers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-remove-pointless-null-initializers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: remove pointless NULL initializers

We usually rely on the fact that struct members not specified in the
initializer are set to NULL.  So do that with fsnotify function pointers
as well.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c   |    3 ---
 fs/notify/fanotify/fanotify.c |    1 -
 kernel/audit_tree.c           |    2 --
 kernel/audit_watch.c          |    3 ---
 4 files changed, 9 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~fsnotify-remove-pointless-null-initializers fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~fsnotify-remove-pointless-null-initializers
+++ a/fs/notify/dnotify/dnotify.c
@@ -138,9 +138,6 @@ static void dnotify_free_mark(struct fsn
 
 static struct fsnotify_ops dnotify_fsnotify_ops = {
 	.handle_event = dnotify_handle_event,
-	.free_group_priv = NULL,
-	.freeing_mark = NULL,
-	.free_event = NULL,
 };
 
 /*
diff -puN fs/notify/fanotify/fanotify.c~fsnotify-remove-pointless-null-initializers fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fsnotify-remove-pointless-null-initializers
+++ a/fs/notify/fanotify/fanotify.c
@@ -227,5 +227,4 @@ const struct fsnotify_ops fanotify_fsnot
 	.handle_event = fanotify_handle_event,
 	.free_group_priv = fanotify_free_group_priv,
 	.free_event = fanotify_free_event,
-	.freeing_mark = NULL,
 };
diff -puN kernel/audit_tree.c~fsnotify-remove-pointless-null-initializers kernel/audit_tree.c
--- a/kernel/audit_tree.c~fsnotify-remove-pointless-null-initializers
+++ a/kernel/audit_tree.c
@@ -936,8 +936,6 @@ static void audit_tree_freeing_mark(stru
 
 static const struct fsnotify_ops audit_tree_ops = {
 	.handle_event = audit_tree_handle_event,
-	.free_group_priv = NULL,
-	.free_event = NULL,
 	.freeing_mark = audit_tree_freeing_mark,
 };
 
diff -puN kernel/audit_watch.c~fsnotify-remove-pointless-null-initializers kernel/audit_watch.c
--- a/kernel/audit_watch.c~fsnotify-remove-pointless-null-initializers
+++ a/kernel/audit_watch.c
@@ -505,9 +505,6 @@ static int audit_watch_handle_event(stru
 
 static const struct fsnotify_ops audit_watch_fsnotify_ops = {
 	.handle_event = 	audit_watch_handle_event,
-	.free_group_priv = 	NULL,
-	.freeing_mark = 	NULL,
-	.free_event = 		NULL,
 };
 
 static int __init audit_watch_init(void)
_

Patches currently in -mm which might be from jack@suse.cz are

inotify-provide-function-for-name-length-rounding.patch
fsnotify-do-not-share-events-between-notification-groups.patch
fsnotify-remove-should_send_event-callback.patch
fsnotify-remove-pointless-null-initializers.patch
blk-mq-use-__smp_call_function_single-directly.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

