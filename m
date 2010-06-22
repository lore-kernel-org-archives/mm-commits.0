From: akpm@linux-foundation.org
Subject: + tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update.patch added to -mm tree
Date: Tue, 22 Jun 2010 15:40:34 -0700
Message-ID: <201006222240.o5MMeYka006377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab0FVWlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jun 2010 18:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tim.c.chen@linux.intel.com, hughd@google.com


The patch titled
     tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update
has been added to the -mm tree.  Its filename is
     tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update
From: Tim Chen <tim.c.chen@linux.intel.com>

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update mm/shmem.c
--- a/mm/shmem.c~tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update
+++ a/mm/shmem.c
@@ -2248,7 +2248,7 @@ static int shmem_remount_fs(struct super
 
 	spin_lock(&sbinfo->stat_lock);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
-	if (config.max_blocks < percpu_counter_sum(&sbinfo->used_blocks))
+	if (percpu_counter_compare(&sbinfo->used_blocks, config.max_blocks) > 0)
 		goto out;
 	if (config.max_inodes < inodes)
 		goto out;
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

tmpfs-add-accurate-compare-function-to-percpu_counter-library.patch
tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-blocks.patch
tmpfs-make-tmpfs-scalable-with-percpu_counter-for-used-update.patch

