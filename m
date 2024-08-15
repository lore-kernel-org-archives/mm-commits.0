Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D81E12B94;
	Thu, 15 Aug 2024 23:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723763050; cv=none; b=ko/0UtD7P0K6eIN5wdU/YWGbg3K1+UsPKFS6Ap0+druDRmu7Cvwxf1SpcEK373H5B6GvXz46/QKlbwNN96VHbkeXyyWitAlCMjm8pc/WOfEJgJ7e7LfR761s+2ZrPCNSnPxnvbwjm2mrT4GWc7mWsMrpSiFP5veD+14CIAoyBkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723763050; c=relaxed/simple;
	bh=IEEC+jtffX5lcp1nrDsJrcpgvd25d72MFCtAJE047JM=;
	h=Date:To:From:Subject:Message-Id; b=CKxL+CePSOWmtnXN32GOL7vinygmWZY1m0+WNFfEBYFOGUByJyWCZAxl0ClKwbBEPEkK0nR6RxDwjMgf90iH6wNVIPTKAvxaTn5JHIyuD+g27jMD3do+n7485/TjuDBOC93M3pJP3JJik5WmUMFIQgMFAIOrNYFVw6ZGowVvrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mrhlIJJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mrhlIJJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB69C32786;
	Thu, 15 Aug 2024 23:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723763050;
	bh=IEEC+jtffX5lcp1nrDsJrcpgvd25d72MFCtAJE047JM=;
	h=Date:To:From:Subject:From;
	b=mrhlIJJJ90XRPcdDb2P5mX6YOp0iDTX8treDLHfu9KysdlNFx8BHY5tHnG5xB9wSH
	 mlfmBGX34jBcHeIH+SXwmlxk9+WdUl00/b3mtupzMTJfQDAl13tNijN59onKw6/HNu
	 UYdKZeM6Pkso2QW6vGK1hLCRa8DsQ7q/yo3yE2zE=
Date: Thu, 15 Aug 2024 16:04:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,erhard_f@mailbox.org,davidgow@google.com,ivan.orlov0322@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-overflow-fix-ub-in-overflow_allocation_test.patch added to mm-hotfixes-unstable branch
Message-Id: <20240815230410.2FB69C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit/overflow: fix UB in overflow_allocation_test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kunit-overflow-fix-ub-in-overflow_allocation_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-overflow-fix-ub-in-overflow_allocation_test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: kunit/overflow: fix UB in overflow_allocation_test
Date: Thu, 15 Aug 2024 01:04:31 +0100

The 'device_name' array doesn't exist out of the
'overflow_allocation_test' function scope.  However, it is being used as a
driver name when calling 'kunit_driver_create' from
'kunit_device_register'.  It produces the kernel panic with KASAN enabled.

Since this variable is used in one place only, remove it and pass the
device name into kunit_device_register directly as an ascii string.

Link: https://lkml.kernel.org/r/20240815000431.401869-1-ivan.orlov0322@gmail.com
Fixes: ca90800a91ba ("test_overflow: Add memory allocation overflow tests")
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/overflow_kunit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/overflow_kunit.c~kunit-overflow-fix-ub-in-overflow_allocation_test
+++ a/lib/overflow_kunit.c
@@ -668,7 +668,6 @@ DEFINE_TEST_ALLOC(devm_kzalloc,  devm_kf
 
 static void overflow_allocation_test(struct kunit *test)
 {
-	const char device_name[] = "overflow-test";
 	struct device *dev;
 	int count = 0;
 
@@ -678,7 +677,7 @@ static void overflow_allocation_test(str
 } while (0)
 
 	/* Create dummy device for devm_kmalloc()-family tests. */
-	dev = kunit_device_register(test, device_name);
+	dev = kunit_device_register(test, "overflow-test");
 	KUNIT_ASSERT_FALSE_MSG(test, IS_ERR(dev),
 			       "Cannot register test device\n");
 
_

Patches currently in -mm which might be from ivan.orlov0322@gmail.com are

kunit-overflow-fix-ub-in-overflow_allocation_test.patch

