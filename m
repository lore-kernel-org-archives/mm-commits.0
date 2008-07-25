From: akpm@linux-foundation.org
Subject: - utc-timestamp-option-for-fat-filesystems-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:44 -0700
Message-ID: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbYGYXGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@skyrush.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     UTC timestamp option for FAT filesystems fix
has been removed from the -mm tree.  Its filename was
     utc-timestamp-option-for-fat-filesystems-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UTC timestamp option for FAT filesystems fix
From: Joe Peterson <joe@skyrush.com>

Signed-off-by: Joe Peterson <joe@skyrush.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN Documentation/filesystems/vfat.txt~utc-timestamp-option-for-fat-filesystems-fix Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~utc-timestamp-option-for-fat-filesystems-fix
+++ a/Documentation/filesystems/vfat.txt
@@ -96,6 +96,14 @@ shortname=lower|win95|winnt|mixed
 			emulate the Windows 95 rule for create.
 		 Default setting is `lower'.
 
+tz=UTC        -- Interpret timestamps as UTC rather than local time.
+                 This option disables the conversion of timestamps
+                 between local time (as used by Windows on FAT) and UTC
+                 (which Linux uses internally).  This is particuluarly
+                 useful when mounting devices (like digital cameras)
+                 that are set to UTC in order to avoid the pitfalls of
+                 local time.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
_

Patches currently in -mm which might be from joe@skyrush.com are

origin.patch

