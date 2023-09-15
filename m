Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B3BEED617
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjIOQNg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbjIOQN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:13:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E10E2134
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:12:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F37C433C7;
        Fri, 15 Sep 2023 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694794363;
        bh=yntNPPyO7QE8QP2CuZf+MSaoY2yxFwC0ccJuprR8PAg=;
        h=Date:To:From:Subject:From;
        b=byV5wXCfP0C8ikJGw3w0YsGDu3lwDTFx9fVdTX4g3q0iXw+nJdvfsnFCxu1bfxDZv
         u3zDlVUhEQrHQ6OOnilXGqc/R/DsggzkCadlpsBJhdE9Pc5k9EopAH0cgX91KhyVi0
         ObEjH0cqiy9CQXky8JUYSNBsTKuir+6vcf0E/bnM=
Date:   Fri, 15 Sep 2023 09:12:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        oleg@redhat.com, Liam.Howlett@oracle.com,
        giulio.benetti@benettiengineering.com, dave@stgolabs.net,
        ben.wolsieffer@hefring.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-nommu-fix-empty-proc-pid-maps.patch added to mm-hotfixes-unstable branch
Message-Id: <20230915161243.D4F37C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: nommu: fix empty /proc/<pid>/maps
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-nommu-fix-empty-proc-pid-maps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-nommu-fix-empty-proc-pid-maps.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Subject: proc: nommu: fix empty /proc/<pid>/maps
Date: Fri, 15 Sep 2023 12:00:56 -0400

On no-MMU, /proc/<pid>/maps reads as an empty file.  This happens because
find_vma(mm, 0) always returns NULL (assuming no vma actually contains the
zero address, which is normally the case).

To fix this bug and improve the maintainability in the future, this patch
makes the no-MMU implementation as similar as possible to the MMU
implementation.

The only remaining differences are the lack of hold/release_task_mempolicy
and the extra code to shoehorn the gate vma into the iterator.

This has been tested on top of 6.5.3 on an STM32F746.

Link: https://lkml.kernel.org/r/20230915160055.971059-2-ben.wolsieffer@hefring.com
Fixes: 0c563f148043 ("proc: remove VMA rbtree use from nommu")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h   |    2 --
 fs/proc/task_nommu.c |   37 ++++++++++++++++++++++---------------
 2 files changed, 22 insertions(+), 17 deletions(-)

--- a/fs/proc/internal.h~proc-nommu-fix-empty-proc-pid-maps
+++ a/fs/proc/internal.h
@@ -289,9 +289,7 @@ struct proc_maps_private {
 	struct inode *inode;
 	struct task_struct *task;
 	struct mm_struct *mm;
-#ifdef CONFIG_MMU
 	struct vma_iterator iter;
-#endif
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
--- a/fs/proc/task_nommu.c~proc-nommu-fix-empty-proc-pid-maps
+++ a/fs/proc/task_nommu.c
@@ -175,15 +175,28 @@ static int show_map(struct seq_file *m,
 	return nommu_vma_show(m, _p);
 }
 
-static void *m_start(struct seq_file *m, loff_t *pos)
+static struct vm_area_struct *proc_get_vma(struct proc_maps_private *priv,
+						loff_t *ppos)
+{
+	struct vm_area_struct *vma = vma_next(&priv->iter);
+
+	if (vma) {
+		*ppos = vma->vm_start;
+	} else {
+		*ppos = -1UL;
+	}
+
+	return vma;
+}
+
+static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
+	unsigned long last_addr = *ppos;
 	struct mm_struct *mm;
-	struct vm_area_struct *vma;
-	unsigned long addr = *pos;
 
-	/* See m_next(). Zero at the start or after lseek. */
-	if (addr == -1UL)
+	/* See proc_get_vma(). Zero at the start or after lseek. */
+	if (last_addr == -1UL)
 		return NULL;
 
 	/* pin the task and mm whilst we play with them */
@@ -205,12 +218,9 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-EINTR);
 	}
 
-	/* start the next element from addr */
-	vma = find_vma(mm, addr);
-	if (vma)
-		return vma;
+	vma_iter_init(&priv->iter, mm, last_addr);
 
-	return NULL;
+	return proc_get_vma(priv, ppos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -227,12 +237,9 @@ static void m_stop(struct seq_file *m, v
 	priv->task = NULL;
 }
 
-static void *m_next(struct seq_file *m, void *_p, loff_t *pos)
+static void *m_next(struct seq_file *m, void *_p, loff_t *ppos)
 {
-	struct vm_area_struct *vma = _p;
-
-	*pos = vma->vm_end;
-	return find_vma(vma->vm_mm, vma->vm_end);
+	return proc_get_vma(m->private, ppos);
 }
 
 static const struct seq_operations proc_pid_maps_ops = {
_

Patches currently in -mm which might be from ben.wolsieffer@hefring.com are

proc-nommu-fix-empty-proc-pid-maps.patch

