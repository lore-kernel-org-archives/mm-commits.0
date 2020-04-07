From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 093/166] fs/proc/inode.c: annotate close_pdeo()
 for sparse
Date: Mon, 06 Apr 2020 20:08:55 -0700
Message-ID: <20200407030855.k7UikmtKV%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgDGDI7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:59 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jules Irenge <jbi.octave@gmail.com>
Subject: fs/proc/inode.c: annotate close_pdeo() for sparse

Fix sparse locking imbalance warning:

	warning: context imbalance in close_pdeo() - unexpected unlock

Link: http://lkml.kernel.org/r/20200227201538.GA30462@avx2
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/inode.c~proc-annotate-close_pdeo-for-sparse
+++ a/fs/proc/inode.c
@@ -202,6 +202,7 @@ static void unuse_pde(struct proc_dir_en
 
 /* pde is locked on entry, unlocked on exit */
 static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
+	__releases(&pde->pde_unload_lock)
 {
 	/*
 	 * close() (proc_reg_release()) can't delete an entry and proceed:
_
