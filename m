Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBDE1F5842
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789690021; cv=none; b=QJan5QFZ8A4tgnUcp41+NlaUWJWERKMWUO+U4EfE4qbd/ssqtjAJ/fknWLzkQfrEskYyYhd07eZTkfSf5efdIwgO7fR5lqjf6GbjeDGdA84uJVhkHOqWxa/el+Ki4IBv73y7k8xp+Nthii9y5GAY/WwchN6JQSP4srPkaZ+uIvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789690021; c=relaxed/simple;
	bh=OdZdKGrY905/+qnXILIV6A8DXxSZMLXjUC3TMJwv/xY=;
	h=Date:To:From:Subject:Message-Id; b=MFAzFY7n4ApTTLjQcMKj5kgmwjAD7K/30mjk9w8EKrDqbMeS77PJd4wOavrQwXn25xgLjkeSXq5/tYL0bQynOp9nly7BFOj03gOs+wFfwGjIJVQRJZ6FZc4UkJOPQ8fOb1uXU27/srrW+GnhzkDjar0SaIVh4w0/GM1MDBJwauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kwxze4Wf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kwxze4Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0231E1F00893;
	Fri, 18 Sep 2026 00:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789690020;
	bh=EuXOnYWgPAxc0QnqJSiD80Wnc8kLI1yR2piG6CU2U/Y=;
	h=Date:To:From:Subject;
	b=kwxze4Wfgp8evLjJoxRjzsmgcGMjYHpJfxNdmAg6zkzOimoi3NiV8G3UOVV5i8dzI
	 JAxaOpl24V026d5Ln3QDpL4adQW0hFpZ/YTH5HcFWjsZzZlwxn6tX/2XyMWtROJhKh
	 UVdK6M65ATpNwXp9de79QLiBuM24Ihms1LuQLIvo=
Date: Thu, 17 Sep 2026 17:06:59 -0700
To: mm-commits@vger.kernel.org,wyihan@google.com,ackerleytng@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-add-shmem-into-memory-failure-test-fix.patch added to mm-new branch
Message-Id: <20260918000700.0231E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-selftests-add-shmem-into-memory-failure-test-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-add-shmem-into-memory-failure-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-add-shmem-into-memory-failure-test-fix.patch

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
Subject: mm-selftests-add-shmem-into-memory-failure-test-fix
Date: Thu Sep 17 05:06:00 PM PDT 2026

fix commant typo, per Lisa

Cc: Lisa Wang <wyihan@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/memory-failure.c~mm-selftests-add-shmem-into-memory-failure-test-fix
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -165,7 +165,7 @@ static void check(struct __test_metadata
 	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
-		/* FALLTHORUGH */
+		/* FALLTHROUGH */
 	case MADV_HARD_CLEAN_SHMEM:
 	case MADV_SOFT_CLEAN_SHMEM:
 		/* It is not expected to receive a SIGBUS signal. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

