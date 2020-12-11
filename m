Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848B3C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 06:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568CA23F2A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 06:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390505AbgLKG06 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 01:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389253AbgLKG0d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 01:26:33 -0500
Date:   Thu, 10 Dec 2020 22:25:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607667951;
        bh=ypn9Qvt0zAonODJ9NZmV2ceb5ffjb3NpmrlLihmwVAk=;
        h=From:To:Subject:From;
        b=EoMBPcaJoN/O5EGjB/hROgckhssxMCstHCbbNmfGsjiCcZtzvqKjRhGlxNQDbQwgQ
         tdfGIpnzIwYnnc1HQvABy5Xyf8YLmKpB5OQyJSCxJU1gYca34/rVGj0T/QbBmw99iW
         O4K3KDzyBKWz7yFZgHycLXNSVHiBBzGB3O2n/qTQ=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ebiederm@xmission.com,
        mm-commits@vger.kernel.org, sh_def@163.com
Subject:  + fs-proc-make-pde_get-return-nothing.patch added to -mm
 tree
Message-ID: <20201211062550.CsoVL-S6F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc: make pde_get() return nothing
has been added to the -mm tree.  Its filename is
     fs-proc-make-pde_get-return-nothing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-make-pde_get-return-nothing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-make-pde_get-return-nothing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: fs/proc: make pde_get() return nothing

We don't need pde_get()'s return value, so make pde_get() return nothing

Link: https://lkml.kernel.org/r/20201211061944.GA2387571@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/proc/internal.h~fs-proc-make-pde_get-return-nothing
+++ a/fs/proc/internal.h
@@ -190,10 +190,9 @@ struct dentry *proc_lookup_de(struct ino
 extern int proc_readdir(struct file *, struct dir_context *);
 int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
 
-static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
+static inline void pde_get(struct proc_dir_entry *pde)
 {
 	refcount_inc(&pde->refcnt);
-	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
 
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-shmemc-make-shmem_mapping-inline.patch
mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-compaction-move-compaction_suitables-comment-to-right-place.patch
mm-compaction-make-defer_compaction-and-compaction_deferred-static.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
fs-proc-make-pde_get-return-nothing.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

