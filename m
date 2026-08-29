Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBCD3F1059;
	Sat, 29 Aug 2026 02:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787971642; cv=none; b=lEEOgmz3gw7jybvmVgDmq3AvLDfoUASzqBIx0mkxCzav5Ac3Ul9ciCEAAiqEZCAC8xa2wR1/eYaEl7+YSHtpYNf2CvWle3XLLsycOamCwd4W8clm/dWFCMx/Ar2Ap2LR3fScUeuDqlFDsxaHpOCc+1vml/iqrMRbe9Saa+AQUPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787971642; c=relaxed/simple;
	bh=AmAn78z+SD2y/SHzHkuuOXKzDB8ubKvyImxhcIGgriU=;
	h=Date:To:From:Subject:Message-Id; b=SSsQPYsHnVdh48agz+IH+n+4asKuVbDXkz0aBmLJzDaGsfNwW9YWa2w5dGBfZjAR6YCrqne0B7uQtO5QucNZjBrrWZCcxVbBwUT/+lo0inZdHGll1FEl/5TCl0z7jd+81ep+tEUS5zwkiOcDJp4eHmvozKLndg5ScmgYxlzrLwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJSV1lx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJSV1lx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828AB1F000E9;
	Sat, 29 Aug 2026 02:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787971640;
	bh=cKUIy2R9Ju3ZCRgCE4ZfdpFjgVl+4Z+6JKLtvXpZTrg=;
	h=Date:To:From:Subject;
	b=QJSV1lx6iTQIOmSXFiOQxiOWUIQ7SNNTZK3Qu3Zy77f14CmkKnGN49b/RRFp7YnK8
	 IRZUvO4md3M94qJE9pUBTHXPpHFfvBNVTxhWRaCNo1fiJzCB443Fhi4RCHFSwxxwGe
	 1hyri/1iCB827TYJLArpFKIamXcU4p2eUM5Co5Yc=
Date: Fri, 28 Aug 2026 19:47:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,farhad.alemi@berkeley.edu,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20260829024720.828AB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
Date: Fri, 28 Aug 2026 19:32:51 -0700

obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
try_charge_memcg(), which does not short circuit the root memcg.  That
memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg the
objcg was created for and is never updated, while memcg_reparent_objcgs()
does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
child of root therefore passes every obj_cgroup_is_root() filter but
resolves to the root memcg.

Folios keep the objcg they were charged with, so this is easy to reach
through zswap: allocate anon memory in a cgroup, move the task out, remove
the cgroup, then write to the root cgroup's memory.reclaim.  The reclaimed
folios are charged through the reparented objcg and end up in
refill_stock() with the root memcg:

  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
   refill_stock+0x644/0x940
   try_charge_memcg+0x12d6/0x1570
   __obj_cgroup_charge+0x35/0xf0
   obj_cgroup_charge+0x1de/0x210
   obj_cgroup_charge_zswap+0x83/0x270
   zswap_store+0x1620/0x2000
   swap_writeout+0x94c/0x14c0
   shrink_folio_list+0x3388/0x52b0
   [...]
   try_to_free_mem_cgroup_pages+0x30d/0x830
   user_proactive_reclaim+0x504/0x840
   memory_reclaim+0x1f/0x30

Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages()
skips refill_stock() for the root memcg, so the root's page counter grows
and is never uncharged.  It is not user visible, since memory.current is
not exposed on the root, but it is a leak.

Use try_charge(), which returns early for the root memcg, restoring the
symmetry with obj_cgroup_uncharge_pages().

The above sequence was scripted into a standalone reproducer (zswap on,
swap on a virtio disk, 512MB of anon memory faulted in inside a child of
the root cgroup, the task then migrated to the root cgroup, the child
removed, followed by "echo 600M swappiness=max > memory.reclaim" on the
root) and run in a CONFIG_DEBUG_VM=y VM.  It reproduces the splat on the
first zswap store of a reparented folio, with the same call chain as the
report.  With this patch applied the splat is gone while the zswap store
count over the run is unchanged, so the same path is still exercised. 
cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
failures.

Link: https://lore.kernel.org/20260829023251.474083-1-shakeel.butt@linux.dev
Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com/
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages
+++ a/mm/memcontrol.c
@@ -3158,7 +3158,7 @@ static int obj_cgroup_charge_pages(struc
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-avoid-charging-the-root-memcg-from-obj_cgroup_charge_pages.patch
memcg-clear-flushing_cached_charge-on-cpu-offline.patch
memcg-trim-the-per-cpu-charge-stock-instead-of-draining-it.patch
memcg-remove-v1-soft-limit-reclaim.patch
memcg-remove-mem_cgroup_shrink_node.patch
memcg-remove-the-soft-limit-reclaim-tracepoints.patch
memcg-remove-the-soft-limit-rbtree.patch
memcg-remove-lru_gen_soft_reclaim.patch
memcg-remove-the-per-node-soft-limit-tree-fields.patch
memcg-remove-mem_cgroup-soft_limit.patch
memcg-simplify-v1-event-ratelimiting.patch

