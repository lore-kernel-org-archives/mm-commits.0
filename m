From: akpm@linux-foundation.org
Subject: + fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes.patch
 added to -mm tree
Date: Tue, 14 Oct 2014 14:28:20 -0700
Message-ID: <543d9574.eSzgMs3ATEv81Mqj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaJNV2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 17:28:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jerry.hoemann@hp.com, jeffrey.t.kirsher@intel.com, kenhelias@firemail.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: next_i is freed during fsnotify_unmount_inodes.
has been added to the -mm tree.  Its filename is
     fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerry Hoemann <jerry.hoemann@hp.com>
Subject: fsnotify: next_i is freed during fsnotify_unmount_inodes.

During file system stress testing on 3.10 and 3.12 based kernels, the
umount command occasionally hung in fsnotify_unmount_inodes in the section
of code:

                spin_lock(&inode->i_lock);
                if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
                        spin_unlock(&inode->i_lock);
                        continue;
                }

As this section of code holds the global inode_sb_list_lock, eventually
the system hangs trying to acquire the lock.

Multiple crash dumps showed:

The inode->i_state == 0x60 and i_count == 0 and i_sb_list would point back
at itself.  As this is not the value of list upon entry to the function,
the kernel never exits the loop.

To help narrow down problem, the call to list_del_init in
inode_sb_list_del was changed to list_del.  This poisons the pointers in
the i_sb_list and causes a kernel to panic if it transverse a freed inode.

Subsequent stress testing paniced in fsnotify_unmount_inodes at the bottom
of the list_for_each_entry_safe loop showing next_i had become free.

We believe the root cause of the problem is that next_i is being freed
during the window of time that the list_for_each_entry_safe loop
temporarily releases inode_sb_list_lock to call fsnotify and
fsnotify_inode_delete.

The code in fsnotify_unmount_inodes attempts to prevent the freeing of
inode and next_i by calling __iget.  However, the code doesn't do the
__iget call on next_i

	if i_count == 0 or
	if i_state & (I_FREEING | I_WILL_FREE)


The patch addresses this issue by advancing next_i in the above two cases
until we either find a next_i which we can __iget or we reach the end of
the list.  This makes the handling of next_i more closely match the
handling of the variable "inode."

The time to reproduce the hang is highly variable (from hours to days.) We
ran the stress test on a 3.10 kernel with the proposed patch for a week
without failure.

During list_for_each_entry_safe, next_i is becoming free causing
the loop to never terminate.  Advance next_i in those cases where
__iget is not done.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Ken Helias <kenhelias@firemail.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inode_mark.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/notify/inode_mark.c~fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes
+++ a/fs/notify/inode_mark.c
@@ -288,20 +288,25 @@ void fsnotify_unmount_inodes(struct list
 		spin_unlock(&inode->i_lock);
 
 		/* In case the dropping of a reference would nuke next_i. */
-		if ((&next_i->i_sb_list != list) &&
-		    atomic_read(&next_i->i_count)) {
+		while (&next_i->i_sb_list != list) {
 			spin_lock(&next_i->i_lock);
-			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE))) {
+			if (!(next_i->i_state & (I_FREEING | I_WILL_FREE)) &&
+						atomic_read(&next_i->i_count)) {
 				__iget(next_i);
 				need_iput = next_i;
+				spin_unlock(&next_i->i_lock);
+				break;
 			}
 			spin_unlock(&next_i->i_lock);
+			next_i = list_entry(next_i->i_sb_list.next,
+						struct inode, i_sb_list);
 		}
 
 		/*
-		 * We can safely drop inode_sb_list_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.
+		 * We can safely drop inode_sb_list_lock here because either
+		 * we actually hold references on both inode and next_i or
+		 * end of list.  Also no new inodes will be added since the
+		 * umount has begun.
 		 */
 		spin_unlock(&inode_sb_list_lock);
 
_

Patches currently in -mm which might be from jerry.hoemann@hp.com are

fsnotify-next_i-is-freed-during-fsnotify_unmount_inodes.patch
linux-next.patch

