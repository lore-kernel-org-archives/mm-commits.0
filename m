From: akpm@linux-foundation.org
Subject: + quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:32:51 -0700
Message-ID: <200808052032.m75KWp8x022076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757285AbYHEUdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: documentation for sending "below quota" messages via netlink and tiny doc update
has been added to the -mm tree.  Its filename is
     quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

quota-documentation-for-sending-below-quota-messages-via-netlink-and-tiny-doc-update.patch
linux-next.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch

