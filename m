From: akpm@linux-foundation.org
Subject: [folded-merged] affs-kstrdup-memory-handling-fix.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 12:09:56 -0700
Message-ID: <55300904.d78uN76sutXylHQj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbDPTJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:09:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabf@skynet.be, sanidhya.gatech@gmail.com, taesoo@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: affs-kstrdup-memory-handling-fix
has been removed from the -mm tree.  Its filename was
     affs-kstrdup-memory-handling-fix.patch

This patch was dropped because it was folded into affs-kstrdup-memory-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: affs-kstrdup-memory-handling-fix

cleanup

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: Taesoo kim <taesoo@gatech.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/affs/super.c~affs-kstrdup-memory-handling-fix fs/affs/super.c
--- a/fs/affs/super.c~affs-kstrdup-memory-handling-fix
+++ a/fs/affs/super.c
@@ -521,11 +521,11 @@ affs_remount(struct super_block *sb, int
 	int			 root_block;
 	unsigned long		 mount_flags;
 	int			 res = 0;
-	char			*new_opts = kstrdup(data, GFP_KERNEL);
+	char			*new_opts;
 	char			 volume[32];
 	char			*prefix = NULL;
 
