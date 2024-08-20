Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6060C2F52;
	Tue, 20 Aug 2024 00:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724113927; cv=none; b=neYljUoI9i5vcAgjnlbMIu6jCQavx1qc1OM2ACuz7/PIEd4fNua0hOGOkJGma860EoHDY08fqmyY+6itZxBv2oyRuG4jDMSGiqrirPxnmnwFU/vrDx+U3Tuo005VqVm9s8YKezBXYxmwgZkYP1cott+vKWyEDnXZiZWAS2bc5+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724113927; c=relaxed/simple;
	bh=P87OLKr407u0qrHQWhxQpfh60h0AgrZzDDHtTTEYnAo=;
	h=Date:To:From:Subject:Message-Id; b=BAdBtXzfzLHV20sZ6eSykZOC7HP09Yc3pTK6+KrSChSneZy7+lLxvFRCsWv50fwW486wiMgA084lgq1/E7k86QAhv+t9WQN9r8RHs3w37ZWNMUFx0Ktd+kwAztQHeX3/bUd1ntm53licHzDn2k5Th4ZWmxqCIwNEf3c9OTrc39k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I4hrVPpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I4hrVPpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26CCC32782;
	Tue, 20 Aug 2024 00:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724113926;
	bh=P87OLKr407u0qrHQWhxQpfh60h0AgrZzDDHtTTEYnAo=;
	h=Date:To:From:Subject:From;
	b=I4hrVPpwproGO/rlu4UWIYigLvfMZhCw6fCt2kHUgoqjw/TgmgVqetnGkcmw8HUCI
	 OQD0tKo2KvYbf1mus3286reQIYv0QM9qpKz53LH30QyV2yYW2Oy7guoCEqYjOzRq7P
	 tTDvnFFiaoBMTyW+Ik5y2fM71cOZMjs59nWfQgcc=
Date: Mon, 19 Aug 2024 17:32:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,erhard_f@mailbox.org,davidgow@google.com,ivan.orlov0322@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kunit-overflow-fix-ub-in-overflow_allocation_test.patch removed from -mm tree
Message-Id: <20240820003206.C26CCC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit/overflow: fix UB in overflow_allocation_test
has been removed from the -mm tree.  Its filename was
     kunit-overflow-fix-ub-in-overflow_allocation_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: kunit/overflow: fix UB in overflow_allocation_test
Date: Thu, 15 Aug 2024 01:04:31 +0100

The 'device_name' array doesn't exist out of the
'overflow_allocation_test' function scope.  However, it is being used
as a driver name when calling 'kunit_driver_create' from
'kunit_device_register'.  It produces the kernel panic with KASAN
enabled due to undefined behaviour.

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


