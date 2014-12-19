From: akpm@linux-foundation.org
Subject: + fs-make-generic_block_fiemap-sig-tolerant-fix.patch added to
 -mm tree
Date: Fri, 19 Dec 2014 13:13:14 -0800
Message-ID: <549494ea.j0nfvnaJ2xPO0RWW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaLSVNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 16:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mtk.manpages@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-make-generic_block_fiemap-sig-tolerant-fix
has been added to the -mm tree.  Its filename is
     fs-make-generic_block_fiemap-sig-tolerant-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-make-generic_block_fiemap-sig-tolerant-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-make-generic_block_fiemap-sig-tolerant-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
fs-make-generic_block_fiemap-sig-tolerant.patch
fs-make-generic_block_fiemap-sig-tolerant-fix.patch

