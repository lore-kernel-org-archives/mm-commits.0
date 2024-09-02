Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6F2EEC0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246882; cv=none; b=ju3jUvFa0Ki/4wx515TaYLi5SUQX8jmlf8utFQRLUA70WelTVAhgjt0bckKJVQymBWPlmAUSL5owr4mS6dKlJMo6TM8hziSzYFeLH0BN7bie/fpfW1V8xCDy52OsryExL2xN7Gvut3sLy1hXo0LnLfOuDLRyG1ZZJAlhURLA9W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246882; c=relaxed/simple;
	bh=h3FE7CJoJ1T2Zee/rWLaJP10+UtlIsCM6/O1syRgsFA=;
	h=Date:To:From:Subject:Message-Id; b=NEb5tBxc4yOptqrm/J8HQ6om0Nn/RDAjzUN1q1AKODvckY6Vnd1qpVvlAOOZlUw86CxHAsQqcQdT5sSzfkU2kZtDTsC7wW5ytYMALY/mo7E5elkm9K3+lvbUy2O3Hu9SGHqriAFpTrLvN7Psc68PUb2f2N4Q2oaRJjRIszsX494=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VnLWRN2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VnLWRN2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44878C4CEC3;
	Mon,  2 Sep 2024 03:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246882;
	bh=h3FE7CJoJ1T2Zee/rWLaJP10+UtlIsCM6/O1syRgsFA=;
	h=Date:To:From:Subject:From;
	b=VnLWRN2O4S7GOUL07CppEVi+mwWqhMneFjcfIbdGrlgRvxHO/feeuNbYfIKwoiQej
	 MsBbt58ST9hLKZK/95FNMp9LBAeaHR5O2M8GzoEu97VthxwJ7n+l8Y6nbZVH97CtM4
	 tjyIBthhUHGNaCNsU11fJ/BEfHT9dsf+kRkKdBv4=
Date: Sun, 01 Sep 2024 20:14:41 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch removed from -mm tree
Message-Id: <20240902031442.44878C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! selftests/mm: Add mseal test for no-discard madvise
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch

This patch was dropped because it was folded into selftests-mm-add-mseal-test-for-no-discard-madvise.patch

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: fixup! selftests/mm: Add mseal test for no-discard madvise
Date: Wed, 7 Aug 2024 21:37:24 +0100

Adjust the mseal test's plan.

Link: https://lkml.kernel.org/r/20240807203724.2686144-1-pedro.falcato@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Tested-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-mseal-test-for-no-discard-madvise-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1764,7 +1764,7 @@ int main(int argc, char **argv)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(80);
+	ksft_set_plan(82);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch
selftests-mm-add-more-mseal-traversal-tests-fix-2.patch

