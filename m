From: akpm@linux-foundation.org
Subject: + mutex_unlock-later-in-seq_lseek.patch added to -mm tree
Date: Tue, 29 May 2007 20:09:44 -0700
Message-ID: <200705300309.l4U39hc7018127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbXE3DKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:10:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     mutex_unlock() later in seq_lseek()
has been added to the -mm tree.  Its filename is
     mutex_unlock-later-in-seq_lseek.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-vmic-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
