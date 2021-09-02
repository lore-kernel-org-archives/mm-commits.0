Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD1CC43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28859610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347904AbhIBV4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347894AbhIBVz5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C66960E8B;
        Thu,  2 Sep 2021 21:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619698;
        bh=UBVR3jWJCtq0hNU6qct+nHE5T9wsdjh/MfOZ4gbwamc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RpFvL5fYnEUsg6YnG4W/Hc11Nu0Q4pun+HnLXJXEidWi9FNpfp/o4N5nKwhQc/kt8
         tfE69qUDUvPFNrnUx3vMkGgNgAMVuJ79m1YnMQtmNLZvR6lTFsLZv0BV38c45b6ZMd
         vYqtxSZPup6PI0j+v/vacjZYU6ofdEx2DVKJGq+Q=
Date:   Thu, 02 Sep 2021 14:54:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org,
        vvs@virtuozzo.com
Subject:  [patch 095/212] memcg: enable accounting for pids in
 nested pid namespaces
Message-ID: <20210902215457.N-_B9QW4J%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
