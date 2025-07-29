Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A7B253950
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821855; cv=none; b=a1puQl4sStxfZOnl77aDFVXXZLfI7X3e71m4wcns/ek5AGxFaNqLK0JtQDiWQk4tlKmLEDnT6P8N03hRvUBxm6lHHaNrNVFRGGwoTJ/jflgIJpruDB2xFTIsHEk9uLS2NTV8+xAZMRtZIWrL1umM73/NeSE3E7CKW7tM3wr7TGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821855; c=relaxed/simple;
	bh=gu9jGNqpdr8HEXHyy8KdNnBcV41W8OoN0SFE+jaV2/s=;
	h=Date:To:From:Subject:Message-Id; b=VVBJgtQp5xuuTBHQh8dbvXGdQf0wIBsS/ZtrEIxUUodSLz1XKfFJln5g6zMDzjmdCO01Tz9ceLvErtU7uc5hAWnq+pLbC/sfcx/4e33KWW31CPYw+r+gIMuK86zEYNHv8P+3KIq33GkUWLuwLGNm+au1xEjuNCUpjBaJkhE5WXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdgUdq8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdgUdq8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AB4C4CEEF;
	Tue, 29 Jul 2025 20:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821855;
	bh=gu9jGNqpdr8HEXHyy8KdNnBcV41W8OoN0SFE+jaV2/s=;
	h=Date:To:From:Subject:From;
	b=MdgUdq8RdNsui90DDLCiAFccfUQNDMGRjfTLzsJcnHQ542GoEDi2XGbzEsDsnDdd0
	 d3+0kWO+MGbkjYT1HS9Q4stO961ja/mjL0OfzkltLRQNFQH+niUBzLR/TWbWpGwYJp
	 yrPKz/ELgKJLI4XM8ep437tyr+SxtmXI1y8SAv0s=
Date: Tue, 29 Jul 2025 13:44:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable.patch added to mm-new branch
Message-Id: <20250729204415.54AB4C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip hugepage-mremap test if userfaultfd unavailable
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: selftests/mm: skip hugepage-mremap test if userfaultfd unavailable
Date: Tue, 29 Jul 2025 11:04:03 +0530

Gracefully skip test if userfaultfd is not supported (ENOSYS) or not
permitted (EPERM), instead of failing.  This avoids misleading failures
with clear skip messages.

--------------
Before Patch
--------------
~ running ./hugepage-mremap
...
~ Bail out! userfaultfd: Function not implemented
~ Planned tests != run tests (1 != 0)
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
~ [FAIL]
not ok 4 hugepage-mremap # exit=1

--------------
After Patch
--------------
~ running ./hugepage-mremap
...
~ ok 2 # SKIP userfaultfd is not supported/not enabled.
~ 1 skipped test(s) detected.
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
~ [SKIP]
ok 4 hugepage-mremap # SKIP

Link: https://lkml.kernel.org/r/20250729053403.1071807-8-aboorvad@linux.ibm.com
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage-mremap.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/hugepage-mremap.c~selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable
+++ a/tools/testing/selftests/mm/hugepage-mremap.c
@@ -65,10 +65,20 @@ static void register_region_with_uffd(ch
 	struct uffdio_api uffdio_api;
 
 	/* Create and enable userfaultfd object. */
-
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	if (uffd == -1)
-		ksft_exit_fail_msg("userfaultfd: %s\n", strerror(errno));
+	if (uffd == -1) {
+		switch (errno) {
+		case EPERM:
+			ksft_exit_skip("Insufficient permissions, try running as root.\n");
+			break;
+		case ENOSYS:
+			ksft_exit_skip("userfaultfd is not supported/not enabled.\n");
+			break;
+		default:
+			ksft_exit_fail_msg("userfaultfd failed with %s\n", strerror(errno));
+			break;
+		}
+	}
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = 0;
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are

selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests.patch
selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly.patch
selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable.patch

