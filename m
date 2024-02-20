Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809DC151CF4;
	Tue, 20 Feb 2024 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467749; cv=none; b=Vvk0re0cBhCfl0+Lj/UiGdMcmiXQs11qoL0Kfb+PALfbWs7xMKuoGWjH/zKoyIJu+qjTVLfBsdP2jYL6Ie+ijMol9gLHa4ZKd76syGe0F8M5igACcmY1Ku3Z7wFp3VuQgv4L7B/yNulijbR6cgnHDVgjhVAG+riLWD9iNuNwvZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467749; c=relaxed/simple;
	bh=gJ78NOLN3+mWe3/1UHwGY/ZJBrV+WpgbQl/+FxlYKLw=;
	h=Date:To:From:Subject:Message-Id; b=uvREO5sB4OjgwiOVRdjnzgv1dqeWqMLgaZ3cxw4aJKv9rnKm6dA5A28OjXFX+ENVCd1iLYzdp0y0hVHh4qRFh4Z9vQlpAHMJPGZt7RAmjguNFni6oC2cex8eqcKx+5623TTYykicHVrEfDW5569Zs7praSEAGhsUZwHN63/7Q2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IvsIFd3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IvsIFd3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B18C433C7;
	Tue, 20 Feb 2024 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467749;
	bh=gJ78NOLN3+mWe3/1UHwGY/ZJBrV+WpgbQl/+FxlYKLw=;
	h=Date:To:From:Subject:From;
	b=IvsIFd3Ar17wpumXneBzqUP2vlHpU0fGZ94pyelC8/D3N4AzDCOuTtL0ZBnICLZVB
	 slGeATQLB6pmPcWC0/IUVvXELnXN5Z2IDcdvCIWQQgE32tBY8uRG3hneXELEVXt88/
	 FHX6HNLCg+EXPwXRuttEpZlnytqVDEolw+VeRxoU=
Date: Tue, 20 Feb 2024 14:22:28 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,dhowells@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-kconfigdebug-test_iov_iter-depends-on-mmu.patch removed from -mm tree
Message-Id: <20240220222228.F3B18C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/Kconfig.debug: TEST_IOV_ITER depends on MMU
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-test_iov_iter-depends-on-mmu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: lib/Kconfig.debug: TEST_IOV_ITER depends on MMU
Date: Thu, 8 Feb 2024 07:30:10 -0800

Trying to run the iov_iter unit test on a nommu system such as the qemu
kc705-nommu emulation results in a crash.

    KTAP version 1
    # Subtest: iov_iter
    # module: kunit_iov_iter
    1..9
BUG: failure at mm/nommu.c:318/vmap()!
Kernel panic - not syncing: BUG!

The test calls vmap() directly, but vmap() is not supported on nommu
systems, causing the crash.  TEST_IOV_ITER therefore needs to depend on
MMU.

Link: https://lkml.kernel.org/r/20240208153010.1439753-1-linux@roeck-us.net
Fixes: 2d71340ff1d4 ("iov_iter: Kunit tests for copying to/from an iterator")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-test_iov_iter-depends-on-mmu
+++ a/lib/Kconfig.debug
@@ -2235,6 +2235,7 @@ config TEST_DIV64
 config TEST_IOV_ITER
 	tristate "Test iov_iter operation" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	depends on MMU
 	default KUNIT_ALL_TESTS
 	help
 	  Enable this to turn on testing of the operation of the I/O iterator
_

Patches currently in -mm which might be from linux@roeck-us.net are


