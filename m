Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B508AC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F86610F9
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350361AbhICU6h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350526AbhICU6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F68B610E5;
        Fri,  3 Sep 2021 20:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702654;
        bh=UVkaWDcNEEbYFIPhzVSOO1657ffTxQdRLRZfp+HbzQE=;
        h=Date:From:To:Subject:From;
        b=sjlveJLnqIOFf9Ip2fXng2CBucvtDX6kVYKe+yKbDEbIXAZOvJX+ZeVM7FIFgn/Td
         361oevDxTsxUE8qCXDZ0NgMnkr0zN9bwrhc4jusIDbkEmg32K6g75p0Z53J4zScSic
         KTI1dZhjGthTy+92T6LGLmF8X+Wncsbg72Zv/Hf4=
Date:   Fri, 03 Sep 2021 13:57:33 -0700
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
 memcg-enable-accounting-for-mnt_cache-entries.patch removed from -mm tree
Message-ID: <20210903205733.9kERv9jlE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for mnt_cache entries
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-mnt_cache-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for mnt_cache entries

Patch series "memcg accounting from OpenVZ", v7.

OpenVZ uses memory accounting 20+ years since v2.2.x linux kernels. 
Initially we used our own accounting subsystem, then partially committed
it to upstream, and a few years ago switched to cgroups v1.  Now we're
rebasing again, revising our old patches and trying to push them upstream.

We try to protect the host system from any misuse of kernel memory
allocation triggered by untrusted users inside the containers.

Patch-set is addressed mostly to cgroups maintainers and cgroups@ mailing
list, though I would be very grateful for any comments from maintainersi
of affected subsystems or other people added in cc:

Compared to the upstream, we additionally account the following kernel objects:
- network devices and its Tx/Rx queues
- ipv4/v6 addresses and routing-related objects
- inet_bind_bucket cache objects
- VLAN group arrays
- ipv6/sit: ip_tunnel_prl
- scm_fp_list objects used by SCM_RIGHTS messages of Unix sockets 
- nsproxy and namespace objects itself
- IPC objects: semaphores, message queues and share memory segments
- mounts
- pollfd and select bits arrays
- signals and posix timers
- file lock
- fasync_struct used by the file lease code and driver's fasync queues 
- tty objects
- per-mm LDT

We have an incorrect/incomplete/obsoleted accounting for few other kernel
objects: sk_filter, af_packets, netlink and xt_counters for iptables. 
They require rework and probably will be dropped at all.

Also we're going to add an accounting for nft, however it is not ready
yet.

We have not tested performance on upstream, however, our performance team
compares our current RHEL7-based production kernel and reports that they
are at least not worse as the according original RHEL7 kernel.


This patch (of 10):

The kernel allocates ~400 bytes of 'struct mount' for any new mount. 
Creating a new mount namespace clones most of the parent mounts, and this
can be repeated many times.  Additionally, each mount allocates up to
PATH_MAX=4096 bytes for mnt->mnt_devname.

It makes sense to account for these allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/045db11f-4a45-7c9b-2664-5b32c2b44943@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/namespace.c~memcg-enable-accounting-for-mnt_cache-entries
+++ a/fs/namespace.c
@@ -203,7 +203,8 @@ static struct mount *alloc_vfsmnt(const
 			goto out_free_cache;
 
 		if (name) {
-			mnt->mnt_devname = kstrdup_const(name, GFP_KERNEL);
+			mnt->mnt_devname = kstrdup_const(name,
+							 GFP_KERNEL_ACCOUNT);
 			if (!mnt->mnt_devname)
 				goto out_free_id;
 		}
@@ -4240,7 +4241,7 @@ void __init mnt_init(void)
 	int err;
 
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
-			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
 				sizeof(struct hlist_head),
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


