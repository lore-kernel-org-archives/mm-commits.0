From: akpm@linux-foundation.org
Subject: + fs-make-generic_block_fiemap-sig-tolerant.patch added to -mm
 tree
Date: Thu, 18 Dec 2014 15:13:04 -0800
Message-ID: <54935f80.Ue2cUgcLXykQzqbi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaLRXNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 18:13:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mtk.manpages@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsioctl.c: make generic_block_fiemap() signal-tolerant
has been added to the -mm tree.  Its filename is
     fs-make-generic_block_fiemap-sig-tolerant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-make-generic_block_fiemap-sig-tolerant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-make-generic_block_fiemap-sig-tolerant.patch

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
Subject: fsioctl.c: make generic_block_fiemap() signal-tolerant

__generic_block_fiemap may spin very long time for large sparse files.

Without this patch an unprivileged user may abuse system resources simply
by spawning a vast number of unkilable busyloops (works on ext2/ext3):

truncate --size 1T test
for ((i=0;i<1024;i++))
do
       filefrag test > /dev/null &
done

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ioctl.c~fs-make-generic_block_fiemap-sig-tolerant fs/ioctl.c
--- a/fs/ioctl.c~fs-make-generic_block_fiemap-sig-tolerant
+++ a/fs/ioctl.c
@@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode
 				past_eof = true;
 		}
 		cond_resched();
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
 	} while (1);
 
 	/* If ret is 1 then we just hit the end of the extent array */
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
fs-make-generic_block_fiemap-sig-tolerant.patch

