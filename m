Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA763B3BF9
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 22:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772316359; cv=none; b=q0VXoQZYsV83cTe135bPrzeXbhBXb0599eOmEbtl6XB7pCol5Mly5RnPFsT66vYpLWMOyBMedQD/jzZue3FoDF3ISr7AsVnonj3+ioxTFDgdIt1mbnbcJZsyZJ/2NWlnMU8KJR0iOTXCDoZ5cwV1rwGbxdQbw3DiYFEvp/X58Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772316359; c=relaxed/simple;
	bh=GiDsjNtzYizMvC3LAac/zde61WzRwwdljEUWNzBo9LA=;
	h=Date:To:From:Subject:Message-Id; b=m26u4TrOVjZYxgJ5/aYSkGrL6IUMznEzrQj2Rzhtu/Vdu+7UAhey7u7RAiYX97t5zQ05yUMNWu/qBSQVuH0HZOPYd9VeAPtkZClEHIkWVE3dL2VrFAXRPzEn5cLAfaTV/QnTmBjr6MBSbCP/nrzasLR1cQaSjRuYGZluT7yQxTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=01ZG/B/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="01ZG/B/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E53CC116D0;
	Sat, 28 Feb 2026 22:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772316359;
	bh=GiDsjNtzYizMvC3LAac/zde61WzRwwdljEUWNzBo9LA=;
	h=Date:To:From:Subject:From;
	b=01ZG/B/M3qFnWC18pgHtFIRa8M8tyMcmSoO7dkmnOwc+wYq9WCVx7CKgCq8aY2Dy2
	 3PBw0VmfBeBdNMVmp7NATEadeRZJgysZp+SaTeTSyKwOhAjMkGKGIKdBz/VJVGcnMf
	 B+uvggRPjl5ygv8Ov3QI/ziTb4QD31RLMLnYIIF0=
Date: Sat, 28 Feb 2026 14:05:58 -0800
To: mm-commits@vger.kernel.org,legion@kernel.org,brauner@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-fchmodat2-use-ksft_finished.patch added to mm-nonmm-unstable branch
Message-Id: <20260228220559.2E53CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/fchmodat2: use ksft_finished()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-fchmodat2-use-ksft_finished.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-fchmodat2-use-ksft_finished.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/fchmodat2: use ksft_finished()
Date: Thu, 26 Feb 2026 22:24:43 +0000

The fchmodat2 test program open codes a version of ksft_finished(), use
the standard version.

Link: https://lkml.kernel.org/r/20260226-selftests-fchmodat2-v4-2-a6419435f2e8@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/fchmodat2/fchmodat2_test.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/tools/testing/selftests/fchmodat2/fchmodat2_test.c~selftests-fchmodat2-use-ksft_finished
+++ a/tools/testing/selftests/fchmodat2/fchmodat2_test.c
@@ -196,8 +196,5 @@ int main(int argc, char **argv)
 	test_regfile();
 	test_symlink();
 
-	if (ksft_get_fail_cnt() + ksft_get_error_cnt() > 0)
-		ksft_exit_fail();
-	else
-		ksft_exit_pass();
+	ksft_finished();
 }
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch
selftests-fchmodat2-clean-up-temporary-files-and-directories.patch
selftests-fchmodat2-use-ksft_finished.patch

