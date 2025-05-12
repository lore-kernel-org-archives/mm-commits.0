Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D151A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011145; cv=none; b=mRKyMtwCeVRg+9SH08BUHH1bPZUEJ30+3GaR0yvhhn7V6Vu8UX2ZKRO2wSrw6GQ/oif8VvQXthgU0oeNS6oMpt+2V84guoHMNRFC1dKGHqx1qgfnNh4xQbD/rHHh20t4AAmoVHlxmlLQUyaSXtO9fNPnntD8y7wEmgV61fOz7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011145; c=relaxed/simple;
	bh=h2kb7S5CaM7X9r+h26LAKfSekOMAPUlnEQ5uuyS3CCI=;
	h=Date:To:From:Subject:Message-Id; b=VlCI7uyMAQbbt0LfN1phQRBUcGEw2HXuSheKTUtty5/nMJjOrs5yvCxBQRf52LNSprL23YW+gkIpt9ngykcURVmbjLQbMLnbLzhdRT6hy6PdJ5W2vGCM5yyEGoXVqnOLus8JksN++0uUwiQ5TxHmpo7lxQvRwDanjFVRaAG3C9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o/VJnn05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o/VJnn05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E0C4CEE4;
	Mon, 12 May 2025 00:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011145;
	bh=h2kb7S5CaM7X9r+h26LAKfSekOMAPUlnEQ5uuyS3CCI=;
	h=Date:To:From:Subject:From;
	b=o/VJnn05C+/cz/oPSCHHmTZn1m6N9Pzae6zbOo5e/mXhZIawfFNMR/1p9sFHEImfi
	 WWubygD5BN9Ho6m8bVv7xb+1XcXOIT6Wx9RECxUpjE/RwRXWBSKjYR6xzQ1HCWKG9v
	 pfHGHgn6SgKbv0ZfEXmPZt5suv9SvssLL9IiycYA=
Date: Sun, 11 May 2025 17:52:24 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,ahuang12@lenovo.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-allow-built-in-execution.patch removed from -mm tree
Message-Id: <20250512005225.6B1E0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: allow built-in execution
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-allow-built-in-execution.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: allow built-in execution
Date: Thu, 17 Apr 2025 18:12:14 +0200

Remove the dependency on module loading ("m") for the vmalloc test suite,
enabling it to be built directly into the kernel, so both ("=m") and
("=y") are supported.

Motivation:
- Faster debugging/testing of vmalloc code;
- It allows to configure the test via kernel-boot parameters.

Configuration example:
  test_vmalloc.nr_threads=64
  test_vmalloc.run_test_mask=7
  test_vmalloc.sequential_test_order=1

Link: https://lkml.kernel.org/r/20250417161216.88318-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Adrian Huang <ahuang12@lenovo.com>
Tested-by: Adrian Huang <ahuang12@lenovo.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug  |    3 +--
 lib/test_vmalloc.c |    5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.debug~lib-test_vmallocc-allow-built-in-execution
+++ a/lib/Kconfig.debug
@@ -2574,8 +2574,7 @@ config TEST_BITOPS
 config TEST_VMALLOC
 	tristate "Test module for stress/performance analysis of vmalloc allocator"
 	default n
-       depends on MMU
-	depends on m
+	depends on MMU
 	help
 	  This builds the "test_vmalloc" module that should be used for
 	  stress and performance analysis. So, any new change for vmalloc
--- a/lib/test_vmalloc.c~lib-test_vmallocc-allow-built-in-execution
+++ a/lib/test_vmalloc.c
@@ -591,10 +591,11 @@ static void do_concurrent_test(void)
 	kvfree(tdriver);
 }
 
-static int vmalloc_test_init(void)
+static int __init vmalloc_test_init(void)
 {
 	do_concurrent_test();
-	return -EAGAIN; /* Fail will directly unload the module */
+	/* Fail will directly unload the module */
+	return IS_BUILTIN(CONFIG_TEST_VMALLOC) ? 0:-EAGAIN;
 }
 
 module_init(vmalloc_test_init)
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch

