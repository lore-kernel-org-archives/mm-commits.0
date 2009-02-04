From: akpm@linux-foundation.org
Subject: [folded] seq_file-properly-cope-with-pread-fix.patch removed from -mm tree
Date: Wed, 04 Feb 2009 15:10:05 -0800
Message-ID: <200902042310.n14NA5T5017932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbZBDXKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 18:10:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pjt@google.com, adobriyan@gmail.com, ebiederm@xmission.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seq_file-properly-cope-with-pread fix
has been removed from the -mm tree.  Its filename was
     seq_file-properly-cope-with-pread-fix.patch

This patch was dropped because it was folded into seq_file-properly-cope-with-pread.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file-properly-cope-with-pread fix
From: Paul Turner <pjt@google.com>

seq_open needs its fmode opened up to take advantage of this

Acked-by: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/seq_file.c~seq_file-properly-cope-with-pread-fix fs/seq_file.c
--- a/fs/seq_file.c~seq_file-properly-cope-with-pread-fix
+++ a/fs/seq_file.c
@@ -48,8 +48,6 @@ int seq_open(struct file *file, const st
 	 */
 	file->f_version = 0;
 
-	/* SEQ files support lseek, but not pread/pwrite */
-	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
_

Patches currently in -mm which might be from pjt@google.com are

seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch

