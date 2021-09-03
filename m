Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7457C43217
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9056E61131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhICU6Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350417AbhICU6Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 765A0601FD;
        Fri,  3 Sep 2021 20:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702643;
        bh=aEtoh5UIssuE4RoAK6cmSwY7f0wRbwO1e5bnXTCK/u8=;
        h=Date:From:To:Subject:From;
        b=0BPuKJGFrS8N3KhtkGCimYk04CMbxIzW/TJeMJTU3EvAgYAg/oEqo5Gzak6dSM+3U
         qkyrT/idNqexRIM4amxtMQAWfV6VNUWYIVHUXevLaOQNk90EaQ32dU7OTgqLO5hsjO
         IZV2uvY3iONwPidhzfGJ/MLaW3kT81GgaIADjYHY=
Date:   Fri, 03 Sep 2021 13:57:23 -0700
From:   akpm@linux-foundation.org
To:     christian.brauner@ubuntu.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, vvs@virtuozzo.com
Subject:  [merged]
 memcg-enable-accounting-for-pids-in-nested-pid-namespaces.patch removed
 from -mm tree
Message-ID: <20210903205723.FpHmqYoxx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: enable accounting for pids in nested pid namespaces
has been removed from the -mm tree.  Its filename was
     memcg-enable-accounting-for-pids-in-nested-pid-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: enable accounting for pids in nested pid namespaces

Commit 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
enabled memcg accounting for pids allocated from init_pid_ns.pid_cachep,
but forgot to adjust the setting for nested pid namespaces.  As a result,
pid memory is not accounted exactly where it is really needed, inside
memcg-limited containers with their own pid namespaces.

Pid was one the first kernel objects enabled for memcg accounting.=20
init_pid_ns.pid_cachep marked by SLAB_ACCOUNT and we can expect that any
new pids in the system are memcg-accounted.

Though recently I've noticed that it is wrong.  nested pid namespaces
creates own slab caches for pid objects, nested pids have increased size
because contain id both for all parent and for own pid namespaces.  The
problem is that these slab caches are _NOT_ marked by SLAB_ACCOUNT, as a
result any pids allocated in nested pid namespaces are not
memcg-accounted.

Pid struct in nested pid namespace consumes up to 500 bytes memory, 100000
such objects gives us up to ~50Mb unaccounted memory, this allow container
to exceed assigned memcg limits.

Link: https://lkml.kernel.org/r/8b6de616-fd1a-02c6-cbdb-976ecdcfa604@virtuo=
zzo.com
Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/pid_namespace.c~memcg-enable-accounting-for-pids-in-nested-pid=
-namespaces
+++ a/kernel/pid_namespace.c
@@ -51,7 +51,8 @@ static struct kmem_cache *create_pid_cac
 	mutex_lock(&pid_caches_mutex);
 	/* Name collision forces to do allocation under mutex. */
 	if (!*pkc)
-		*pkc =3D kmem_cache_create(name, len, 0, SLAB_HWCACHE_ALIGN, 0);
+		*pkc =3D kmem_cache_create(name, len, 0,
+					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
 	mutex_unlock(&pid_caches_mutex);
 	/* current can fail, but someone else can succeed. */
 	return READ_ONCE(*pkc);
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


