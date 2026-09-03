Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3130EEEB3
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788459417; cv=none; b=Qw4ACbaLGxNrm0gzcsSdlSf1/L49Ack+ZJSIgFSfvmTSIvAg/uKaVH1u0e39ifqhI+Mx7vNLODGRRW6fgi+hBM7n8cAjmcwu80/v56CaO7x15bAIM8JujzlTF6tKkDpBEfkVTehoM2h+Pns9vqxrZdRoqgquJZDe/Xdos1mrCYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788459417; c=relaxed/simple;
	bh=0eqpVP7bj3ns77MqPvJI5FvuBu4zKiO6UricJ0XilGQ=;
	h=Date:To:From:Subject:Message-Id; b=M+Hafc2ViVD9DchXWq63e6wS8qNRavpiKgi9wCP80VuUlXb839XDsmf66RYPxNtbynSQ4Pa6zCq6UGxRalsQPcqbw91dyBSqjsFVrsFUem95oXjQ/S/bG9Z+rs/BNwUvpZ6qiQVrhlIQaQSCO1RwtogcAMzKrM9vWytizZyHDQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pj4bfocu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pj4bfocu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C617C1F000E9;
	Thu,  3 Sep 2026 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788459415;
	bh=RW45Oees/XXSVd6/tDTG+Ak/rt06tApwCe1WMw5LP1g=;
	h=Date:To:From:Subject;
	b=Pj4bfocuKWTKNqwSIW3Wl8tl1V/6NaG1QcnJrwomF2Q0e+MknWTc34Y9KWTpgZ3O6
	 1A36tAsPTxlTCNW37frM/c9fQ3OxAacWk3grZrIgqnuZsYFAENJ8YaLWTgnUcA+rF6
	 FbAUcaCiz32JGELucGAFOqQ76clAL/X+YDBbGeT0=
Date: Thu, 03 Sep 2026 11:16:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch added to mm-new branch
Message-Id: <20260903181655.C617C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove unreachable returns after ksft exit helpers
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: remove unreachable returns after ksft exit helpers
Date: Thu, 3 Sep 2026 21:52:51 +0800

The ksft_exit*() helpers such as ksft_exit_fail_msg() are declared
__noreturn, and the ksft_exit() and ksft_finished() macros expand to calls
of them, always terminating the process via exit().  Any return statements
following such calls are unreachable, both at the end of main() and on
error paths of helper functions.

Remove all of them.  No functional change.

Assisted-by: GLM-5.3 OpenCode
Link: https://lore.kernel.org/20260903135251.39593-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/folio_split_race_test.c |    2 --
 tools/testing/selftests/mm/mlock-random-test.c     |    1 -
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    1 -
 tools/testing/selftests/mm/split_huge_page_test.c  |    4 ----
 4 files changed, 8 deletions(-)

--- a/tools/testing/selftests/mm/folio_split_race_test.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -269,6 +269,4 @@ int main(void)
 				      NUM_ITERATIONS);
 
 	ksft_exit(iter == NUM_ITERATIONS);
-
-	return 0;
 }
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -71,7 +71,6 @@ int get_proc_locked_vm_size(void)
 
 	fclose(f);
 	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status: %s\n", strerror(errno));
-	return -1;
 }
 
 /*
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -556,5 +556,4 @@ int main(int argc, char *argv[])
 	}
 
 	ksft_finished();
-	return 0;
 }
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -101,7 +101,6 @@ static bool is_backed_by_folio(char *vad
 	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
-	return false;
 }
 
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
@@ -548,7 +547,6 @@ err_out_close:
 err_out_unlink:
 	unlink(testfile);
 	ksft_exit_fail_msg("Failed to create large pagecache folios\n");
-	return -1;
 }
 
 static void split_thp_in_pagecache_to_order_at(size_t fd_size,
@@ -711,6 +709,4 @@ int main(int argc, char **argv)
 	free(expected_orders);
 
 	ksft_finished();
-
-	return 0;
 }
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch
mm-damon-core-remove-declaration-of-__damon_commit_ctx.patch
selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch

