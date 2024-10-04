Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1548121A1C;
	Fri,  4 Oct 2024 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008777; cv=none; b=MD0KHSNJ+GsYLjqAZ6rkky0mYUV73Sds40xuZcAj6UssBbmRuvV/Vf/we9WcBlZ/src4gO01F5eMz0dh7BxaEuR0nqY5noYMIDWHGwCKwwRNQGDyHPAQxWjf26V5HSxQ0OM2CH3WqLL+Voqu5yEgb4A3QvGBgdO+kfWpUyiCBec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008777; c=relaxed/simple;
	bh=BOhOzHf5NiWhfCMDhchUWqLTdn0HLc+/OlDAq9FjcKg=;
	h=Date:To:From:Subject:Message-Id; b=Ba4gNIvOPkKg8JmOgXAHkyIGxPwzOm7/YnAA9PjUAjNYBU9JW5ZQ6+o9/kSU71u0+8a04A0bX0VB5J+dex2qs+JU16HfJFAxBDA6N6SgezrQjQXx4olhb8ltmU6gygBValK40wRPrAY5F/1+6dAIuy4CSeeSos/WqvxDTYdoqVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0LOUEvbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0LOUEvbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87242C4CEC5;
	Fri,  4 Oct 2024 02:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008776;
	bh=BOhOzHf5NiWhfCMDhchUWqLTdn0HLc+/OlDAq9FjcKg=;
	h=Date:To:From:Subject:From;
	b=0LOUEvbK102kiBz6JzAcxOUgqkLmHQe78ucIz0JBZYE1bcWUoqmcwGyaCIlRIPboU
	 6ap2/AviLYLrwsL6Ml6+hoVcfEhMrG7qHN1xzXzeTMv0fruaaDVniYFxN2AMoKlXLf
	 kUShPcn/N+7LCk8x2s95zx8Ola8LBruMhQeBBcWA=
Date: Thu, 03 Oct 2024 19:26:16 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,ritesh.list@gmail.com,rcampbell@nvidia.com,przemyslaw.kitszel@intel.com,keescook@chromium.org,jglisse@redhat.com,jgg@mellanox.com,broonie@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test.patch removed from -mm tree
Message-Id: <20241004022616.87242C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test
Date: Fri, 27 Sep 2024 00:07:52 -0500

The hmm2 double_map test was failing due to an incorrect buffer->mirror
size.  The buffer->mirror size was 6, while buffer->ptr size was 6 *
PAGE_SIZE.  The test failed because the kernel's copy_to_user function was
attempting to copy a 6 * PAGE_SIZE buffer to buffer->mirror.  Since the
size of buffer->mirror was incorrect, copy_to_user failed.

This patch corrects the buffer->mirror size to 6 * PAGE_SIZE.

Test Result without this patch
==============================
 #  RUN           hmm2.hmm2_device_private.double_map ...
 # hmm-tests.c:1680:double_map:Expected ret (-14) == 0 (0)
 # double_map: Test terminated by assertion
 #          FAIL  hmm2.hmm2_device_private.double_map
 not ok 53 hmm2.hmm2_device_private.double_map

Test Result with this patch
===========================
 #  RUN           hmm2.hmm2_device_private.double_map ...
 #            OK  hmm2.hmm2_device_private.double_map
 ok 53 hmm2.hmm2_device_private.double_map

Link: https://lkml.kernel.org/r/20240927050752.51066-1-donettom@linux.ibm.com
Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hmm-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -1657,7 +1657,7 @@ TEST_F(hmm2, double_map)
 
 	buffer->fd = -1;
 	buffer->size = size;
-	buffer->mirror = malloc(npages);
+	buffer->mirror = malloc(size);
 	ASSERT_NE(buffer->mirror, NULL);
 
 	/* Reserve a range of addresses. */
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


