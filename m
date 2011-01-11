From: akpm@linux-foundation.org
Subject: + proc-kcore-fix-seeking.patch added to -mm tree
Date: Tue, 11 Jan 2011 14:55:28 -0800
Message-ID: <201101112255.p0BMtSuD011511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686Ab1AKW4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 17:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anderson@redhat.com, fweisbec@gmail.com, stable@kernel.org


The patch titled
     /proc/kcore: fix seeking
has been added to the -mm tree.  Its filename is
     proc-kcore-fix-seeking.patch

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

proc-kcore-fix-seeking.patch

