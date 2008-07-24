From: akpm@linux-foundation.org
Subject: - flag-parametersi-nonblock-in-anon_inode_getfd.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:38 -0700
Message-ID: <200807242327.m6ONRclZ011178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756718AbYGXX3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@redhat.com, davidel@xmailserver.org, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     flag parameters: NONBLOCK in anon_inode_getfd
has been removed from the -mm tree.  Its filename was
     flag-parametersi-nonblock-in-anon_inode_getfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flag parameters: NONBLOCK in anon_inode_getfd
From: Ulrich Drepper <drepper@redhat.com>

Building on the previous change to anon_inode_getfd, this patch introduces
support for handling of O_NONBLOCK in addition to the already supported
O_CLOEXEC.  Following patches will take advantage of this support.  As can be
seen, the additional support for supporting this functionality is minimal.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/anon_inodes.c~flag-parametersi-nonblock-in-anon_inode_getfd fs/anon_inodes.c
--- a/fs/anon_inodes.c~flag-parametersi-nonblock-in-anon_inode_getfd
+++ a/fs/anon_inodes.c
@@ -116,7 +116,7 @@ int anon_inode_getfd(const char *name, c
 	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
-	file->f_flags = O_RDWR;
+	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
 	file->f_version = 0;
 	file->private_data = priv;
 
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
linux-next.patch

