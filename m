From: akpm@linux-foundation.org
Subject: - quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:10 -0700
Message-ID: <200808130852.m7D8qAtE008183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200AbYHMIwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: documentation for sending "below quota" messages via netlink and tiny doc update
has been removed from the -mm tree.  Its filename was
     quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: documentation for sending "below quota" messages via netlink and tiny doc update
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/quota.txt |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/quota.txt~quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update Documentation/filesystems/quota.txt
--- a/Documentation/filesystems/quota.txt~quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update
+++ a/Documentation/filesystems/quota.txt
@@ -3,14 +3,14 @@ Quota subsystem
 ===============
 
 Quota subsystem allows system administrator to set limits on used space and
-number of used inodes (inode is a filesystem structure which is associated
-with each file or directory) for users and/or groups. For both used space and
-number of used inodes there are actually two limits. The first one is called
-softlimit and the second one hardlimit.  An user can never exceed a hardlimit
-for any resource. User is allowed to exceed softlimit but only for limited
-period of time. This period is called "grace period" or "grace time". When
-grace time is over, user is not able to allocate more space/inodes until he
-frees enough of them to get below softlimit.
+number of used inodes (inode is a filesystem structure which is associated with
+each file or directory) for users and/or groups. For both used space and number
+of used inodes there are actually two limits. The first one is called softlimit
+and the second one hardlimit.  An user can never exceed a hardlimit for any
+resource (unless he has CAP_SYS_RESOURCE capability). User is allowed to exceed
+softlimit but only for limited period of time. This period is called "grace
+period" or "grace time". When grace time is over, user is not able to allocate
+more space/inodes until he frees enough of them to get below softlimit.
 
 Quota limits (and amount of grace time) are set independently for each
 filesystem.
@@ -53,6 +53,12 @@ in parentheses):
 		QUOTA_NL_BSOFTLONGWARN - space (block) softlimit is exceeded
 		  longer than given grace period.
 		QUOTA_NL_BSOFTWARN - space (block) softlimit
+	  - four warnings are also defined for the event when user stops
+	    exceeding some limit:
+		QUOTA_NL_IHARDBELOW - inode hardlimit
+		QUOTA_NL_ISOFTBELOW - inode softlimit
+		QUOTA_NL_BHARDBELOW - space (block) hardlimit
+		QUOTA_NL_BSOFTBELOW - space (block) softlimit
         QUOTA_NL_A_DEV_MAJOR (u32)
 	  - major number of a device with the affected filesystem
         QUOTA_NL_A_DEV_MINOR (u32)
_

Patches currently in -mm which might be from jack@suse.cz are

jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch
quota-remove-cvs-keywords.patch

