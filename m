Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4401BC065
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757729; cv=none; b=qvQFwb4XtITsYzyp+B2RDW9vznbvvMdKL5M2riFcohwsIwrlqtWVbIiOz+zOb9d3NTrtVF9CFm42iSrbsjjPEvufiQhwUeAh9+mJRQnFKt/jvwcncjpMgFLKA51drwUNwOWwdTH0tuGE1FE2pe97D8eNGoguBfUdkDMq0BBVeDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757729; c=relaxed/simple;
	bh=uTYSV618GqZg0u0n3Zo3loRecQihx8C23ltJsLbZWLE=;
	h=Date:To:From:Subject:Message-Id; b=dpRq2mCzwd3OIaM+NP2VsR9mKEK2YAjPdgvjAHvI4AuVEzKo2fz/i0hom655oL3BWcSbuo6laHY2U8NPDWkQAXQsvfRoXoi2DVP6lEVJd1NyXYuEUC4gNDUbicZiAz7WckpZB3rxRSxDU3PAPcFh1OKVz/QglQFmik8OAT03un4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YhPMAWj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YhPMAWj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D111C4CED2;
	Thu, 28 Nov 2024 01:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732757725;
	bh=uTYSV618GqZg0u0n3Zo3loRecQihx8C23ltJsLbZWLE=;
	h=Date:To:From:Subject:From;
	b=YhPMAWj+nJjQ+SSaqkIP0V4h5CdmeRyjMjVJam9GrAhP1Hhb81eMvnn0qaNBr+NBh
	 lOajyDk5KbF0OaKJZic+E7VPgUJr6NFDUc1BMkxW7FDyxfdFR7EwNKns4YNomnFOTY
	 4NuTtxK2SzXWzMk/rqawgEq49n4R9Etvnk74m79c=
Date: Wed, 27 Nov 2024 17:35:24 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,jhubbard@nvidia.com,donettom@linux.ibm.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-few-missing-gitignore-files.patch added to mm-unstable branch
Message-Id: <20241128013525.6D111C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add a few missing gitignore files
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-a-few-missing-gitignore-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-few-missing-gitignore-files.patch

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
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: selftests/mm: add a few missing gitignore files
Date: Mon, 25 Nov 2024 14:40:36 +0800

Compiled binary files should be added to .gitignore
'git status' complains:
   Untracked files:
   (use "git add <file>..." to include in what will be committed)
         mm/hugetlb_dio
         mm/pkey_sighandler_tests_32
         mm/pkey_sighandler_tests_64

Link: https://lkml.kernel.org/r/20241125064036.413536-1-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-a-few-missing-gitignore-files
+++ a/tools/testing/selftests/mm/.gitignore
@@ -36,6 +36,9 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 memfd_secret
+hugetlb_dio
+pkey_sighandler_tests_32
+pkey_sighandler_tests_64
 soft-dirty
 split_huge_page_test
 ksm_tests
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

selftests-mm-add-a-few-missing-gitignore-files.patch

