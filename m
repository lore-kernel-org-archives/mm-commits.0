Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7A5CE7A95
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 14:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjIYOz0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 10:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjIYOz0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 10:55:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9647D10D;
        Mon, 25 Sep 2023 07:55:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D000C433C7;
        Mon, 25 Sep 2023 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695653719;
        bh=CVFyjEfwtWHCPvQV11TeR5X613S7x2bWLOmnUCpNc+s=;
        h=Date:To:From:Subject:From;
        b=P5+rvEYyk3uAc2Q87ci/gSEzr2OTGkcnrWZbbGSyVBcYp5/PzUsHWkYhHKNfAVWzU
         yS1V6vSnflcg27tsPfogNaZMqEBydBA0rmljs4vYS8IL36i9tRC1AswHmRmKPGrfDc
         083w8mPL4p7+ngwQmWg1JjB66787dt9aPE9N3pDg=
Date:   Mon, 25 Sep 2023 07:55:18 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, jpiotrowski@linux.microsoft.com,
        hannes@cmpxchg.org, gregkh@linuxfoundation.org, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-reconsider-kmemlimit_in_bytes-deprecation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230925145519.0D000C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: reconsider kmem.limit_in_bytes deprecation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-reconsider-kmemlimit_in_bytes-deprecation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-reconsider-kmemlimit_in_bytes-deprecation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm, memcg: reconsider kmem.limit_in_bytes deprecation
Date: Thu, 21 Sep 2023 09:38:29 +0200

This reverts commits 86327e8eb94c ("memcg: drop kmem.limit_in_bytes") and
partially reverts 58056f77502f ("memcg, kmem: further deprecate
kmem.limit_in_bytes") which have incrementally removed support for the
kernel memory accounting hard limit.  Unfortunately it has turned out that
there is still userspace depending on the existence of
memory.kmem.limit_in_bytes [1].  The underlying functionality is not
really required but the non-existent file just confuses the userspace
which fails in the result.  The patch to fix this on the userspace side
has been submitted but it is hard to predict how it will propagate through
the maze of 3rd party consumers of the software.

Now, reverting alone 86327e8eb94c is not an option because there is
another set of userspace which cannot cope with ENOTSUPP returned when
writing to the file.  Therefore we have to go and revisit 58056f77502f as
well.  There are two ways to go ahead.  Either we give up on the
deprecation and fully revert 58056f77502f as well or we can keep
kmem.limit_in_bytes but make the write a noop and warn about the fact. 
This should work for both known breaking workloads which depend on the
existence but do not depend on the hard limit enforcement.

Note to backporters to stable trees.  a8c49af3be5f ("memcg: add per-memcg
total kernel memory stat") introduced in 4.18 has added memcg_account_kmem
so the accounting is not done by obj_cgroup_charge_pages directly for v1
anymore.  Prior kernels need to add it explicitly (thanks to Johannes for
pointing this out).

Link: http://lkml.kernel.org/r/20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net [1]
Link: https://lkml.kernel.org/r/ZRE5VJozPZt9bRPy@dhcp22.suse.cz
Fixes: 86327e8eb94c ("memcg: drop kmem.limit_in_bytes")
Fixes: 58056f77502f ("memcg, kmem: further deprecate kmem.limit_in_bytes")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    7 +++++++
 mm/memcontrol.c                                |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcg-reconsider-kmemlimit_in_bytes-deprecation
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -92,6 +92,13 @@ Brief summary of control files.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
+ memory.kmem.limit_in_bytes          Deprecated knob to set and read the kernel
+                                     memory hard limit. Kernel hard limit is not
+                                     supported since 5.16. Writing any value to
+                                     do file will not have any effect same as if
+                                     nokmem kernel parameter was specified.
+                                     Kernel memory is still charged and reported
+                                     by memory.kmem.usage_in_bytes.
  memory.kmem.usage_in_bytes          show current kernel memory allocation
  memory.kmem.failcnt                 show the number of kernel memory usage
 				     hits limits
--- a/mm/memcontrol.c~mm-memcg-reconsider-kmemlimit_in_bytes-deprecation
+++ a/mm/memcontrol.c
@@ -3097,6 +3097,7 @@ static void obj_cgroup_uncharge_pages(st
 static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 				   unsigned int nr_pages)
 {
+	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	int ret;
 
@@ -3867,6 +3868,13 @@ static ssize_t mem_cgroup_write(struct k
 		case _MEMSWAP:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, true);
 			break;
+		case _KMEM:
+			pr_warn_once("kmem.limit_in_bytes is deprecated and will be removed. "
+				     "Writing any value to this file has no effect. "
+				     "Please report your usecase to linux-mm@kvack.org if you "
+				     "depend on this functionality.\n");
+			ret = 0;
+			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
 			break;
@@ -5078,6 +5086,12 @@ static struct cftype mem_cgroup_legacy_f
 	},
 #endif
 	{
+		.name = "kmem.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
+		.write = mem_cgroup_write,
+		.read_u64 = mem_cgroup_read_u64,
+	},
+	{
 		.name = "kmem.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read_u64,
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memcg-reconsider-kmemlimit_in_bytes-deprecation.patch

