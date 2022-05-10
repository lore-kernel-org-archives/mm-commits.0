Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE436C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiEJERy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiEJEQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97A82415D1
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F0BDB81AFB
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4FBC385A6;
        Tue, 10 May 2022 04:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155935;
        bh=yk+pb6xNxEWc0N/0UrKYzQoHEDxeujKa/scf9Yb3VAY=;
        h=Date:To:From:Subject:From;
        b=v9mh0VWp/1c2wZlrnD9vYswOgGNB+BkECGkTS48LAIvFlcm0tq1XX7hNtK2JOoezN
         cAy6bfi0rA+bs1005W9yluFFSfGbax1MOekf14PKW3ench6K2N3OLEUdv48rRIRwdT
         fwfdLkfgkAVwjMKNWSs/tLaZCwZ1amkP2iG39tlQ=
Date:   Mon, 09 May 2022 21:12:15 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        yang.yang29@zte.com.cn, willy@infradead.org, vbabka@suse.cz,
        stephen.s.brennan@oracle.com, sfr@canb.auug.org.au,
        ran.xiaokai@zte.com.cn, ohoono.kwon@samsung.com, lkp@intel.com,
        keescook@chromium.org, feng.tang@intel.com, adobriyan@gmail.com,
        xu.xin16@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-count-ksm-merging-pages-for-each-process.patch removed from -mm tree
Message-Id: <20220510041215.CE4FBC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: count ksm merging pages for each process
has been removed from the -mm tree.  Its filename was
     ksm-count-ksm-merging-pages-for-each-process.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: count ksm merging pages for each process

Some applications or containers want to use KSM by calling madvise() to
advise areas of address space to be MERGEABLE.  But they may not know
which applications are more likely to cause real merges in the
deployment.  If this patch is applied, it helps them know their
corresponding number of merged pages, and then optimize their app code.

As current KSM only counts the number of KSM merging pages(e.g. 
ksm_pages_sharing and ksm_pages_shared) of the whole system, we cannot see
the more fine-grained KSM merging, for the upper application optimization,
the merging area cannot be set easily according to the KSM page merging
probability of each process.  Therefore, it is necessary to add extra
statistical means so that the upper level users can know the detailed KSM
merging information of each process.

We add a new proc file named as ksm_merging_pages under /proc/<pid>/ to
indicate the involved ksm merging pages of this process.

[akpm@linux-foundation.org: fix comment typo, remove BUG_ON()s]
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
 include/linux/mm_types.h |    7 +++++++
 mm/ksm.c                 |    8 ++++++++
 3 files changed, 37 insertions(+)

--- a/fs/proc/base.c~ksm-count-ksm-merging-pages-for-each-process
+++ a/fs/proc/base.c
@@ -3154,6 +3154,22 @@ static int proc_pid_patch_state(struct s
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
@@ -3285,6 +3301,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SECCOMP_CACHE_DEBUG
 	ONE("seccomp_cache", S_IRUSR, proc_pid_seccomp_cache),
 #endif
+#ifdef CONFIG_KSM
+	ONE("ksm_merging_pages",  S_IRUSR, proc_pid_ksm_merging_pages),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
@@ -3618,6 +3637,9 @@ static const struct pid_entry tid_base_s
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
@@ -655,6 +655,13 @@ struct mm_struct {
 #ifdef CONFIG_IOMMU_SVA
 		u32 pasid;
 #endif
+#ifdef CONFIG_KSM
+		/*
+		 * Represent how many pages of this process are involved in KSM
+		 * merging.
+		 */
+		unsigned long ksm_merging_pages;
+#endif
 	} __randomize_layout;
 
 	/*
--- a/mm/ksm.c~ksm-count-ksm-merging-pages-for-each-process
+++ a/mm/ksm.c
@@ -638,6 +638,9 @@ static void remove_node_from_stable_tree
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
+
+		rmap_item->mm->ksm_merging_pages--;
+
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
@@ -785,6 +788,9 @@ static void remove_rmap_item_from_tree(s
 			ksm_pages_sharing--;
 		else
 			ksm_pages_shared--;
+
+		rmap_item->mm->ksm_merging_pages--;
+
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 
@@ -2007,6 +2013,8 @@ static void stable_tree_append(struct rm
 		ksm_pages_sharing++;
 	else
 		ksm_pages_shared++;
+
+	rmap_item->mm->ksm_merging_pages++;
 }
 
 /*
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


