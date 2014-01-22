From: akpm@linux-foundation.org
Subject: [merged] inotify-provide-function-for-name-length-rounding.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:23 -0800
Message-ID: <52e025eb.C5CWBtL/4uJOTH10%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaAVULX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de, eparis@parisplace.org, jack@suse.cz

Subject: [merged] inotify-provide-function-for-name-length-rounding.patch removed from -mm tree
To: jack@suse.cz,eparis@parisplace.org,hch@lst.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:23 -0800


The patch titled
     Subject: inotify: provide function for name length rounding
has been removed from the -mm tree.  Its filename was
     inotify-provide-function-for-name-length-rounding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: inotify: provide function for name length rounding

Rounding of name length when passing it to userspace was done in several
places.  Provide a function to do it and use it in all places.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |   41 ++++++++++++++---------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-provide-function-for-name-length-rounding fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-provide-function-for-name-length-rounding
+++ a/fs/notify/inotify/inotify_user.c
@@ -124,6 +124,13 @@ static unsigned int inotify_poll(struct
 	return ret;
 }
 
+static int round_event_name_len(struct fsnotify_event *event)
+{
+	if (!event->name_len)
+		return 0;
+	return roundup(event->name_len + 1, sizeof(struct inotify_event));
+}
+
 /*
  * Get an inotify_kernel_event if one exists and is small
  * enough to fit in "count". Return an error pointer if
@@ -144,9 +151,7 @@ static struct fsnotify_event *get_one_ev
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	if (event->name_len)
-		event_size += roundup(event->name_len + 1, event_size);
-
+	event_size += round_event_name_len(event);
 	if (event_size > count)
 		return ERR_PTR(-EINVAL);
 
@@ -171,7 +176,8 @@ static ssize_t copy_event_to_user(struct
 	struct fsnotify_event_private_data *fsn_priv;
 	struct inotify_event_private_data *priv;
 	size_t event_size = sizeof(struct inotify_event);
-	size_t name_len = 0;
+	size_t name_len;
+	size_t pad_name_len;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -189,14 +195,13 @@ static ssize_t copy_event_to_user(struct
 		inotify_free_event_priv(fsn_priv);
 	}
 
+	name_len = event->name_len;
 	/*
-	 * round up event->name_len so it is a multiple of event_size
+	 * round up name length so it is a multiple of event_size
 	 * plus an extra byte for the terminating '\0'.
 	 */
-	if (event->name_len)
-		name_len = roundup(event->name_len + 1, event_size);
-	inotify_event.len = name_len;
-
+	pad_name_len = round_event_name_len(event);
+	inotify_event.len = pad_name_len;
 	inotify_event.mask = inotify_mask_to_arg(event->mask);
 	inotify_event.cookie = event->sync_cookie;
 
@@ -209,20 +214,18 @@ static ssize_t copy_event_to_user(struct
 	/*
 	 * fsnotify only stores the pathname, so here we have to send the pathname
 	 * and then pad that pathname out to a multiple of sizeof(inotify_event)
-	 * with zeros.  I get my zeros from the nul_inotify_event.
+	 * with zeros.
 	 */
-	if (name_len) {
-		unsigned int len_to_zero = name_len - event->name_len;
+	if (pad_name_len) {
 		/* copy the path name */
-		if (copy_to_user(buf, event->file_name, event->name_len))
+		if (copy_to_user(buf, event->file_name, name_len))
 			return -EFAULT;
-		buf += event->name_len;
+		buf += name_len;
 
 		/* fill userspace with 0's */
-		if (clear_user(buf, len_to_zero))
+		if (clear_user(buf, pad_name_len - name_len))
 			return -EFAULT;
-		buf += len_to_zero;
-		event_size += name_len;
+		event_size += pad_name_len;
 	}
 
 	return event_size;
@@ -314,9 +317,7 @@ static long inotify_ioctl(struct file *f
 		list_for_each_entry(holder, &group->notification_list, event_list) {
 			event = holder->event;
 			send_len += sizeof(struct inotify_event);
-			if (event->name_len)
-				send_len += roundup(event->name_len + 1,
-						sizeof(struct inotify_event));
+			send_len += round_event_name_len(event);
 		}
 		mutex_unlock(&group->notification_mutex);
 		ret = put_user(send_len, (int __user *) p);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-pipec-skip-file_update_time-on-frozen-fs.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch
userns-relax-the-posix_acl_valid-checks.patch
linux-next.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
mm-add-strictlimit-knob-v2.patch

