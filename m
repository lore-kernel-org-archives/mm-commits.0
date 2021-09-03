Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF3EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27DE661106
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhICU64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350417AbhICU6z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D83661104;
        Fri,  3 Sep 2021 20:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702675;
        bh=r3toSy4pnwsXY3pvx4QGcryi8LpY5sBljGgBjSkyvqU=;
        h=Date:From:To:Subject:From;
        b=0SIYDhNgTTYyHrRmJF1q25TYzeM4D7mQvUJtzZx76aHZs0R+3gQsTsJPnHol30LHs
         UEaZ+GjNnsa/v7aTH55rvjS4BJWvMXJinLPSCOvDDDgeyJk6kHkryjl73S9s4TJ9Dc
         3AeCGR1IDGTlpVzicmVH+mSuZZAAS8LGQgRi+xJg=
Date:   Fri, 03 Sep 2021 13:57:54 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, adobriyan@gmail.com, avagin@gmail.com,
        axboe@kernel.dk, bfields@fieldses.org, bp@alien8.de, bp@suse.de,
        christian.brauner@ubuntu.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, guro@fb.com, hannes@cmpxchg.org,
        hpa@zytor.com, jirislaby@kernel.org, jlayton@kernel.org,
        ktkhai@virtuozzo.com, lizefan.x@bytedance.com, mhocko@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, nglaive@gmail.com,
        oleg@redhat.com, serge@hallyn.com, shakeelb@google.com,
        tglx@linutronix.de, tj@kernel.org, vdavydov.dev@gmail.com,
        viro@zeniv.linux.org.uk, vvs@virtuozzo.com
Subject:  [merged]
 memcg-enable-accounting-for-posix_timers_cache-slab.patch removed from -mm
 tree
Message-ID: <20210903205754.kp2HkEd-z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for posix_timers_cache slab
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-posix_timers_cache-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for posix_timers_cache slab

A program may create multiple interval timers using timer_create().  For
each timer the kernel preallocates a "queued real-time signal",
Consequently, the number of timers is limited by the RLIMIT_SIGPENDING
resource limit.  The allocated object is quite small, ~250 bytes, but even
the default signal limits allow to consume up to 100 megabytes per user.

It makes sense to account for them to limit the host's memory consumption
from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/57795560-025c-267c-6b1a-dea852d95530@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
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
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/posix-timers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/posix-timers.c~memcg-enable-accounting-for-posix_timers_cache-slab
+++ a/kernel/time/posix-timers.c
@@ -273,8 +273,8 @@ static int posix_get_hrtimer_res(clockid
 static __init int init_posix_timers(void)
 {
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					sizeof (struct k_itimer), 0, SLAB_PANIC,
-					NULL);
+					sizeof(struct k_itimer), 0,
+					SLAB_PANIC | SLAB_ACCOUNT, NULL);
 	return 0;
 }
 __initcall(init_posix_timers);
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


