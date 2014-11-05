From: akpm@linux-foundation.org
Subject: + fanotify-ignore-marks-not-respected.patch added to -mm tree
Date: Wed, 05 Nov 2014 13:57:33 -0800
Message-ID: <545a9d4d.ouDgp9oUuGD/cJU7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKEV5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 16:57:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, eparis@redhat.com, hch@lst.de, hughd@google.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: ignore marks not respected
has been added to the -mm tree.  Its filename is
     fanotify-ignore-marks-not-respected.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-ignore-marks-not-respected.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-ignore-marks-not-respected.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: fanotify: ignore marks not respected

The fanotify API allows to mark mounts, directories, and files for
notification. Furthermore it allows to create marks with an ignore mask to
indicate which events shall be ignored.

Function fsnotify_add_inode_mark() stores marks for inodes as list in attribute
i_list of the inode. The list is sorted by priority and group.

Function fsnotify_add_vfsmount_mark() stores marks for mounts as list in
attribute m_list of the vfsmount. The list is sorted by priority and group.

If an event occurs function fsnotify() is called. This function loops over all
mount and inode marks and sends the event to the respective groups using
function send_to_group().

For an event and a group both an inode mark and a vfsmount mark may coexist.
E.g. a user program may want to monitor one mount for FAN_MODIFY events but
wants to ignore FAN_MODIFY events for some file.

If for an event and a group both an inode mark and a vfsmount mark exist, it is
important to call send_to_group() for both marks as once. Otherwise ignore mask
bits set on the one mark cannot be considered for the other mark.

Function fsnotify() assumes that m_list and i_list are sorted by group and
ignores the sorting by priority. Hence some ignore marks may not be correctly
considered.

Bug report 87721 provides an example code demonstrating the error.
https://bugzilla.kernel.org/show_bug.cgi?id=87721

The appended patch changes fsnotify() to assume sorting by priority and group.
Furthermore some comments are added to render the function more legible.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c |   56 ++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff -puN fs/notify/fsnotify.c~fanotify-ignore-marks-not-respected fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fanotify-ignore-marks-not-respected
+++ a/fs/notify/fsnotify.c
@@ -187,6 +187,13 @@ static int send_to_group(struct inode *t
  * in linux/fsnotify.h.  Those functions then in turn call here.  Here will call
  * out to all of the registered fsnotify_group.  Those groups can then use the
  * notification event in whatever means they feel necessary.
+ *
+ * To correctly interprete the ignore mask it is necessary to pass the inode
+ * mark and the vfsmount mark of the same notification group in a single call
+ * to send_to_group().
+ *
+ * The marks of each inode and each vfsmount are sorted by group-priority and
+ * group (see fsnotify_add_inode_mark() and fsnotify_add_vfsmount_mark()).
  */
 int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	     const unsigned char *file_name, u32 cookie)
@@ -232,6 +239,9 @@ int fsnotify(struct inode *to_tell, __u3
 	while (inode_node || vfsmount_node) {
 		inode_group = vfsmount_group = NULL;
 
+		/*
+		 * Read current marks and groups.
+		 */
 		if (inode_node) {
 			inode_mark = hlist_entry(srcu_dereference(inode_node, &fsnotify_mark_srcu),
 						 struct fsnotify_mark, i.i_list);
@@ -244,25 +254,43 @@ int fsnotify(struct inode *to_tell, __u3
 			vfsmount_group = vfsmount_mark->group;
 		}
 
-		if (inode_group > vfsmount_group) {
-			/* handle inode */
-			ret = send_to_group(to_tell, inode_mark, NULL, mask,
-					    data, data_is, cookie, file_name);
-			/* we didn't use the vfsmount_mark */
-			vfsmount_group = NULL;
-		} else if (vfsmount_group > inode_group) {
-			ret = send_to_group(to_tell, NULL, vfsmount_mark, mask,
-					    data, data_is, cookie, file_name);
-			inode_group = NULL;
-		} else {
-			ret = send_to_group(to_tell, inode_mark, vfsmount_mark,
-					    mask, data, data_is, cookie,
-					    file_name);
+		/*
+		 * Determine if the inode group or the vfsmount group is
+		 * first in the sorting order.
+		 * Only the mark for the group that is first will be passed to
+		 * send_to_group().
+		 */
+		if (inode_group == NULL)
+			inode_mark = NULL;
+		else if (vfsmount_group == NULL)
+			vfsmount_mark = NULL;
+		else {
+			if (inode_group->priority
+			    > vfsmount_group->priority) {
+				vfsmount_mark = NULL;
+				vfsmount_group = NULL;
+			} else if (inode_group->priority
+				   < vfsmount_group->priority) {
+				inode_mark = NULL;
+				inode_group = NULL;
+			} else if (inode_group > vfsmount_group) {
+				vfsmount_mark = NULL;
+				vfsmount_group = NULL;
+			} else if (inode_group < vfsmount_group) {
+				inode_mark = NULL;
+				inode_group = NULL;
+			}
 		}
+		ret = send_to_group(to_tell, inode_mark, vfsmount_mark,
+				    mask, data, data_is, cookie,
+				    file_name);
 
 		if (ret && (mask & ALL_FSNOTIFY_PERM_EVENTS))
 			goto out;
 
+		/*
+		 * Point to the next marks.
+		 */
 		if (inode_group)
 			inode_node = srcu_dereference(inode_node->next,
 						      &fsnotify_mark_srcu);
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

fallocate-create-fan_modify-and-in_modify-events.patch
fanotify-ignore-marks-not-respected.patch
fanotify-ignore-marks-not-respected-fix.patch

