Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD0BC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5356610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347911AbhIBV46 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347579AbhIBV4n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937D1610A0;
        Thu,  2 Sep 2021 21:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619736;
        bh=FvpoNv3okN1vKXiQ2X+xRY9ipNWNr950Jx344FsQ89c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BwVfug+Ll5cmpk49Yzcl2D8Uf2uVRetk1qcJedyKNksNtqYUZJ0EXknVxsmfChraX
         w48PnfVjAb7jkUljjirTasV3h1dlThgFhwV+hLVZdSGpPp1K3aUkK639omAor6gQBe
         5c0xcDYUnYrV7AVtvYfhVReFyIxECXwyeSeR3qmI=
Date:   Thu, 02 Sep 2021 14:55:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     0x7f454c46@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, avagin@gmail.com, axboe@kernel.dk,
        bfields@fieldses.org, bp@alien8.de, bp@suse.de,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hpa@zytor.com, jirislaby@kernel.org, jlayton@kernel.org,
        ktkhai@virtuozzo.com, linux-mm@kvack.org, lizefan.x@bytedance.com,
        mhocko@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        nglaive@gmail.com, oleg@redhat.com, serge@hallyn.com,
        shakeelb@google.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com,
        viro@zeniv.linux.org.uk, vvs@virtuozzo.com
Subject:  [patch 105/212] memcg: enable accounting for signals
Message-ID: <20210902215535.KL9kIhN7S%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for signals

When a user send a signal to any another processes it forces the kernel to
allocate memory for 'struct sigqueue' objects.  The number of signals is
limited by RLIMIT_SIGPENDING resource limit, but even the default settings
allow each user to consume up to several megabytes of memory.

It makes sense to account for these allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/e34e958c-e785-712e-a62a-2c7b66c646c7@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c~memcg-enable-accounting-for-signals
+++ a/kernel/signal.c
@@ -4663,7 +4663,7 @@ void __init signals_init(void)
 {
 	siginfo_buildtime_checks();
 
-	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
+	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC | SLAB_ACCOUNT);
 }
 
 #ifdef CONFIG_KGDB_KDB
_
