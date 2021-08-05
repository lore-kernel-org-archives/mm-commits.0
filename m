Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EE3C4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B653361156
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhHEXx3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242611AbhHEXx2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:53:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D265C61131;
        Thu,  5 Aug 2021 23:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628207594;
        bh=sIsY7QXn8Up/TE93SXMctNlvpC0R2JGJIgnsJApQH3k=;
        h=Date:From:To:Subject:From;
        b=TYHd11Vc3xyB/+CjIA3nfYkaqMJlbuL9Kiba6njBJdDtzoyrS74wp3k54ndfT43/o
         BIy/MQ0ybLGv+d5p5dL4pUZn62EkhYRqVyith0fCdRfvYWdiiu5iSQcKuPwP54yccr
         ue0kJS/ASyGpfuNoM5sfsEJ3bICjLa0gamBOiSUk=
Date:   Thu, 05 Aug 2021 16:53:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        npiggin@gmail.com, linux@roeck-us.net, broonie@kernel.org,
        rdunlap@infradead.org
Subject:  +
 fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch added to -mm
 tree
Message-ID: <20210805235313.E3jgh%akpm@linux-foundation.org>
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix

fix build errors in kernel/user.c when CONFIG_EPOLL=n

Also fix typo: "cpunter" -"counter" in a panic message.

[npiggin@gmail.com: move ifdefs into wrapper functions, slightly improve panic message]
Link: https://lkml.kernel.org/r/1628051945.fens3r99ox.astroid@bobo.none
Fixes: e75b89477811 ("fs/epoll: use a per-cpu counter for user's watches count")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/kernel/user.c~fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix
+++ a/kernel/user.c
@@ -129,6 +129,21 @@ static struct user_struct *uid_hash_find
 	return NULL;
 }
 
+static int user_epoll_alloc(struct user_struct *up)
+{
+#ifdef CONFIG_EPOLL
+	return percpu_counter_init(&up->epoll_watches, 0, GFP_KERNEL);
+#endif
+	return 0;
+}
+
+static void user_epoll_free(struct user_struct *up)
+{
+#ifdef CONFIG_EPOLL
+	percpu_counter_destroy(&up->epoll_watches);
+#endif
+}
+
 /* IRQs are disabled and uidhash_lock is held upon function entry.
  * IRQ state (as stored in flags) is restored and uidhash_lock released
  * upon function exit.
@@ -138,7 +153,7 @@ static void free_user(struct user_struct
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-	percpu_counter_destroy(&up->epoll_watches);
+	user_epoll_free(up);
 	kmem_cache_free(uid_cachep, up);
 }
 
@@ -186,7 +201,7 @@ struct user_struct *alloc_uid(kuid_t uid
 
 		new->uid = uid;
 		refcount_set(&new->__count, 1);
-		if (percpu_counter_init(&new->epoll_watches, 0, GFP_KERNEL)) {
+		if (user_epoll_alloc(new)) {
 			kmem_cache_free(uid_cachep, new);
 			return NULL;
 		}
@@ -200,7 +215,7 @@ struct user_struct *alloc_uid(kuid_t uid
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
-			percpu_counter_destroy(&new->epoll_watches);
+			user_epoll_free(new);
 			kmem_cache_free(uid_cachep, new);
 		} else {
 			uid_hash_insert(new, hashent);
@@ -222,8 +237,8 @@ static int __init uid_cache_init(void)
 	for(n = 0; n < UIDHASH_SZ; ++n)
 		INIT_HLIST_HEAD(uidhash_table + n);
 
-	if (percpu_counter_init(&root_user.epoll_watches, 0, GFP_KERNEL))
-		panic("percpu cpunter alloc failed");
+	if (user_epoll_alloc(&root_user))
+		panic("root_user epoll percpu counter alloc failed");
 
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

