Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF1FC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09194610FF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350523AbhICU6t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235926AbhICU6h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B2CD60E9B;
        Fri,  3 Sep 2021 20:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702657;
        bh=xr6QhH+9CVHKPH8qGDrzBssvmNWMM9cBKGaIUE3Dr8Q=;
        h=Date:From:To:Subject:From;
        b=2PiHZ18PMwjBXWKKJUUvb4/G0j/h5rd3rM0v2BqU6l9AELhQ4Sbo8WI8ioR/dj74O
         ZGU+5+sIdACSSOLUV0ICwtpj/JBmwN1gFUYkhgRVgeYJWzr5ma5nvgThOZ1mTw1xQg
         EF6JYrYB1D554AWRB/7M7FpKM2ZvmIXu7SUFHwN8=
Date:   Fri, 03 Sep 2021 13:57:36 -0700
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
 memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch removed
 from -mm tree
Message-ID: <20210903205736.zd1MOQff3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for pollfd and select bits arrays
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for pollfd and select bits arrays

User can call select/poll system calls with a large number of assigned
file descriptors and force kernel to allocate up to several pages of
memory till end of these sleeping system calls.  We have here long-living
unaccounted per-task allocations.

It makes sense to account for these allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/56e31cb5-6e1e-bdba-d7ca-be64b9842363@virtuozzo.com
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

 fs/select.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/select.c~memcg-enable-accounting-for-pollfd-and-select-bits-arrays
+++ a/fs/select.c
@@ -655,7 +655,7 @@ int core_sys_select(int n, fd_set __user
 			goto out_nofds;
 
 		alloc_size = 6 * size;
-		bits = kvmalloc(alloc_size, GFP_KERNEL);
+		bits = kvmalloc(alloc_size, GFP_KERNEL_ACCOUNT);
 		if (!bits)
 			goto out_nofds;
 	}
@@ -1000,7 +1000,7 @@ static int do_sys_poll(struct pollfd __u
 
 		len = min(todo, POLLFD_PER_PAGE);
 		walk = walk->next = kmalloc(struct_size(walk, entries, len),
-					    GFP_KERNEL);
+					    GFP_KERNEL_ACCOUNT);
 		if (!walk) {
 			err = -ENOMEM;
 			goto out_fds;
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


