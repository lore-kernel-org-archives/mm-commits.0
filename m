From: akpm@linux-foundation.org
Subject: [to-be-updated]
 documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch removed from -mm tree
Date: Thu, 25 Sep 2014 12:56:06 -0700
Message-ID: <54247356.2n391Id74z195ogZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaIYT4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 15:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/vfat.txt: update the limitation for fat fallocate
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: Documentation/filesystems/vfat.txt: update the limitation for fat fallocate

Update the limitation for fat fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN Documentation/filesystems/vfat.txt~documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4 Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4
+++ a/Documentation/filesystems/vfat.txt
@@ -180,6 +180,16 @@ dos1xfloppy  -- If set, use a fallback d
 
 <bool>: 0,1,yes,no,true,false
 
+LIMITATION
+---------------------------------------------------------------------
+* The fallocated region of file is discarded at umount/evict time
+  when using fallocate with FALLOC_FL_KEEP_SIZE.
+  So, User should assume that fallocated region can be discarded at
+  last close if there is memory pressure resulting in eviction of
+  the inode from the memory. As a result, for any dependency on
+  the fallocated region, user should make sure to recheck fallocate
+  after reopening the file.
+
 TODO
 ----------------------------------------------------------------------
 * Need to get rid of the raw scanning stuff.  Instead, always use
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

linux-next.patch

