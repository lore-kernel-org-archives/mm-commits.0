Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F76C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFA620878
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976423;
	bh=lCCj9/RlmlQae3iuweNEKS14LX3hhbe04ab+YPkQsMo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zTlSWlQNvF8sXbcPlxzbvx4Nep29VdbaNJSGfHJbIULMV8VA9Q1lZ26DAzbsd1uD3
	 PeY1OkjPKBP/XzORlA4WBHP95+9tS3lDir5a1CBkmyg4Qyov8TMyXGpgz7Rutp7ei7
	 kvdsXbXWXe/seIlDNwvjIXjFjVlm4KcUXk4O94uc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439881AbgJQXNn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F41F208B6;
        Sat, 17 Oct 2020 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976422;
        bh=lCCj9/RlmlQae3iuweNEKS14LX3hhbe04ab+YPkQsMo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jSzXO4jsFiTOWhEqvj+2ICZcZokTjFd/X4bXh9xY5PwekclvcnZLVc7htgtDVscns
         OLdTYHPSHWJFfOrsl57M59l8rocAIot0piRdpuYlmITypcE43V6fwtvEYUq9PmLekB
         dW9LqLQPu4HZqZdnt4xon4YaN7zanrUoGTcvoxuY=
Date:   Sat, 17 Oct 2020 16:13:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dschatzberg@fb.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 02/40] mm, memcg: rework remote charging API to
 support nesting
Message-ID: <20201017231340.JBcWsleuj%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm, memcg: rework remote charging API to support nesting

Currently the remote memcg charging API consists of two functions:
memalloc_use_memcg() and memalloc_unuse_memcg(), which set and clear the
memcg value, which overwrites the memcg of the current task.

  memalloc_use_memcg(target_memcg);
  <...>
  memalloc_unuse_memcg();

It works perfectly for allocations performed from a normal context,
however an attempt to call it from an interrupt context or just nest two
remote charging blocks will lead to an incorrect accounting.  On exit from
the inner block the active memcg will be cleared instead of being
restored.

  memalloc_use_memcg(target_memcg);

  memalloc_use_memcg(target_memcg_2);
    <...>
    memalloc_unuse_memcg();

    Error: allocation here are charged to the memcg of the current
    process instead of target_memcg.

  memalloc_unuse_memcg();

This patch extends the remote charging API by switching to a single
function: struct mem_cgroup *set_active_memcg(struct mem_cgroup *memcg),
which sets the new value and returns the old one.  So a remote charging
block will look like:

  old_memcg = set_active_memcg(target_memcg);
  <...>
  set_active_memcg(old_memcg);

This patch is heavily based on the patch by Johannes Weiner, which can be
found here: https://lkml.org/lkml/2020/5/28/806 .

Link: https://lkml.kernel.org/r/20200821212056.3769116-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Schatzberg <dschatzberg@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                          |    6 ++---
 fs/notify/fanotify/fanotify.c        |    5 ++--
 fs/notify/inotify/inotify_fsnotify.c |    5 ++--
 include/linux/sched/mm.h             |   30 ++++++++-----------------
 mm/memcontrol.c                      |    6 ++---
 5 files changed, 22 insertions(+), 30 deletions(-)

