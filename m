Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72061E504
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206087; cv=none; b=rKaY5+UeIm3Wb7OdgUN/Uxzl4wTa8/4wLcbjkvYCU3ApXBdPGegYVQ7p1mp5vAAFtB0alSjyZiFLxh5L8fPkbEjuw/1wGnBsT2WbiSjd5S8KWpBb8NlBAw6Nx3pTBQf5VGgDozQTrQ4Qad1gVSJnzQ63JmjqshOavAGy4vT7d1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206087; c=relaxed/simple;
	bh=fvBmX9GqpixDBZJepI2Vp9YUNGsBHS9nhtifQt/JkXs=;
	h=Date:To:From:Subject:Message-Id; b=KMyZfC/hd2mDEJrZeTNlWvjfheou4KoEZiN8sDFokGTyZRbGncdLT3/WeGFZv+QbuvHpOOizPACczdLpXBzQqB5WK/eKM9vmGn+JpJGsxnXMIQdS6NjppRWUc1fDjKMtb1/ZIkin28WqWxbRichskCL6Ak+ZT2QsDdR1pdCWT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fsEjBp4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fsEjBp4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755BFC4AF17;
	Wed, 21 Aug 2024 02:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206087;
	bh=fvBmX9GqpixDBZJepI2Vp9YUNGsBHS9nhtifQt/JkXs=;
	h=Date:To:From:Subject:From;
	b=fsEjBp4lbQF8CGwtQF1ZCm7iXqWzqQGl0WsEntx+EcVgL2L2M12p/N0vopO6B+7+F
	 JcUK6FJGjWEUVl2HFS/lK+b1xd29cSlczJREVVeIaja7d8Xewo3W0sdJW6YAf9O35+
	 L/Ct3BbHow8Ij/dflLhNpUpXHxeSp+TjNrjYzoUk=
Date: Tue, 20 Aug 2024 19:08:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,pedro.falcato@gmail.com,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-more-mseal-traversal-tests-fix.patch added to mm-unstable branch
Message-Id: <20240821020807.755BFC4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-add-more-mseal-traversal-tests-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-more-mseal-traversal-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-more-mseal-traversal-tests-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-add-more-mseal-traversal-tests-fix
Date: Tue Aug 20 06:51:01 PM PDT 2024

remove incorrect comment, per review

Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-more-mseal-traversal-tests-fix
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -774,11 +774,6 @@ static void test_seal_mprotect_partial_m
 	int ret;
 	int prot;
 
-	/*
-	 * Check if a partial mseal (that results in two vmas) works correctly.
-	 * It might mprotect the first, but it'll never touch the second (msealed) vma.
-	 */
-
 	setup_single_address(size, &ptr);
 	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

