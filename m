From: akpm@linux-foundation.org
Subject: [merged] proc-kcore-fix-seeking.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:45 -0800
Message-ID: <201101132011.p0DKBQve030174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933673Ab1AMUMG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anderson@redhat.com, fweisbec@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     /proc/kcore: fix seeking
has been removed from the -mm tree.  Its filename was
     proc-kcore-fix-seeking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/kcore: fix seeking
From: Dave Anderson <anderson@redhat.com>

Commit 34aacb2920 ("procfs: Use generic_file_llseek in /proc/kcore") broke
seeking on /proc/kcore.  This changes it back to use default_llseek in
order to restore the original behavior.

The problem with generic_file_llseek is that it only allows seeks up to
inode->i_sb->s_maxbytes, which is 2GB-1 on procfs, where the memory file
offset values in the /proc/kcore PT_LOAD segments may exceed or start
beyond that offset value.

A similar revert was made for /proc/vmcore.

Signed-off-by: Dave Anderson <anderson@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~proc-kcore-fix-seeking fs/proc/kcore.c
--- a/fs/proc/kcore.c~proc-kcore-fix-seeking
+++ a/fs/proc/kcore.c
@@ -558,7 +558,7 @@ static int open_kcore(struct inode *inod
 static const struct file_operations proc_kcore_operations = {
 	.read		= read_kcore,
 	.open		= open_kcore,
-	.llseek		= generic_file_llseek,
+	.llseek		= default_llseek,
 };
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from anderson@redhat.com are

origin.patch

