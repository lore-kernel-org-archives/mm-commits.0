Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415CEC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A9D260FC0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhG0VIk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234826AbhG0VII (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 17:08:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1533D60FC4;
        Tue, 27 Jul 2021 21:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627420084;
        bh=CscvFP6mudB0Sk/DnkGBwjfoc8wFDoyC3M4EAYuc5+Q=;
        h=Date:From:To:Subject:From;
        b=JBFZlZCsChMagBhpjJaf3I568A6GjBygdHRdEGOKxCj+15wfR0ogeFj+z5YImnEkr
         N4vbFSwJOX1oS2rt+w4ePNBCPHGecTCf3ybV4Njqx97Yo0I9bPvWySKiNFHKAX3XdI
         A2HuSvTgsbDzw+xYo9gDm8iAKHTSWZbe4pLJyFCs=
Date:   Tue, 27 Jul 2021 14:08:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        vdavydov.dev@gmail.com, tj@kernel.org, tglx@linutronix.de,
        shakeelb@google.com, serge@hallyn.com, oleg@redhat.com,
        nglaive@gmail.com, mingo@redhat.com, mhocko@kernel.org,
        lizefan.x@bytedance.com, ktkhai@virtuozzo.com, jlayton@kernel.org,
        jirislaby@kernel.org, hpa@zytor.com, hannes@cmpxchg.org,
        guro@fb.com, gregkh@linuxfoundation.org, ebiederm@xmission.com,
        christian.brauner@ubuntu.com, bp@suse.de, bp@alien8.de,
        bfields@fieldses.org, axboe@kernel.dk, avagin@gmail.com,
        adobriyan@gmail.com, 0x7f454c46@gmail.com, vvs@virtuozzo.com
Subject:  + memcg-enable-accounting-for-mnt_cache-entries.patch added
 to -mm tree
Message-ID: <20210727210803.EoSMH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for mnt_cache entries
has been added to the -mm tree.  Its filename is
     memcg-enable-accounting-for-mnt_cache-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-accounting-for-mnt_cache-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-accounting-for-mnt_cache-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4222,7 +4223,7 @@ void __init mnt_init(void)
 	int err;
 
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
-			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
 				sizeof(struct hlist_head),
_

Patches currently in -mm which might be from vvs@virtuozzo.com are

memcg-enable-accounting-for-pids-in-nested-pid-namespaces.patch
memcg-enable-accounting-for-mnt_cache-entries.patch
memcg-enable-accounting-for-pollfd-and-select-bits-arrays.patch
memcg-enable-accounting-for-file-lock-caches.patch
memcg-enable-accounting-for-fasync_cache.patch
memcg-enable-accounting-for-new-namesapces-and-struct-nsproxy.patch
memcg-enable-accounting-of-ipc-resources.patch
memcg-enable-accounting-for-signals.patch
memcg-enable-accounting-for-posix_timers_cache-slab.patch
memcg-enable-accounting-for-tty-related-objects.patch
memcg-enable-accounting-for-ldt_struct-objects.patch

