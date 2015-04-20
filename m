From: akpm@linux-foundation.org
Subject: [merged] affs-kstrdup-memory-handling.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:14 -0700
Message-ID: <5535516e.VC+zWSkbSe+x70fX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbbDTTNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanidhya.gatech@gmail.com, fabf@skynet.be, taesoo@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: affs: kstrdup() memory handling
has been removed from the -mm tree.  Its filename was
     affs-kstrdup-memory-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: affs: kstrdup() memory handling

There is a possibility of kstrdup() failure upon memory pressure. 
Therefore, returning ENOMEM even for new_opts.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: Taesoo kim <taesoo@gatech.edu>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/affs/super.c~affs-kstrdup-memory-handling fs/affs/super.c
--- a/fs/affs/super.c~affs-kstrdup-memory-handling
+++ a/fs/affs/super.c
@@ -521,10 +521,14 @@ affs_remount(struct super_block *sb, int
 	int			 root_block;
 	unsigned long		 mount_flags;
 	int			 res = 0;
-	char			*new_opts = kstrdup(data, GFP_KERNEL);
+	char			*new_opts;
 	char			 volume[32];
 	char			*prefix = NULL;
 
+	new_opts = kstrdup(data, GFP_KERNEL);
+	if (!new_opts)
+		return -ENOMEM;
+
 	pr_debug("%s(flags=0x%x,opts=\"%s\")\n", __func__, *flags, data);
 
 	sync_filesystem(sb);
_

Patches currently in -mm which might be from sanidhya.gatech@gmail.com are

origin.patch
ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
linux-next.patch

