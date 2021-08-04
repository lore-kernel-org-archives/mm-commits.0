Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67763C4338F
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 00:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C436103C
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 00:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhHDAHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 20:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhHDAHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 20:07:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8622760F45;
        Wed,  4 Aug 2021 00:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628035613;
        bh=hklzzfRQ7VsdfAVLZ+KlJbdhYM8oPJF3UsEyyk4rIaY=;
        h=Date:From:To:Subject:From;
        b=aDkhYMtp27+F6nUGW5c8eB3e0b8l/dkr5J9HZ4LD3ch7aw2+VTDDvgsQQGaFPfdiW
         rLJcZRSO5dzhmARj28SsEcwdqb5Ydf598Vv5LfLka2oOMiTzAucqe/LPdG1O4kUTxb
         jTast3gH9AlqOe4Niie7sFK5Dx9DrQudIZ70RfPs=
Date:   Tue, 03 Aug 2021 17:06:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        npiggin@gmail.com, anton@ozlabs.org, akpm@linux-foundation.org
Subject:  +
 fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch added to -mm
 tree
Message-ID: <20210804000653.HD54x%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix
has been added to the -mm tree.  Its filename is
     fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix

fix build, fix printk typo

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/user.c~fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix
+++ a/kernel/user.c
@@ -138,7 +138,9 @@ static void free_user(struct user_struct
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
+#ifdef CONFIG_EPOLL
 	percpu_counter_destroy(&up->epoll_watches);
+#endif
 	kmem_cache_free(uid_cachep, up);
 }
 
@@ -186,10 +188,12 @@ struct user_struct *alloc_uid(kuid_t uid
 
 		new->uid = uid;
 		refcount_set(&new->__count, 1);
+#ifdef CONFIG_EPOLL
 		if (percpu_counter_init(&new->epoll_watches, 0, GFP_KERNEL)) {
 			kmem_cache_free(uid_cachep, new);
 			return NULL;
 		}
+#endif
 		ratelimit_state_init(&new->ratelimit, HZ, 100);
 		ratelimit_set_flags(&new->ratelimit, RATELIMIT_MSG_ON_RELEASE);
 
@@ -200,7 +204,9 @@ struct user_struct *alloc_uid(kuid_t uid
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+#ifdef CONFIG_EPOLL
 			percpu_counter_destroy(&new->epoll_watches);
+#endif
 			kmem_cache_free(uid_cachep, new);
 		} else {
 			uid_hash_insert(new, hashent);
@@ -222,8 +228,10 @@ static int __init uid_cache_init(void)
 	for(n = 0; n < UIDHASH_SZ; ++n)
 		INIT_HLIST_HEAD(uidhash_table + n);
 
+#ifdef CONFIG_EPOLL
 	if (percpu_counter_init(&root_user.epoll_watches, 0, GFP_KERNEL))
-		panic("percpu cpunter alloc failed");
+		panic("percpu counter alloc failed");
+#endif
 
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

