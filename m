From: akpm@linux-foundation.org
Subject: + affs-kstrdup-memory-handling.patch added to -mm tree
Date: Mon, 23 Mar 2015 16:49:55 -0700
Message-ID: <5510a6a3.EAbFp1UvNEKqOOqw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbbCWXt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 19:49:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanidhya.gatech@gmail.com, fabf@skynet.be, taesoo@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: affs: kstrdup() memory handling
has been added to the -mm tree.  Its filename is
     affs-kstrdup-memory-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/affs-kstrdup-memory-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/affs-kstrdup-memory-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: affs: kstrdup() memory handling

There is a possibility of kstrdup() failure upon memory pressure. 
Therefore, returning ENOMEM even for new_opts.

Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: Taesoo kim <taesoo@gatech.edu>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/affs/super.c~affs-kstrdup-memory-handling fs/affs/super.c
--- a/fs/affs/super.c~affs-kstrdup-memory-handling
+++ a/fs/affs/super.c
@@ -525,6 +525,10 @@ affs_remount(struct super_block *sb, int
 	char			 volume[32];
 	char			*prefix = NULL;
 
+
+	if (!new_opts)
+		return -ENOMEM;
+
 	pr_debug("%s(flags=0x%x,opts=\"%s\")\n", __func__, *flags, data);
 
 	sync_filesystem(sb);
_

Patches currently in -mm which might be from sanidhya.gatech@gmail.com are

affs-kstrdup-memory-handling.patch
affs-kstrdup-memory-handling-fix.patch

