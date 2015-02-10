From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-make-generic_block_fiemap-sig-tolerant-fix.patch removed from -mm tree
Date: Tue, 10 Feb 2015 14:00:16 -0800
Message-ID: <54da7f70.CtCbkJS+5TZv3CzL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbbBJWAR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 17:00:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mtk.manpages@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-make-generic_block_fiemap-sig-tolerant-fix
has been removed from the -mm tree.  Its filename was
     fs-make-generic_block_fiemap-sig-tolerant-fix.patch

This patch was dropped because it was folded into fs-make-generic_block_fiemap-sig-tolerant.patch

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: fs-make-generic_block_fiemap-sig-tolerant-fix

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/fiemap.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/fiemap.txt~fs-make-generic_block_fiemap-sig-tolerant-fix Documentation/filesystems/fiemap.txt
--- a/Documentation/filesystems/fiemap.txt~fs-make-generic_block_fiemap-sig-tolerant-fix
+++ a/Documentation/filesystems/fiemap.txt
@@ -196,7 +196,8 @@ struct fiemap_extent_info {
 };
 
 It is intended that the file system should not need to access any of this
-structure directly.
+structure directly. Filesystem handlers should be tolerant to signals and return
+EINTR once fatal signal received.
 
 
 Flag checking should be done at the beginning of the ->fiemap callback via the
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

fs-make-generic_block_fiemap-sig-tolerant.patch

