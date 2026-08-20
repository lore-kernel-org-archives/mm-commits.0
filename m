Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D665D318ED6
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 22:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787266709; cv=none; b=hVj37pLFNOY8d+vKt+7mFvG0KHTvZSeL0aLyGcFGRroY/z8TD05pvFOf5CvGCWR0sU7BTGmbq4EuUdcRu9+mzNMz5AbwgeNb/6IMhwrWGUq85l9s86hpcGRRJJG7DOxs7aO/2c0YRi8edhDP4Eh80gh7v3/KS56oPH3DxquiVAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787266709; c=relaxed/simple;
	bh=WWGoSA60dOyYACZPzZ5TB4CLEJ9HnBEGX+jj3h1FMHY=;
	h=Date:To:From:Subject:Message-Id; b=Ru6yTcD5tQWv8Wf85Zn1KywZV73kemV9Ccnh6UhVGVBLe4OE0xBZYJh4/HtMwjMTGl6wG8yZIvgzpM6JuwuRdMEDR3ox7gCpbrqFaUXk08UK9cQNsaceQRVnwJlHgyFcQ4dVzD0pcHJr0lrsMlMWYXLZAL0VgzwsyEmhA4sJe1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMofY15q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMofY15q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C491F000E9;
	Thu, 20 Aug 2026 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787266707;
	bh=OUf9tRZKRVs+8SMEu56S1vxBt4SMdGcXDwOWwoUhaXE=;
	h=Date:To:From:Subject;
	b=IMofY15qFqU1RyGMCZDnPz8HA1J/MsjnxaLvwoeDDgnG8jzgkuuindv0yHqbe6JP5
	 miTWFLlE/4uerQS5HeDaonnK4LEQBfhkcBkR+95D/NnA9tcMxEeDCvfzuaDOc0GBAn
	 /e1nA1LiFTcDWW4e5g75yfZv93nvHZpxKFbRk4OI=
Date: Thu, 20 Aug 2026 15:58:27 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch added to mm-new branch
Message-Id: <20260820225827.84C491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/cgroup: fix cg_run_in_subcgroups ignoring arg parameter
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/cgroup: fix cg_run_in_subcgroups ignoring arg parameter
Date: Thu, 20 Aug 2026 15:09:44 +0800

cg_run_in_subcgroups() discards its arg and always passes NULL to
cg_run(), turning the (void *)100 from test_kmem_dead_cgroups() into NULL
so no allocation occurs.

This makes test_kmem_dead_cgroups() falsely pass without exercising the
"dying cgroup with charged slab" scenario it intends to test.

Pass the arg through to cg_run() to fix this.

Link: https://lore.kernel.org/20260820070944.31451-1-hongfu.li@linux.dev
Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting tests")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_kmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_kmem.c~selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter
+++ a/tools/testing/selftests/cgroup/test_kmem.c
@@ -145,7 +145,7 @@ static int cg_run_in_subcgroups(const ch
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

ksm-update-comments-and-docs-to-reference-folio-mapping.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-mm-fix-read_file-return-value-check.patch
mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
mm-cma-remove-stray-newline-from-auto-generated-cma-area-name.patch
selftests-mm-drop-redundant-open-in-mprotect_tests.patch
selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch

