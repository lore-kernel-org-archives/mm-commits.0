Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C4D2C11CA
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 02:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786500413; cv=none; b=FmzBd8/xIHAnc+ewdINFG22H8Cd1/IvcsWuTPP/MgmrNGPYqg5b9yYoFJSYqHuMoYeESGRPzzAs5oROWaEL89xkynBjLMcjE/zWkQ6igQlbEpf4nRtFOmpjSbRM3VlcOdGJfT9k4azET5ZWE9HK0fmuSwuNKxdNrgauoCz0deV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786500413; c=relaxed/simple;
	bh=9Xkk19PDKflSNpFLQO2k1gbCdYnJxrGSVt+fM7U2zO0=;
	h=Date:To:From:Subject:Message-Id; b=c2v7obG8vrfQqgKxGcCRLlFB7ZnGNonHNdhgl6NQfPSealrdGm+NoNeIKjjocCBheVwTzHNc8gXWoMbUEZYPsyU09A4W7Q4wrs8tFAlyF0hweDZYE5qxG6W0JlLHj8Uy7VkIL+NTlV0pkpSNgspSU3Fds822p1SBs+W0pP6Km9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RTNgM+73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RTNgM+73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABA31F000E9;
	Wed, 12 Aug 2026 02:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786500411;
	bh=VU/3K4cPe6tFyhllyrt+KgNm7aioQAJkLmmyJY2kVa4=;
	h=Date:To:From:Subject;
	b=RTNgM+73FXnIjlGSx+t85udtMCiyemW4WqbT45WaRiVQInkWGfUpc57IOcWg5Y+Qu
	 vWp8D5NYNh7LOd1yWdTgkcuVTKRRBX2jaFhFh8+BCFqr/JQUmhSOOxgtKbDQJ9z2+T
	 lJyJ2SBOzU3793dM7tO5yPP9shrOGowpnrL2S0dM=
Date: Tue, 11 Aug 2026 19:06:51 -0700
To: mm-commits@vger.kernel.org,wfelipe@google.com,tj@kernel.org,shuah@kernel.org,nphamcs@gmail.com,mkoutny@suse.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,anshuman.khandual@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch added to mm-new branch
Message-Id: <20260812020651.BABA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
Date: Tue Aug 11 07:04:40 PM PDT 2026

clarify debugfs-unavailable error message

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_zswap.c~selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix
+++ a/tools/testing/selftests/cgroup/test_zswap.c
@@ -578,7 +578,7 @@ static int test_no_kmem_bypass(const cha
 		return KSFT_SKIP;
 	}
 	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
-		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");
 		return KSFT_SKIP;
 	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

