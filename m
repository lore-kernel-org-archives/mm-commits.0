Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4677255E20
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714605; cv=none; b=aTGLjoNi5Rt2QHRSs2PzDMlTcZC9t5y2fd0KJp4E7haevwAI1H7jByshBd8QWTViSNHEZ8OdZmPKAPI2oMYBHe/8si0fqsf9XEbZSPlt4COdwqAU8fNhX9TUuswVPG87xoOXRNRCH9Jo125OEY9Zhw3nmLXIgHxYgq6kAW6VJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714605; c=relaxed/simple;
	bh=D62SdZpgAS0peyeWXgmT/hk8RxMF7S2QVO4+n+v9zJA=;
	h=Date:To:From:Subject:Message-Id; b=NS9UQai2suAKrJJnjyZVuZbTeg5irF121YcDHdQKiSh808Or+6g6LTNoy0Qxl8cZjfW8/TrUhAYYqW9FOk7kLAIEffjnDnGM8AmmHD8BWjtwP8ZpaLP0Nm9FTNsykacwmLsPeQTtwzrDwn88UHTg1hKS0VfM4G7cAO8T9VJ77Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ke+DO8TQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ke+DO8TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B529C4CEE9;
	Tue, 11 Mar 2025 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714605;
	bh=D62SdZpgAS0peyeWXgmT/hk8RxMF7S2QVO4+n+v9zJA=;
	h=Date:To:From:Subject:From;
	b=ke+DO8TQ8NKr4ru+MM5pZ5CnOIBXMxnAFRGDywCVoAyWi3GZ17wa5dHqGkgAUrkE3
	 nnEz4Smj8wkbGp3YJg9rUEYXcHPTnkSrUC1yETcyt1WPoN83MfEc4KjF7oJ/uBZqbh
	 2ZqGc9k6LfNzZQ3PFpl7TnIY+bRgjITXWJ9W6QcA=
Date: Tue, 11 Mar 2025 10:36:44 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch added to mm-unstable branch
Message-Id: <20250311173645.4B529C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip uffd-stress if userfaultfd not available
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch

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
Subject: selftests/mm: skip uffd-stress if userfaultfd not available
Date: Tue, 11 Mar 2025 13:18:13 +0000

It's pretty obvious that the test wouldn't work if you don't have the
feature enabled.  But, it's still useful to SKIP instead of failing so the
reader can immediately tell that this is the reason why.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-2-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-stress-if-userfaultfd-not-available
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -412,8 +412,8 @@ static void parse_test_type_arg(const ch
 	 * feature.
 	 */
 
-	if (uffd_get_features(&features))
-		err("failed to get available features");
+	if (uffd_get_features(&features) && errno == ENOENT)
+		ksft_exit_skip("failed to get available features (%d)\n", errno);
 
 	test_uffdio_wp = test_uffdio_wp &&
 		(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP);
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

