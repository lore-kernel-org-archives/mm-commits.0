Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B4CC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 19:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiCYTck (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiCYTcc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 15:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749C92DA685
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 12:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15E661C3A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 18:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F00EC004DD;
        Fri, 25 Mar 2022 18:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648234669;
        bh=t5cayIUmGxRh+cirjURyLk7639Cqrjo2CTkWz/RBk+U=;
        h=Date:To:From:Subject:From;
        b=sXvoub6nqTfsZX80YVDAsyNMvoBC0h2YawxQ4e/ANIVcG9KEgOw/NiBHYbeaKMtnp
         2+VheLjcZL0WFgHC1S4FGeboGqp+bXzB8bdpzlgUmOzy2vpAp7TWJkY7fLt6Ywsx1x
         ZJrQ8PbkbR6ynpRDgJYSTyHl9vhWcUC+5tYna4VM=
Date:   Fri, 25 Mar 2022 11:57:48 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, willy@infradead.org, vbabka@suse.cz,
        stephen.s.brennan@oracle.com, sfr@canb.auug.org.au,
        ran.xiaokai@zte.com.cn, ohoono.kwon@samsung.com, lkp@intel.com,
        keescook@chromium.org, feng.tang@intel.com, adobriyan@gmail.com,
        xu.xin16@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-count-ksm-merging-pages-for-each-process.patch added to -mm tree
Message-Id: <20220325185749.0F00EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: count ksm merging pages for each process
has been added to the -mm tree.  Its filename is
     ksm-count-ksm-merging-pages-for-each-process.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ksm-count-ksm-merging-pages-for-each-process.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ksm-count-ksm-merging-pages-for-each-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: count ksm merging pages for each process

As current KSM only counts the number of KSM merging pages(e.g. 
ksm_pages_sharing and ksm_pages_shared) of the whole system, we cannot see
the more fine-grained KSM merging, for the upper application optimization,
the merging area cannot be set easily according to the KSM page merging
probability of each process.  Therefore, it is necessary to add extra
statistical means so that the upper level users can know the detailed KSM
merging information of each process.

We add a new proc file named as ksm_merging_pages under /proc/<pid>/ to
indicate the involved ksm merging pages of this process.

Link: https://lkml.kernel.org/r/20220325082318.2352853-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ohhoon Kwon <ohoono.kwon@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c           |   22 ++++++++++++++++++++++
 include/linux/mm_types.h |    8 ++++++++
 mm/ksm.c                 |   11 +++++++++++
 3 files changed, 41 insertions(+)

--- a/fs/proc/base.c~ksm-count-ksm-merging-pages-for-each-process
+++ a/fs/proc/base.c
@@ -3155,6 +3155,22 @@ static int proc_pid_patch_state(struct s
 }
 #endif /* CONFIG_LIVEPATCH */
 
+#ifdef CONFIG_KSM
+static int proc_pid_ksm_merging_pages(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	struct mm_struct *mm;
+
+	mm = get_task_mm(task);
+	if (mm) {
+		seq_printf(m, "%lu\n", mm->ksm_merging_pages);
+		mmput(mm);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_KSM */
+
 #ifdef CONFIG_STACKLEAK_METRICS
 static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
@@ -3286,6 +3302,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SECCOMP_CACHE_DEBUG
 	ONE("seccomp_cache", S_IRUSR, proc_pid_seccomp_cache),
 #endif
+#ifdef CONFIG_KSM
+	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
@@ -3619,6 +3638,9 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SECCOMP_CACHE_DEBUG
 	ONE("seccomp_cache", S_IRUSR, proc_pid_seccomp_cache),
 #endif
+#ifdef CONFIG_KSM
+	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
--- a/include/linux/mm_types.h~ksm-count-ksm-merging-pages-for-each-process
+++ a/include/linux/mm_types.h
@@ -655,6 +655,14 @@ struct mm_struct {
 #ifdef CONFIG_IOMMU_SVA
 		u32 pasid;
 #endif
+
+#ifdef CONFIG_KSM
+		/*
+		 * Represet how many pages of this process are
+		 * involved in KSM merging.
+		 */
+		unsigned long ksm_merging_pages;
+#endif
 	} __randomize_layout;
 
 	/*
--- a/mm/ksm.c~ksm-count-ksm-merging-pages-for-each-process
+++ a/mm/ksm.c
@@ -638,6 +638,10 @@ static void remove_node_from_stable_tree
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
+
+		BUG_ON(rmap_item->mm == NULL);
+		rmap_item->mm->ksm_merging_pages--;
+
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
@@ -785,6 +789,10 @@ static void remove_rmap_item_from_tree(s
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
+
+		BUG_ON(rmap_item->mm == NULL);
+		rmap_item->mm->ksm_merging_pages--;
+
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 
@@ -2007,6 +2015,9 @@ static void stable_tree_append(struct rm
 		ksm_pages_sharing++;
 	else
 		ksm_pages_shared++;
+
+	BUG_ON(rmap_item->mm == NULL);
+	rmap_item->mm->ksm_merging_pages++;
 }
 
 /*
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-count-ksm-merging-pages-for-each-process.patch

