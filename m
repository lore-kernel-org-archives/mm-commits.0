From: akpm@linux-foundation.org
Subject: [patch 095/123] proc: kmalloc struct pde_opener
Date: Mon, 12 Dec 2016 16:45:20 -0800
Message-ID: <584f44a0.qu2QgdGbfhKjf31S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbcLMApV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:45:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: kmalloc struct pde_opener

kzalloc is too much, half of the fields will be reinitialized anyway.

If proc file doesn't have ->release hook (some still do not), clearing
is unnecessary because it will be freed immediately.

Link: http://lkml.kernel.org/r/20161029155747.GC1246@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/inode.c~proc-kmalloc-struct-pde_opener fs/proc/inode.c
--- a/fs/proc/inode.c~proc-kmalloc-struct-pde_opener
+++ a/fs/proc/inode.c
@@ -321,7 +321,7 @@ static int proc_reg_open(struct inode *i
 	 * by hand in remove_proc_entry(). For this, save opener's credentials
 	 * for later.
 	 */
-	pdeo = kzalloc(sizeof(struct pde_opener), GFP_KERNEL);
+	pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
 	if (!pdeo)
 		return -ENOMEM;
 
@@ -338,6 +338,8 @@ static int proc_reg_open(struct inode *i
 	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->file = file;
+		pdeo->closing = false;
+		pdeo->c = NULL;
 		/* Strictly for "too late" ->release in proc_reg_release(). */
 		spin_lock(&pde->pde_unload_lock);
 		list_add(&pdeo->lh, &pde->pde_openers);
_
