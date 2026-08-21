Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4CC2DEA61
	for <mm-commits@vger.kernel.org>; Fri, 21 Aug 2026 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787342191; cv=none; b=Mo5bU3RnRgreeNkI6GdROPwB+CuvGV30NP99SlMD2W2U/TbV3qT8/F7WAjMxJWpngXnPYVTMrux8mlhx7cmsD6ve+xKf56m+Bjmi1YopO+xVtBBH+x+P2j5GwvnP0wIVjI+IEYwM4OS20XMLKbgtPi815A0S6J4f3jBJawdoG20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787342191; c=relaxed/simple;
	bh=FAlMNsEvJaOQcu3nlat8DMk5DKtaISnf6DsC+aNPUfs=;
	h=Date:To:From:Subject:Message-Id; b=gCrS5qEdybnBEkqRyHAvkyP1oPSaXc5+KLzCnEr8q3X9w5nJm9SCq2p7096Yd4Wi0t/PgljkNHSaa4BaGVsw8P/77dSjSip4wF3l2JgkVaXptz1uuKoJLnYCJp/Vc/APEpR5T1OEd2g/CUXH6U5M/yADqZqTMOShT/ctTcCRxh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r5XFmAOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5XFmAOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D5C1F00A3F;
	Fri, 21 Aug 2026 19:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787342189;
	bh=ppOhrGEIOl9O3OFuoZGpMHnFv8llx2r+0FCMAkOfHR8=;
	h=Date:To:From:Subject;
	b=r5XFmAOQgI34FUvDIUWlbh+72CNBGb+Qza+KvvGKPw92AAa6AiTiAV/uDHmGvN9nE
	 DSG+dc7zNkJh0ZwDQ7OmaJSCUjQuwcMeYM4FGaO7/JawkmnJrHUjZix5UVA65N7v3X
	 Fd0aeYALzNmK+lIHHYfOsC0FMyf2kGzLkOEMry2s=
Date: Fri, 21 Aug 2026 12:56:28 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch removed from -mm tree
Message-Id: <20260821195629.45D5C1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/cgroup: fix cg_run_in_subcgroups ignoring arg parameter
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-cg_run_in_subcgroups-ignoring-arg-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch

