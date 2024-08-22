Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A73876025
	for <mm-commits@vger.kernel.org>; Thu, 22 Aug 2024 19:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724353742; cv=none; b=Bg3DnfdrvDPGYTUmhZN9EBe+nYqn1Dsb2jLFyc192H35rOBX433PHsmWSDd4hKetBDrQTcKT6MESp3VXqoOV5QTfb3XnFdCPUnIOS/it8nOtP8XTgtG1dWtR7m1cGcO5fYBA/Lgm3C0NUsU5qC0RifgOlnQ6SrLbK4+Ru8hZAsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724353742; c=relaxed/simple;
	bh=lVq1f4YtIZ9r8LGC4n5rN4PKInH0DHfSSITElAIItWk=;
	h=Date:To:From:Subject:Message-Id; b=FeC2rSLtruIp4cbfEOucc7axH7Evvo/aPae0larn0u3JzmzY5VvMNCY2V1G/Yj9fhh56iYcY1DatkH2jW8ObvmqUE6Me6o4BRgsGraFGrr/Apc1ZDoZZ2/Lu1vTauaJ/hniAekyzH5sy0W1h/3mwKwS0eCjX/6RyTO3l1jiwpz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0OGhZJZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0OGhZJZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8DEC32782;
	Thu, 22 Aug 2024 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724353742;
	bh=lVq1f4YtIZ9r8LGC4n5rN4PKInH0DHfSSITElAIItWk=;
	h=Date:To:From:Subject:From;
	b=0OGhZJZ0RiR1Fs8WuozEymaxQw14jz8mKxSlMgcZp8lwfKc1svSn5wDQaiIlMMQdE
	 ddsAApDgE1K22kSiLdHBBP710Q9YGAJngw1ghJzYb8cG3hk6hzzmjwrlCPQ8sfiLSL
	 8p66tJrPt0WE7e0GvQaWxxXl/ngd61i8luwez8R8=
Date: Thu, 22 Aug 2024 12:09:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-more-mseal-traversal-tests-fix-2.patch added to mm-unstable branch
Message-Id: <20240822190902.0A8DEC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix mseal's length
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-more-mseal-traversal-tests-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-more-mseal-traversal-tests-fix-2.patch

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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: selftests/mm: fix mseal's length
Date: Thu, 22 Aug 2024 00:20:19 +0100

We accidentally msealed too much, which could overrun and try to mseal
other regions.  This seems to be harmless (at least on top-down
architectures) due to various reasons all aligning, but may very well
cause spurious test failures to e.g bottom-up mmap architectures.

Link: https://lkml.kernel.org/r/vc4czyuemmu3kylqb4ctaga6y5yvondlyabimx6jvljlw2fkea@djawlllf45xa
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests-fix-2
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -778,7 +778,7 @@ static void test_seal_mprotect_partial_m
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
-		ret = sys_mseal(ptr + page_size, size);
+		ret = sys_mseal(ptr + page_size, page_size);
 		FAIL_TEST_IF_FALSE(!ret);
 	}
 
@@ -1031,7 +1031,7 @@ static void test_seal_munmap_partial_acr
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	if (seal) {
-		ret = sys_mseal(ptr + page_size, size);
+		ret = sys_mseal(ptr + page_size, page_size);
 		FAIL_TEST_IF_FALSE(!ret);
 	}
 
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch
selftests-mm-add-more-mseal-traversal-tests-fix-2.patch

