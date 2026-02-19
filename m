Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7334C32C301
	for <mm-commits@vger.kernel.org>; Thu, 19 Feb 2026 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771540678; cv=none; b=VCQKEw6tP5LA5WKCDF5OnsrYvzMY7VxjSljZKSLwEP40QLr/LErU7dpQeRsvVrl9Qvkccf0ZUtJQZ1onuU/mJFkVOcP9uHUwXuIe29xVVEp5HRPl26P+8q/D2O3Q8fTWJHEX31+1OUpO9hQyRBsGOwf0buOyN++ItpGyPbWOufA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771540678; c=relaxed/simple;
	bh=wqZx90blo9CfCRxNOs70HMF8acgfm8anj8r/7Gi7rrE=;
	h=Date:To:From:Subject:Message-Id; b=fnJDzHzHdvQV5RgEbLRfpS6fKwNoqBmOJjLelhlxslBdwsQ5bEIs9oqovztmTwfBxq+aytmJ5yLoeYNiJt6qud/ki+pUTQyTQ17m5xHxwCt6UFgzkwPXDVUwbtUp3NDLa1isSpmU3yQKUQE+2hU8uvrm6gkiqEKOFig1vbWrafM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A1eaCBan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A1eaCBan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06157C4CEF7;
	Thu, 19 Feb 2026 22:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771540678;
	bh=wqZx90blo9CfCRxNOs70HMF8acgfm8anj8r/7Gi7rrE=;
	h=Date:To:From:Subject:From;
	b=A1eaCBana0YGpOd3Mm4Hq1hrXqu83LkfgU87rj2M0hAc2tLwGyfUyIjJFWIuU1hpJ
	 OmhqnXLz4mFudvR/0FoXxxrMBR7MjMosUssM8ng0YVBgrR1FehE6qE+y+/mfIbj8Cb
	 Cpc/e3Sopl/yPDSYFUmTESmPUZ7fOEeyqWZfMjGE=
Date: Thu, 19 Feb 2026 14:37:57 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-soft-dirty-kselftest-supported-check.patch added to mm-new branch
Message-Id: <20260219223758.06157C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix soft-dirty kselftest supported check
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Audra Mitchell <audra@redhat.com>
Subject: selftests/mm: fix soft-dirty kselftest supported check
Date: Wed, 18 Feb 2026 13:42:10 -0500

On architectures with separate user address space, such as s390 or those
without an MMU, the call to __access_ok will return true.  The soft-dirty
test attempts to check if the PAGEMAP_SCAN feature is supported by
providing an invalid address and expecting __access_ok to return false,
thus throwing an EFAULT error on return.  Because of this assumption, this
check will always fail for the architectures aforementioned.  Update the
supported check to handle the return being zero for these types of cases.

Link: https://lkml.kernel.org/r/20260218184210.206466-1-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-soft-dirty-kselftest-supported-check
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -77,10 +77,8 @@ static bool pagemap_scan_supported(int f
 
 	/* Provide an invalid address in order to trigger EFAULT. */
 	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
-	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
 
-	supported = errno == EFAULT;
+	supported = (ret == 0) || (errno == EFAULT);
 
 	return supported;
 }
_

Patches currently in -mm which might be from audra@redhat.com are

selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

