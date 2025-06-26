Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E80D2248B0
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750978143; cv=none; b=tRlXmCc7gNdbLhuyMcjA/CTE6nOKVwioUptEdnZ/Tcelt7JJAodGDF0HXsNyfyuJMD8CBW40/W9JnX5eQaKxs4jBJYJmepD+jgxP/4fz4OztmO2dOY0ws6vrV8dfRlduCOhl4ya4T5v3erMU67T4qfrrVMwidqAdV60qdTinyu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750978143; c=relaxed/simple;
	bh=FcXflelXpI/LA1pVhWSCYn4600DVGgsTzrtf1Yi8VIc=;
	h=Date:To:From:Subject:Message-Id; b=KfVhvQ09x/GZzN5MSPtMEucT3SPjKNFudhIHKKuX5cAb2t/fGWbGGsbeMiGE9tEnizoxFaG4jC/5qIOO1hT2oXltGh1dC6TmHFgQqiwEysn6U/5+Tz60yrQb5PrhZBaWJEmE6RFQeGPPO1+rd2j40ox1T6UNVlLwaZb+I1RkbUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PA9B+pdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PA9B+pdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC571C4CEEF;
	Thu, 26 Jun 2025 22:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750978142;
	bh=FcXflelXpI/LA1pVhWSCYn4600DVGgsTzrtf1Yi8VIc=;
	h=Date:To:From:Subject:From;
	b=PA9B+pdWqWDNbWrzipma5PY7cP8+uWL7GEVaC42zKG7/I72lBIRHrhos+TgQkAEdb
	 Xy3UIMf6rQpNA1RNwqEZKxpAhzmWekYdb9Getbb1IO3eJ41hkwugn0Bw6ohQCzp61d
	 lcYN47Gj7VUSO2rx6ylooxA3fr7jhA9yGKcNr4Dc=
Date: Thu, 26 Jun 2025 15:49:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,moonhee.lee.ca@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-duplicate-gitignore-entries.patch added to mm-unstable branch
Message-Id: <20250626224902.BC571C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove duplicate .gitignore entries
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-duplicate-gitignore-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-duplicate-gitignore-entries.patch

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
From: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Subject: selftests/mm: remove duplicate .gitignore entries
Date: Wed, 25 Jun 2025 19:07:58 -0700

Remove redundant entries in .gitignore confirmed by:

$ sort tools/testing/selftests/mm/.gitignore | uniq -d
hugetlb_dio
pkey_sighandler_tests_32
pkey_sighandler_tests_64

These entries were originally added by [1], and later duplicated by [2].

[1] https://lore.kernel.org/all/20240924185911.117937-1-lorenzo.stoakes@oracle.com/
[2] https://lore.kernel.org/all/20241125064036.413536-1-lizhijian@fujitsu.com/

Link: https://lkml.kernel.org/r/20250626020758.163243-1-moonhee.lee.ca@gmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-remove-duplicate-gitignore-entries
+++ a/tools/testing/selftests/mm/.gitignore
@@ -38,9 +38,6 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 memfd_secret
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
 soft-dirty
 split_huge_page_test
 ksm_tests
_

Patches currently in -mm which might be from moonhee.lee.ca@gmail.com are

selftests-mm-remove-duplicate-gitignore-entries.patch
selftests-ptrace-add-set_syscall_info-to-gitignore.patch

