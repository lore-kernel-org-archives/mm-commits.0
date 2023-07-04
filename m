Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C109CEB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 16:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjGDQqf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 12:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjGDQqf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 12:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607BA1A1;
        Tue,  4 Jul 2023 09:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7F6461309;
        Tue,  4 Jul 2023 16:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B946C433C8;
        Tue,  4 Jul 2023 16:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688489193;
        bh=T5zXY+bfM5uTDRq2rUkdLVw/dFNlAfaxiwpz/wxVXF0=;
        h=Date:To:From:Subject:From;
        b=dQdBtDQ5dXxUykeyfYgCNbnhKXPdhioji8eEL+F3zyDs7mYeiSX1pjyryzG/I5dax
         DcWuG7xDmAzlT9f7zhxIdzJT6TqjmzA+289jQwKDD7A0/KSUSvbuczU7H04u4v+dRo
         m/f9ptBzkGsqH4L5r1KSI/Mn6t1dcT87MPwp5oNM=
Date:   Tue, 04 Jul 2023 09:46:32 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, hannes@cmpxchg.org, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-drop-kmemlimit_in_bytes.patch added to mm-unstable branch
Message-Id: <20230704164633.3B946C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: drop kmem.limit_in_bytes
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-drop-kmemlimit_in_bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-drop-kmemlimit_in_bytes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: memcg: drop kmem.limit_in_bytes
Date: Tue, 4 Jul 2023 13:52:40 +0200

kmem.limit_in_bytes (v1 way to limit kernel memory usage) has been
deprecated since 58056f77502f ("memcg, kmem: further deprecate
kmem.limit_in_bytes") merged in 5.16.  We haven't heard about any serious
users since then but it seems that the mere presence of the file is
causing more harm than good.  We (SUSE) have had several bug reports from
customers where Docker based containers started to fail because a write to
kmem.limit_in_bytes has failed.

This was unexpected because runc code only expects ENOENT (kmem disabled)
or EBUSY (tasks already running within cgroup).  So a new error code was
unexpected and the whole container startup failed.  This has been later
addressed by
https://github.com/opencontainers/runc/commit/52390d68040637dfc77f9fda6bbe70952423d380
so current Docker runtimes do not suffer from the problem anymore.  There
are still older version of Docker in use and likely hard to get rid of
completely.

Address this by wiping out the file completely and effectively get back to
pre 4.5 era and CONFIG_MEMCG_KMEM=n configuration.

I would recommend backporting to stable trees which have picked up
58056f77502f ("memcg, kmem: further deprecate kmem.limit_in_bytes").

Link: https://lkml.kernel.org/r/20230704115240.14672-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    2 --
 mm/memcontrol.c                                |   13 -------------
 2 files changed, 15 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-drop-kmemlimit_in_bytes
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -92,8 +92,6 @@ Brief summary of control files.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
- memory.kmem.limit_in_bytes          This knob is deprecated and writing to
-                                     it will return -ENOTSUPP.
  memory.kmem.usage_in_bytes          show current kernel memory allocation
  memory.kmem.failcnt                 show the number of kernel memory usage
 				     hits limits
--- a/mm/memcontrol.c~memcg-drop-kmemlimit_in_bytes
+++ a/mm/memcontrol.c
@@ -3708,9 +3708,6 @@ static u64 mem_cgroup_read_u64(struct cg
 	case _MEMSWAP:
 		counter = &memcg->memsw;
 		break;
-	case _KMEM:
-		counter = &memcg->kmem;
-		break;
 	case _TCP:
 		counter = &memcg->tcpmem;
 		break;
@@ -3871,10 +3868,6 @@ static ssize_t mem_cgroup_write(struct k
 		case _MEMSWAP:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
-		case _KMEM:
-			/* kmem.limit_in_bytes is deprecated. */
-			ret = -EOPNOTSUPP;
-			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
 			break;
@@ -5086,12 +5079,6 @@ static struct cftype mem_cgroup_legacy_f
 	},
 #endif
 	{
-		.name = "kmem.limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
-	},
-	{
 		.name = "kmem.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read_u64,
_

Patches currently in -mm which might be from mhocko@suse.com are

memcg-drop-kmemlimit_in_bytes.patch

