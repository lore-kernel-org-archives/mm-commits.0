From: akpm@linux-foundation.org
Subject: + ocfs2-return-non-zero-st_blocks-for-inline-data.patch added to
 -mm tree
Date: Tue, 24 Nov 2015 15:13:16 -0800
Message-ID: <5654ef0c.ZLrXbSau6VqU2rZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbbKXXNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 18:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.haxby@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: return non-zero st_blocks for inline data
has been added to the -mm tree.  Its filename is
     ocfs2-return-non-zero-st_blocks-for-inline-data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-return-non-zero-st_blocks-for-inline-data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-return-non-zero-st_blocks-for-inline-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Haxby <john.haxby@oracle.com>
Subject: ocfs2: return non-zero st_blocks for inline data

Some versions of tar assume that files with st_blocks == 0 do not contain
any data and will skip reading them entirely.  See also commit
9206c561554c ("ext4: return non-zero st_blocks for inline data").

Signed-off-by: John Haxby <john.haxby@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-return-non-zero-st_blocks-for-inline-data fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-return-non-zero-st_blocks-for-inline-data
+++ a/fs/ocfs2/file.c
@@ -1302,6 +1302,14 @@ int ocfs2_getattr(struct vfsmount *mnt,
 	}
 
 	generic_fillattr(inode, stat);
+	/*
+	 * If there is inline data in the inode, the inode will normally not
+	 * have data blocks allocated (it may have an external xattr block).
+	 * Report at least one sector for such files, so tools like tar, rsync,
+	 * others don't incorrectly think the file is completely sparse.
+	 */
+	if (unlikely(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
+		stat->blocks += (stat->size + 511)>>9;
 
 	/* We set the blksize from the cluster size for performance */
 	stat->blksize = osb->s_clustersize;
_

Patches currently in -mm which might be from john.haxby@oracle.com are

ocfs2-return-non-zero-st_blocks-for-inline-data.patch

