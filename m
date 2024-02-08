Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608DD38DFA;
	Thu,  8 Feb 2024 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707423751; cv=none; b=dPqchK7lvUob4GMdfBXwq23Vi07x6oalh0Xv3fjJJnVeobnZn/zcMGfCayZrS4pW6QmGyTk2p0un40Qm31OU0usTDlMN9odo62j0/C6z0zX0pDrK0kmSIBiq/r0fGn8O8mFOfWKwPPV7ERPnw/asikg2CVKl4fdLYAZcTlVSr0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707423751; c=relaxed/simple;
	bh=WfSEZa6Q3Ok25eTwMPEKrgvr26vOJAtkJzzYKzAq3uk=;
	h=Date:To:From:Subject:Message-Id; b=gM0AZ8EwNAofLfd+Oeb7eM6fRYKtPLPo2NaCclsVCkeG7EcdoVAjwnfqmHdTmvLopZWCQoCgDMTo0KmugF0ngsmgJgcSp0VbV906A82NZh+3qhUnQQz4TfzxcM9hiuZbLNv8QutJfW1k2eaXnS8zEBMSfTLGNjutS0EZJBlYQHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2SIKivkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2SIKivkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86F1C433C7;
	Thu,  8 Feb 2024 20:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707423750;
	bh=WfSEZa6Q3Ok25eTwMPEKrgvr26vOJAtkJzzYKzAq3uk=;
	h=Date:To:From:Subject:From;
	b=2SIKivkJMWQGqPmAtGhAUMc9SMVMNwMMaLXYToqqhb0+uwcqLH6pu/PiLthLPBl75
	 q9hSla7LVcW/PrfQVbpd8bHULZwApfdDc3zmZastjST3+3031SilfKHqWF85eQeUis
	 129ygmY+D5/oIaDnD14FbJenQzkI4lfMfOMeQr8M=
Date: Thu, 08 Feb 2024 12:22:29 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,dhowells@redhat.com,linux@roeck-us.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-test_iov_iter-depends-on-mmu.patch added to mm-hotfixes-unstable branch
Message-Id: <20240208202230.D86F1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/Kconfig.debug: TEST_IOV_ITER depends on MMU
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-kconfigdebug-test_iov_iter-depends-on-mmu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-test_iov_iter-depends-on-mmu.patch

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

lib-kconfigdebug-test_iov_iter-depends-on-mmu.patch

