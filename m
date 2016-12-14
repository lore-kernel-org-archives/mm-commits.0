From: akpm@linux-foundation.org
Subject: [merged] proc-kmalloc-struct-pde_opener.patch removed from -mm
 tree
Date: Wed, 14 Dec 2016 11:26:54 -0800
Message-ID: <58519cfe.82g76rveuRY49G01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45600 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756653AbcLNT0z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: kmalloc struct pde_opener
has been removed from the -mm tree.  Its filename was
     proc-kmalloc-struct-pde_opener.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
coredump-clarify-unsafe-core_pattern-warning.patch

