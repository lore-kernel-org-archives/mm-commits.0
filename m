Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A34C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C93611AD
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344530AbhIIUis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343998AbhIIUir (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:38:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA99B6113E;
        Thu,  9 Sep 2021 20:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631219857;
        bh=z3HVQM2khLEGXR9xdx0nuKKfTHI9j78I/YtxBEoXubM=;
        h=Date:From:To:Subject:From;
        b=iA13LobBwza0WXuS+g6/ZicS3F9aq8VKIzT0NofeGwUZHSKh7ClOHJfm8O5wD12XL
         wiCptZz4Se8izsYj0VtU7GDyRlw6VpbhKMN5kkcVVDKV2rTcM23rHbTMhj5rwpyy0l
         ftVAgH2lUVHkimk2aoTTocreGGLPRZpce6V4ZR0Q=
Date:   Thu, 09 Sep 2021 13:37:36 -0700
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
Subject:  [to-be-updated]
 memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch removed
 from -mm tree
Message-ID: <20210909203736._fGTjvuui%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for pollfd and select bits arrays
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch

This patch was dropped because an updated version will be merged

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

memcg-enable-accounting-for-file-lock-caches.patch
mm-use-in_task-in-mempolicy_slab_node.patch

