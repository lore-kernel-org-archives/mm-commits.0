From: akpm@linux-foundation.org
Subject: +
 documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch added to -mm tree
Date: Tue, 04 Mar 2014 13:20:28 -0800
Message-ID: <5316439c.+QNFxt2gJWDSwy+0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbaCDVU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:20:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: + documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch added to -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:20:28 -0800


The patch titled
     Subject: Documentation/filesystems/vfat.txt: update the limitation for fat fallocate
has been added to the -mm tree.  Its filename is
     documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -175,6 +175,16 @@ nfs=stale_rw|nostale_ro
 
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

fat-add-i_disksize-to-represent-uninitialized-size-v4.patch
fat-add-fat_fallocate-operation-v4.patch
fat-zero-out-seek-range-on-_fat_get_block-v4.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch
linux-next.patch

