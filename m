Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F077C4320A
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4792460F94
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhG0VIv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233306AbhG0VIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 17:08:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADB2960F6C;
        Tue, 27 Jul 2021 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627420093;
        bh=Aqo+62qLaGdvUTnCHspwUX1Cl005Y1VCn5zZqHmsJ84=;
        h=Date:From:To:Subject:From;
        b=oKzWxRfFEKEtFXJ4q0m00hWantLg25jBMBIrfQAGZJF5H9jdIAbtt2YZWmd2z7hIM
         UfJfxixRUIQo5MmfiNbbtiqoAZw4+sAlnwzmCS4zs3HdMdCz26RHUxWP1kT9Qiupe6
         EDsx4826dBgm91b0ojLRbjMXSHpllSPtppjIBluM=
Date:   Tue, 27 Jul 2021 14:08:12 -0700
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
Subject:  + memcg-enable-accounting-for-fasync_cache.patch added to
 -mm tree
Message-ID: <20210727210812.UH1wz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for fasync_cache
has been added to the -mm tree.  Its filename is
     memcg-enable-accounting-for-fasync_cache.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-enable-accounting-for-fasync_cache.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-enable-accounting-for-fasync_cache.patch

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
Subject: memcg: enable accounting for fasync_cache

fasync_struct is used by almost all character device drivers to set up the
fasync queue, and for regular files by the file lease code.  This
structure is quite small but long-living and it can be assigned for any
open file.

It makes sense to account for its allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Link: https://lkml.kernel.org/r/1b408625-d71c-0b26-b0b6-9baf00f93e69@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
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
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yutian Yang <nglaive@gmail.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fcntl.c~memcg-enable-accounting-for-fasync_cache
+++ a/fs/fcntl.c
@@ -1049,7 +1049,8 @@ static int __init fcntl_init(void)
 			__FMODE_EXEC | __FMODE_NONOTIFY));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
-		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
+					 sizeof(struct fasync_struct), 0,
+					 SLAB_PANIC | SLAB_ACCOUNT, NULL);
 	return 0;
 }
 
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

