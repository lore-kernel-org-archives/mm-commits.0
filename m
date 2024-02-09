Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267F3839A
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516480; cv=none; b=A8ztpCKxWmj2ZD4911T7TYN90a/ii9vi9bKKlwIe51h9PEAn3ZcCAkLXul/xONOkv5sHqxLMFp8ORd1/jUaYLkRAtO1hMaewtu3HwnB7TVShzuFtjvQxGK+CWy5GK5wQhVFTJOXUbykE+2McTWgYKWROrRU21xO/itHjtQWMK3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516480; c=relaxed/simple;
	bh=iDU2cv0NmPTt10iaj4Qiz6ELQCToZ4lKDDLmOpzrJ+0=;
	h=Date:To:From:Subject:Message-Id; b=h5rmhiQ/ttvgrGkWzgIZur9X1Kk2vRKZ3z/PbgQnYHpLbiWSLExX+mrWwr8lq09PXxfJzrMKDP0h58ItEorNEkShQHpND1MU1SbyzHqCskZkBpc4f5mi1TpMwKQC+fCo2gyUH3cOQe5srYzsmFJMuLexiHoKIsXotn4sLsWlQQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G3PD/ZLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G3PD/ZLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94618C433F1;
	Fri,  9 Feb 2024 22:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707516479;
	bh=iDU2cv0NmPTt10iaj4Qiz6ELQCToZ4lKDDLmOpzrJ+0=;
	h=Date:To:From:Subject:From;
	b=G3PD/ZLRnf6L4B3VRDbBXXhKxiiOcgF5Q8hGxnue7Y1Q6r+G+C4FfHft4iipILiiO
	 sPDwntwJi+z3KpHMx7YmR9Lf2LAiIZUrKYh4p5ujQUCJFst9spEtwq/Jlb7IpCFJDI
	 pxKQCFPdQoh1oUE/O9vwVliXs95ntoyNKIHze0FA=
Date: Fri, 09 Feb 2024 14:07:59 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,ryan.roberts@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-log-skipped-compaction-test-as-a-skip.patch added to mm-unstable branch
Message-Id: <20240209220759.94618C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: log skipped compaction test as a skip
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-log-skipped-compaction-test-as-a-skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-log-skipped-compaction-test-as-a-skip.patch

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: log skipped compaction test as a skip
Date: Fri, 09 Feb 2024 14:30:03 +0000

Patch series "selftests/mm: Output cleanups for the compaction test".

A couple of small updates for the check_compaction selftest which make
it play more nicely with test automation systems.


This patch (of 2):

When the compaction test is run it checks to make sure that prerequistives
the test requires are available and skips the tests if not.  When this
happens we log the test as a pass rather than a skip, log as a skip so
that the distinction is clear and automation can see unexpected skips.

Link: https://lkml.kernel.org/r/20240209-kselftest-mm-cleanup-v1-0-a3c0386496b5@kernel.org
Link: https://lkml.kernel.org/r/20240209-kselftest-mm-cleanup-v1-1-a3c0386496b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-log-skipped-compaction-test-as-a-skip
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -174,7 +174,7 @@ int main(int argc, char **argv)
 	ksft_print_header();
 
 	if (prereq() || geteuid())
-		return ksft_exit_pass();
+		return ksft_exit_skip("Prerequisites unsatisfied\n");
 
 	ksft_set_plan(1);
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-log-skipped-compaction-test-as-a-skip.patch
selftests-mm-log-a-consistent-test-name-for-check_compaction.patch
selftests-mm-dont-needlessly-use-sudo-to-obtain-root-in-run_vmtestssh.patch

