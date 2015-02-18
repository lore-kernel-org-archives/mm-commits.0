From: akpm@linux-foundation.org
Subject: [merged] fs-affs-amigaffsc-remove-else-after-return.patch removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:38 -0800
Message-ID: <54e4eb6a.8pLkTULHTyx2Zv7u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/amigaffs.c: remove else after return
has been removed from the -mm tree.  Its filename was
     fs-affs-amigaffsc-remove-else-after-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/amigaffs.c: remove else after return

else is unnecessary after return -ENAMETOOLONG

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-amigaffsc-remove-else-after-return fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-amigaffsc-remove-else-after-return
+++ a/fs/affs/amigaffs.c
@@ -486,8 +486,7 @@ affs_check_name(const unsigned char *nam
 	if (len > AFFSNAMEMAX) {
 		if (notruncate)
 			return -ENAMETOOLONG;
-		else
-			len = AFFSNAMEMAX;
+		len = AFFSNAMEMAX;
 	}
 	for (i = 0; i < len; i++) {
 		if (name[i] < ' ' || name[i] == ':'
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

