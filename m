From: akpm@linux-foundation.org
Subject: - mutex_unlock-later-in-seq_lseek.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:11 -0700
Message-ID: <200707162055.l6GKtBeM001891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37233 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbXGPVFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     mutex_unlock() later in seq_lseek()
has been removed from the -mm tree.  Its filename was
     mutex_unlock-later-in-seq_lseek.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mutex_unlock() later in seq_lseek()
From: Alexey Dobriyan <adobriyan@sw.ru>

All manipulations with struct seq_file::version are done under
struct seq_file::lock except one introduced in commit
d6b7a781c51c91dd054e5c437885205592faac21
aka "[PATCH] Speed up /proc/pid/maps"

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/seq_file.c~mutex_unlock-later-in-seq_lseek fs/seq_file.c
--- a/fs/seq_file.c~mutex_unlock-later-in-seq_lseek
+++ a/fs/seq_file.c
@@ -260,8 +260,8 @@ loff_t seq_lseek(struct file *file, loff
 				}
 			}
 	}
-	mutex_unlock(&m->lock);
 	file->f_version = m->version;
+	mutex_unlock(&m->lock);
 	return retval;
 }
 EXPORT_SYMBOL(seq_lseek);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-sparse-false-positives-re-bug_onptr.patch
