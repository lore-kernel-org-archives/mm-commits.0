Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574FA335C7
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 20:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727208092; cv=none; b=NkQ4WiA7ltyc5skKgVLWHaZzPHbdy4adbXPRSZOHaKYBEkafeGQZfKvnfd+a5ljq3Avi8v3XrQzf2PWShII7J9GgOwJBe3ywWCVaBEUjlz+gvuVI3wphtJot0NMmZLJyt1gcEoNZnEa4HOJ0nvxOoxVh1OdLhRZumexqA+GDtSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727208092; c=relaxed/simple;
	bh=yY02gx9HlfVSLx6AkTE01kkmaboVN3A4CdSTPpQJJ5A=;
	h=Date:To:From:Subject:Message-Id; b=Fgbh2hplJVPzWc8BkphXQIq2U+RGuAIr6CmG2roGiAk0t7uWaT2+hup1yuH3NeF6oj4q0eobNXvoeYVkViv+dPMASJ3FGfcQw9ik1RJR/30OUhGIQLmsnyDEtD8pSSRkD9reV0dyOcydX/65UR1EB9v8MWGW14gFVaubmd+iIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SALtg59o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SALtg59o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9E5C4CEC4;
	Tue, 24 Sep 2024 20:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727208091;
	bh=yY02gx9HlfVSLx6AkTE01kkmaboVN3A4CdSTPpQJJ5A=;
	h=Date:To:From:Subject:From;
	b=SALtg59ojB2h1K1MImCkdNjcvcZfAftjaQkwsukritcK+B6i1+oNeLTk0ii/Gx/AI
	 VBE3H5BGt2YOmapaUJgdkItUZAeaoSCGEyv+BTunYSwsKtzE/RbUCJXp8ovrKRzMyr
	 NWufcWHUbpa4lX5egdJTUxxcmGwOhpphdc/U5R8M=
Date: Tue, 24 Sep 2024 13:01:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,keith.lucas@oracle.com,donettom@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch added to mm-unstable branch
Message-Id: <20240924200131.BE9E5C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add pkey_sighandler_xx, hugetlb_dio to .gitignore
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/mm: add pkey_sighandler_xx, hugetlb_dio to .gitignore
Date: Tue, 24 Sep 2024 19:59:11 +0100

Commit 6998a73efbb8 ("selftests/mm: Add new testcases for pkeys") and
commit 3a103b5315b7 ("selftest: mm: Test if hugepage does not get leaked
during __bio_release_pages()") generate test binaries hugetlb_dio,
pkey_sighandler_tests_32 and pkey_sighandler_tests_64 but did not add
these to .gitignore.  Correct this.

Link: https://lkml.kernel.org/r/20240924185911.117937-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore
+++ a/tools/testing/selftests/mm/.gitignore
@@ -51,3 +51,6 @@ hugetlb_madv_vs_map
 mseal_test
 seal_elf
 droppable
+hugetlb_dio
+pkey_sighandler_tests_32
+pkey_sighandler_tests_64
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch

