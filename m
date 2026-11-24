Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795497001;
	b=E9EfMemiXTb4RlGTAlu0AFU8lygJn/+uC+w8pdIvZ0Vsw2J82k7maIUt2KKUl5ZQS7h1
	 Gt62iPILQZb2H09v88mDa2VaaJDdAGcCExGUYqRQkL0BUES6VQORHPLB1Vpr6+t2KNlPi
	 NczbzHHQfBvvG8bw4rA6ngplHQHDYa5TmtxPBT8BVE083xrKzBU5/ppiXuY18FsZxaARX
	 p6B61lLngcFNPAJW6bVIeAeqGzrIJPe1r5SoNtmpF9LiQWyfLSQqHQ5BKsVy+vGZ/ZXJ0
	 3n5N2G+DWFaf8ks21TAgnvDoc0BWqyXjS2yJA0OgXfpQNq9uYY6itbHj3k7HJMNqOIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795497001;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=PIa4e3ro05GVm5OGheLvgJaTBkxCWGAHAPRrk92kfxk=;
	b=bKKxN4fjIsUGtcL+iha1bXwj8aCPQz/3mpzc5+cmnl7FnCxnTVVioMtLLutxXpX8UtGS
	 AgjcyeIYOy87kEH3fc49XUEuqOwAnfXsIn3rM8qjWhGYvhoQzt3uCo9q/2GaL/p4RSrZ2
	 RqK0iYlbtg8chhyNHFLRFsw1fSeZuNI7FF2bDRGv7O1WfVbHVq5P9/xiwrF59OCFiLZ+R
	 iDZMCvmm/DT+h/MWGZJSo9AAi5b2FxbYeQUzJ44fZ3n+YQ93q4z/wU/LlzcD9YaW1v58Q
	 7gNqvkULTDZ4Br+4uRpNC0RD943BTZwVDPKQsRzEtM3AkeT/bWzVTZqtUqKajN35iBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BX1FgUiY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AF0606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 05:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BX1FgUiY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102F61F000D0;
	Tue, 24 Nov 2026 05:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795497000;
	bh=PIa4e3ro05GVm5OGheLvgJaTBkxCWGAHAPRrk92kfxk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=BX1FgUiY49RuiYJEyHschskHQhespJ55Sgizmucm7ZZGumj71/o7aaDWwoGChwqGp
	 ZB9E5CkJl+Vj6etC89smt3UP15muwWl0W4SdM0XaEX/qCz1PonbrETJ6U7hlQeZ4Hm
	 CfxUUU2dyVvK8MkvymhwmH+cZfaos2vFtd3F4Ipc=
Date: Mon, 23 Nov 2026 21:09:59 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,roman.gushchin@linux.dev,
	muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,
	shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124020800.2313930-1-shakeel.butt@linux.dev>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
Subject: + memcg-warn-when-memory-cgroup-ids-run-out.patch added to mm-new branch
Message-Id: <20261124051000.102F61F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: memcg: warn when memory cgroup IDs run out
has been added to the -mm mm-new branch.  Its filename is
     memcg-warn-when-memory-cgroup-ids-run-out.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-warn-when-memory-cgroup-ids-run-out.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: memcg: warn when memory cgroup IDs run out
Date: Mon, 23 Nov 2026 18:08:00 -0800

Every memory cgroup gets a 16-bit private ID, so a host can have at most
65,535 of them at a time, counting dead ones.  A dead memcg keeps its ID
as long as any swap slot still records it.  On Meta hosts that create many
short-lived cgroups, dead cgroups held this way filled the whole ID space.
After that, every mkdir of a cgroup with the memory controller failed
with -EBUSY: systemd could not start units, and container setup failed.

This was hard to see:

- Nothing is logged when the ID allocation fails. The only sign is
  -EBUSY from mkdir.
- Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
  objcg"), a dead memcg is freed even while swap still holds its ID. So
  nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.

Print a rate limited warning when the ID allocation fails because all IDs
are in use.

Link: https://patch.msgid.link/20261124020800.2313930-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-warn-when-memory-cgroup-ids-run-out
+++ a/mm/memcontrol.c
@@ -4307,8 +4307,12 @@ static struct mem_cgroup *mem_cgroup_all
 
 	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
-	if (error)
+	if (error) {
+		if (error == -EBUSY)
+			pr_warn_ratelimited("memcg: all %lu memory cgroup IDs are in use, cannot create a new memory cgroup\n",
+					    MEM_CGROUP_ID_MAX);
 		goto fail;
+	}
 	error = -ENOMEM;
 
 	memcg->vmstats = kzalloc_obj(struct memcg_vmstats, GFP_KERNEL_ACCOUNT);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-free-the-private-id-of-a-memcg-that-never-comes-online.patch
memcg-move-memoryhigh-enforcement-out-of-try_charge_memcg.patch
memcg-force-charges-from-reclaim-before-trying-the-limits.patch
memcg-use-high_work-for-kernel-threads.patch
memcg-use-high_work-for-remote-charges.patch
memcg-simplify-high-limit-handling-after-a-charge.patch
memcg-warn-when-memory-cgroup-ids-run-out.patch

