From: akpm@linux-foundation.org
Subject: [patch 025/114] proc: spread likely/unlikely a bit
Date: Tue, 06 Feb 2018 15:37:28 -0800
Message-ID: <20180206233728.Vvo9Z5Y9C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXh3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: spread likely/unlikely a bit

use_pde() is used at every open/read/write/...  of every random /proc
file.  Negative refcount happens only if PDE is being deleted by module
(read: never).  So it gets "likely".

unuse_pde() gets "unlikely" for the same reason.

close_pdeo() gets unlikely as the completion is filled only if there is a
race between PDE removal and close() (read: never ever).

It even saves code on x86_64 defconfig:

	add/remove: 0/0 grow/shrink: 1/2 up/down: 2/-20 (-18)
	Function                                     old     new   delta
	close_pdeo                                   183     185      +2
	proc_reg_get_unmapped_area                   119     111      -8
	proc_reg_poll                                 85      73     -12

Link: http://lkml.kernel.org/r/20180104175657.GA5204@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/inode.c~proc-spread-likely-unlikely-a-bit fs/proc/inode.c
--- a/fs/proc/inode.c~proc-spread-likely-unlikely-a-bit
+++ a/fs/proc/inode.c
@@ -129,12 +129,12 @@ enum {BIAS = -1U<<31};
 
 static inline int use_pde(struct proc_dir_entry *pde)
 {
-	return atomic_inc_unless_negative(&pde->in_use);
+	return likely(atomic_inc_unless_negative(&pde->in_use));
 }
 
 static void unuse_pde(struct proc_dir_entry *pde)
 {
-	if (atomic_dec_return(&pde->in_use) == BIAS)
+	if (unlikely(atomic_dec_return(&pde->in_use) == BIAS))
 		complete(pde->pde_unload_completion);
 }
 
@@ -167,7 +167,7 @@ static void close_pdeo(struct proc_dir_e
 		spin_lock(&pde->pde_unload_lock);
 		/* After ->release. */
 		list_del(&pdeo->lh);
-		if (pdeo->c)
+		if (unlikely(pdeo->c))
 			complete(pdeo->c);
 		kfree(pdeo);
 	}
@@ -421,7 +421,7 @@ static const char *proc_get_link(struct
 				 struct delayed_call *done)
 {
 	struct proc_dir_entry *pde = PDE(inode);
-	if (unlikely(!use_pde(pde)))
+	if (!use_pde(pde))
 		return ERR_PTR(-EINVAL);
 	set_delayed_call(done, proc_put_link, pde);
 	return pde->data;
_