--- a/fs/buffer.c~mm-rework-remote-memcg-charging-api-to-support-nesting
+++ a/fs/buffer.c
@@ -842,13 +842,13 @@ struct buffer_head *alloc_page_buffers(s
 	struct buffer_head *bh, *head;
 	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
 	long offset;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *old_memcg;
 
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
 	memcg = get_mem_cgroup_from_page(page);
-	memalloc_use_memcg(memcg);
+	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
 	offset = PAGE_SIZE;
@@ -867,7 +867,7 @@ struct buffer_head *alloc_page_buffers(s
 		set_bh_page(bh, page, offset);
 	}
 out:
-	memalloc_unuse_memcg();
+	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 	return head;
 /*
--- a/fs/notify/fanotify/fanotify.c~mm-rework-remote-memcg-charging-api-to-support-nesting
+++ a/fs/notify/fanotify/fanotify.c
@@ -531,6 +531,7 @@ static struct fanotify_event *fanotify_a
 	struct inode *dirid = fanotify_dfid_inode(mask, data, data_type, dir);
 	const struct path *path = fsnotify_data_path(data, data_type);
 	unsigned int fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
+	struct mem_cgroup *old_memcg;
 	struct inode *child = NULL;
 	bool name_event = false;
 
@@ -580,7 +581,7 @@ static struct fanotify_event *fanotify_a
 		gfp |= __GFP_RETRY_MAYFAIL;
 
 	/* Whoever is interested in the event, pays for the allocation. */
-	memalloc_use_memcg(group->memcg);
+	old_memcg = set_active_memcg(group->memcg);
 
 	if (fanotify_is_perm_event(mask)) {
 		event = fanotify_alloc_perm_event(path, gfp);
@@ -608,7 +609,7 @@ static struct fanotify_event *fanotify_a
 		event->pid = get_pid(task_tgid(current));
 
 out:
-	memalloc_unuse_memcg();
+	set_active_memcg(old_memcg);
 	return event;
 }
 
--- a/fs/notify/inotify/inotify_fsnotify.c~mm-rework-remote-memcg-charging-api-to-support-nesting
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -66,6 +66,7 @@ static int inotify_one_event(struct fsno
 	int ret;
 	int len = 0;
 	int alloc_len = sizeof(struct inotify_event_info);
+	struct mem_cgroup *old_memcg;
 
 	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
 	    path && d_unlinked(path->dentry))
@@ -87,9 +88,9 @@ static int inotify_one_event(struct fsno
 	 * trigger OOM killer in the target monitoring memcg as it may have
 	 * security repercussion.
 	 */
-	memalloc_use_memcg(group->memcg);
+	old_memcg = set_active_memcg(group->memcg);
 	event = kmalloc(alloc_len, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
-	memalloc_unuse_memcg();
+	set_active_memcg(old_memcg);
 
 	if (unlikely(!event)) {
 		/*
--- a/include/linux/sched/mm.h~mm-rework-remote-memcg-charging-api-to-support-nesting
+++ a/include/linux/sched/mm.h
@@ -280,38 +280,28 @@ static inline void memalloc_nocma_restor
 
 #ifdef CONFIG_MEMCG
 /**
- * memalloc_use_memcg - Starts the remote memcg charging scope.
+ * set_active_memcg - Starts the remote memcg charging scope.
  * @memcg: memcg to charge.
  *
  * This function marks the beginning of the remote memcg charging scope. All the
  * __GFP_ACCOUNT allocations till the end of the scope will be charged to the
  * given memcg.
  *
- * NOTE: This function is not nesting safe.
+ * NOTE: This function can nest. Users must save the return value and
+ * reset the previous value after their own charging scope is over.
  */
-static inline void memalloc_use_memcg(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *
+set_active_memcg(struct mem_cgroup *memcg)
 {
-	WARN_ON_ONCE(current->active_memcg);
+	struct mem_cgroup *old = current->active_memcg;
 	current->active_memcg = memcg;
-}
-
-/**
- * memalloc_unuse_memcg - Ends the remote memcg charging scope.
- *
- * This function marks the end of the remote memcg charging scope started by
- * memalloc_use_memcg().
- */
-static inline void memalloc_unuse_memcg(void)
-{
-	current->active_memcg = NULL;
+	return old;
 }
 #else
-static inline void memalloc_use_memcg(struct mem_cgroup *memcg)
-{
-}
-
-static inline void memalloc_unuse_memcg(void)
+static inline struct mem_cgroup *
+set_active_memcg(struct mem_cgroup *memcg)
 {
+	return NULL;
 }
 #endif
 
--- a/mm/memcontrol.c~mm-rework-remote-memcg-charging-api-to-support-nesting
+++ a/mm/memcontrol.c
@@ -5290,12 +5290,12 @@ static struct cgroup_subsys_state * __re
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct mem_cgroup *parent = mem_cgroup_from_css(parent_css);
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *old_memcg;
 	long error = -ENOMEM;
 
-	memalloc_use_memcg(parent);
+	old_memcg = set_active_memcg(parent);
 	memcg = mem_cgroup_alloc();
-	memalloc_unuse_memcg();
+	set_active_memcg(old_memcg);
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
 
_
