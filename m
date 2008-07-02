From: akpm@linux-foundation.org
Subject: + utc-timestamp-option-for-fat-filesystems-fix.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:08:16 -0700
Message-ID: <200807021708.m62H8Gp0026942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbYGBRIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@skyrush.com, hirofumi@mail.parknet.co.jp


The patch titled
     UTC timestamp option for FAT filesystems fix
has been added to the -mm tree.  Its filename is
     utc-timestamp-option-for-fat-filesystems-fix.patch

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

fatfs-add-utc-timestamp-option.patch
utc-timestamp-option-for-fat-filesystems-fix.patch

