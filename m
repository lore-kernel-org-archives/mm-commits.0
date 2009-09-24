From: akpm@linux-foundation.org
Subject: [alternative-merged] seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:30:49 -0700
Message-ID: <200909241930.n8OJUnHw023551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbZIXTbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@i-love.sakura.ne.jppenguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     seq_file: return a negative error code when seq_path_root() fails.
has been removed from the -mm tree.  Its filename was
     seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: seq_file: return a negative error code when seq_path_root() fails.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

seq_path_root() is returning a return value of successful __d_path()
instead of returning a negative value when mangle_path() failed.

This is not a bug so far because nobody is using return value of
seq_path_root().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/seq_file.c~seq_file-return-a-negative-error-code-when-seq_path_root-fails fs/seq_file.c
--- a/fs/seq_file.c~seq_file-return-a-negative-error-code-when-seq_path_root-fails
+++ a/fs/seq_file.c
@@ -470,6 +470,7 @@ int seq_path_root(struct seq_file *m, st
 				m->count = s - m->buf;
 				return 0;
 			}
+			err = -ENAMETOOLONG;
 		}
 	}
 	m->count = m->size;
_

Patches currently in -mm which might be from penguin-kernel@i-love.sakura.ne.jp are

origin.patch
linux-next.patch
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch

