Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D141C1AD1;
	Fri, 27 Sep 2024 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727460449; cv=none; b=Lmkvt22LOhYHffjBWdi++3VkS02sSI4RWYZXeWEQvJ6AZKFNRnt0+mVY/Vw3MgqaBIFK1vY/eDTugzchXymIZgTQb42QyU8a6lZZBpBBLRto4F0jGqXyW0v7PuIAINxSpXLoHskj8iagM5aEbXiPDlDKhkbepBHa1EYe0Xj/Cns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727460449; c=relaxed/simple;
	bh=36ZwAxe9BvZG5ueesbdD3W4C1xaXJY5vy7rDAwY19bI=;
	h=Date:To:From:Subject:Message-Id; b=aB7/jhijh9pl8HJba5lieh/SKMP1tLfmoqbza4SQA0eTnLv0V9WshjLXd9raAF25PlnoPqKBOIAnBQHkpHq8hDneHqn/LnpPHCpSQya8BLg2Ioh25gSfIwUD5NrcDsZO/XJtLeK4VfgYHhiOqzs+c1kNsaNKUlx9uxhequzssSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OYR46klB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OYR46klB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECE2C4CEC4;
	Fri, 27 Sep 2024 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727460448;
	bh=36ZwAxe9BvZG5ueesbdD3W4C1xaXJY5vy7rDAwY19bI=;
	h=Date:To:From:Subject:From;
	b=OYR46klBZhGPEJogvfd8S90Vsk0St05BCQKlWEml9775Obui8y+m0D7IzglmolwCT
	 YiF30m5MqqCjd+fV0wLuqP3lm+JdmqTMlC7vZ7uy2npQ7ApMMALeySpK3a1oork+lj
	 soD3Vta9ARxANAeRyx5P8bnroljXh6xMWFZIHv5o=
Date: Fri, 27 Sep 2024 11:07:28 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,stable@vger.kernel.org,shuah@kernel.org,ritesh.list@gmail.com,rcampbell@nvidia.com,przemyslaw.kitszel@intel.com,keescook@chromium.org,jglisse@redhat.com,jgg@mellanox.com,broonie@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20240927180728.BECE2C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test.patch

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

selftests-mm-fixed-incorrect-buffer-mirror-size-in-hmm2-double_map-test.patch

