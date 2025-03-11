Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F652627EC
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714614; cv=none; b=CQMECUK9iJ1AJAjacFuPLbQTF7oO24XxQP/E30NUGubtz0JcSv2WF++Pq/HUH/afRkl6/VBoDfdyN+bd3C4CB9pSLrSt7+WRZh+Iy2y3G0fX6CEJU0p3QuXcy9Y35SVpC8BXn9N+Gs0Gs0QSnAjmSK6CCMt7tt99FcOsqgSa0/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714614; c=relaxed/simple;
	bh=3HJsAd8RcHLz/RmARysx2AoNtvvJYTRgdnDK3hVQ97w=;
	h=Date:To:From:Subject:Message-Id; b=PfKcFlEhiHzvWVoT3eM4aV2JATo5SznvkOxPknnLCim8XHeUjoObtEOHJ1P0vD2yQ8EEeBij3Aon+amKdOfLklBgn2m7L6P/bqDL9qe/f2SCNLBV0PohhGn9geXQYfJ1akq/NoeiSZSLSy9So4o39PpSZRV3ay+1pvyEA5yyVeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=teoJExAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="teoJExAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934EEC4CEE9;
	Tue, 11 Mar 2025 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714614;
	bh=3HJsAd8RcHLz/RmARysx2AoNtvvJYTRgdnDK3hVQ97w=;
	h=Date:To:From:Subject:From;
	b=teoJExAmWXrP20jWzXrE/RbTOGtRZivCLLuQvPINla2rcM91Kj8EHkmu77FTuiXSs
	 xQqfGDZggVVO9AnVRNarfLCuTAfmj3gU6DlzKoF6ysQYrHuBiJzO/VS2ao6vAq9ecd
	 XrBRcHRQkWtJXMEg9Im7XczIMeHwhta+p9/vmHAc=
Date: Tue, 11 Mar 2025 10:36:54 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch added to mm-unstable branch
Message-Id: <20250311173654.934EEC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: don't fail uffd-stress if too many CPUs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: don't fail uffd-stress if too many CPUs
Date: Tue, 11 Mar 2025 13:18:17 +0000

This calculation divides a fixed parameter by an environment-dependent
parameter i.e.  the number of CPUs.

The simple way to avoid machine-specific failures here is to just put a
cap on the max value of the latter.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-6-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-dont-fail-uffd-stress-if-too-many-cpus
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -435,6 +435,7 @@ static void sigalrm(int sig)
 
 int main(int argc, char **argv)
 {
+	unsigned long nr_cpus;
 	size_t bytes;
 
 	if (argc < 4)
@@ -453,7 +454,15 @@ int main(int argc, char **argv)
 		return KSFT_SKIP;
 	}
 
-	nr_parallel = sysconf(_SC_NPROCESSORS_ONLN);
+	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (nr_cpus > 32) {
+		/* Don't let calculation below go to zero. */
+		ksft_print_msg("_SC_NPROCESSORS_ONLN (%lu) too large, capping nr_threads to 32\n",
+			       nr_cpus);
+		nr_parallel = 32;
+	} else {
+		nr_parallel = nr_cpus;
+	}
 
 	nr_pages_per_cpu = bytes / page_size / nr_parallel;
 	if (!nr_pages_per_cpu) {
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

