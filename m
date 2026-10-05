Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F99175A6C
	for <mm-commits@vger.kernel.org>; Mon,  5 Oct 2026 00:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791160315; cv=none; b=MoN9SR+hGe6gl4GpZ7CnVCh5Nun6KjpceWqoYl7/9Awh3bP7pHZHGDnfPkBcO75bhEUK9+ps2fkQWxDhcA7S1hg303xNI085tiYHRVhf4TSChC7a6f+3opfVU8yutDZJ0lGPwzC1BOtmxTvSN5+ptRdatfqYtk8lStnrwWXyQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791160315; c=relaxed/simple;
	bh=wBV1FlhGD8Ee/fjloZbYCH9DOUaunIsrx2/XuDys3tI=;
	h=Date:To:From:Subject:Message-Id; b=FSXVdxNW5fBcM7bqBp8he73qZAYZpFqHWpe46NvAVGtJJ+U2Iju/ErMyCJGzBw0jzJ1r2vklrc+3XgcFRNxiqc3Gm8RsNIt+u/MRHhXPS3+F59P+7zBFWVhq40z/LXV1ERJwRtP31YX8hfr2cjoDVHEGoyXgh4wmT+PXhH6aMEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gb/+z1Uz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gb/+z1Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CAB1F000FF;
	Mon,  5 Oct 2026 00:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791160314;
	bh=w5l4RKT3dNYVNKtsee/xothiB5g1G91KWGrA0rWaXyo=;
	h=Date:To:From:Subject;
	b=gb/+z1UzOvmpcXi0bcm+nyyiy0J1DIJvWJOMlxGZjJvL+/M0zG0e+D9uADlURJOsI
	 mBT7PcBA8lJxvcAK5vPpw5+nmEvb3JtWXe/sgObgf3bv5qCL12pulfx5SoGaV6p42Y
	 iuHjMSdhq4R1mgRip0FBRSYfSMzETAT0sM3LX1MQ=
Date: Sun, 04 Oct 2026 17:31:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,guillaume@morinfr.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch added to mm-new branch
Message-Id: <20261005003153.D6CAB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch

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
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
Date: Mon,  5 Oct 2026 01:00:18 +0200

The plan was raised from 1 to 3, but the HugeTLB setup check that may call
ksft_exit_skip() still runs after ksft_set_plan(), so a setup failure
reports one result against a plan of 3.  Move ksft_set_plan() below the
setup check.

Also, when the underflow check fails, or munmap() fails, test_underflow()
jumps to err_cleanup and exits without reporting the remaining results. 
Report the munmap() failure as a test result and skip the final
HugePages_Rsvd check in err_cleanup, so the output always contains the
planned 3 results.

Link: https://lore.kernel.org/20261004230018.190880-1-jaeyeon.lee.dev@gmail.com
Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Guillaume Morin <guillaume@morinfr.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
---

 tools/testing/selftests/mm/hugetlb_madv_vs_map.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -169,6 +169,7 @@ void test_underflow(void)
 	/* First unmap, this will close the vma */
 	if (munmap(huge_ptr, mmap_size) != 0) {
 		ksft_perror("munmap failed");
+		ksft_test_result_fail("munmap failed\n");
 		goto err_cleanup;
 	}
 
@@ -203,18 +204,20 @@ err_cleanup:
 	if (waitpid(pid, NULL, 0) <= 0)
 		ksft_exit_fail_perror("waitpid failed");
 
+	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
 	ksft_exit_fail();
 }
 
 int main(void)
 {
 	ksft_print_header();
-	ksft_set_plan(3);
 
 	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       hugetlb_free_default_pages());
 
+	ksft_set_plan(3);
+
 	test_madv_vs_map();
 	test_underflow();
 
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch
selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch
selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch

