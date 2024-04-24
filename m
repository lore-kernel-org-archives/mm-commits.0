Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EEA15CD7C
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995977; cv=none; b=Q2jWyQWcZDbLaFRRQIvZpGnFNzUzYM3FNvHXFhrbazQqtpkf8sRCOY9pO7hP42SgH5k/k/zvzBUVF6bjvbwemD6jnb5xsmAFrdUyBOcRKpf8XGwkEzAhQG3G3BQSuCTOlJJpX2uQWYd3V/zls8EvJ8352bavcr+W1a+2HMb4H+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995977; c=relaxed/simple;
	bh=/CrVd+R17AFtTNyNTJn4WPCLIYYPi6K3f49jNWHS5qM=;
	h=Date:To:From:Subject:Message-Id; b=YrvC+PBHe2jrOmIx2GFs6Vt68DqCc6UCsArbOFwrT31mm9aM79kqyQnwNp5mQNDTghUR+b5c0VyF8rk+t3XGAwnTLSukvSp33q6JTUQNgFLdujYS5GQpVHFjtSNb6J3WHSVwtszL8KVUIFXYxmqlZ8OWjkdLAY+0czzXPtZClvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gYhU2724; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gYhU2724"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C10BC113CD;
	Wed, 24 Apr 2024 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713995977;
	bh=/CrVd+R17AFtTNyNTJn4WPCLIYYPi6K3f49jNWHS5qM=;
	h=Date:To:From:Subject:From;
	b=gYhU2724Ar4o0blZh7UCG9s5A5keLk4NlXYkD9nvrraoun7+5gzv/SBMWdVkSuCFT
	 OQucKVyFt0x7XaqLrcoWW5o6uVOH6gyOzr9uKONDUyxexeisY4iGkbExErM4M0EwRS
	 qIRSYZwfjm26Za2r7ZaEsSqcmrfhZKg0BNSULZrs=
Date: Wed, 24 Apr 2024 14:59:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,Liam.Howlett@oracle.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch added to mm-hotfixes-unstable branch
Message-Id: <20240424215937.4C10BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_xarray.c: fix error assumptions on check_xa_multi_store_adv_add()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch

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
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: lib/test_xarray.c: fix error assumptions on check_xa_multi_store_adv_add()
Date: Tue, 23 Apr 2024 12:22:21 -0700

While testing lib/test_xarray in userspace I've noticed we can fail with:

make -C tools/testing/radix-tree
./tools/testing/radix-tree/xarray

BUG at check_xa_multi_store_adv_add:749
xarray: 0x55905fb21a00x head 0x55905fa1d8e0x flags 0 marks 0 0 0
0: 0x55905fa1d8e0x
xarray: ../../../lib/test_xarray.c:749: check_xa_multi_store_adv_add: Assertion `0' failed.
Aborted

We get a failure with a BUG_ON(), and that is because we actually can
fail due to -ENOMEM, the check in xas_nomem() will fix this for us so
it makes no sense to expect no failure inside the loop. So modify the
check and since this is also useful for instructional purposes clarify
the situation.

The check for XA_BUG_ON(xa, xa_load(xa, index) != p) is already done
at the end of the loop so just remove the bogus on inside the loop.

With this we now pass the test in both kernel and userspace:

In userspace:

./tools/testing/radix-tree/xarray
XArray: 149092856 of 149092856 tests passed

In kernel space:

XArray: 148257077 of 148257077 tests passed

Link: https://lkml.kernel.org/r/20240423192221.301095-3-mcgrof@kernel.org
Fixes: a60cc288a1a2 ("test_xarray: add tests for advanced multi-index use")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/lib/test_xarray.c~lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add
+++ a/lib/test_xarray.c
@@ -744,15 +744,20 @@ static noinline void check_xa_multi_stor
 
 	do {
 		xas_lock_irq(&xas);
-
 		xas_store(&xas, p);
-		XA_BUG_ON(xa, xas_error(&xas));
-		XA_BUG_ON(xa, xa_load(xa, index) != p);
-
 		xas_unlock_irq(&xas);
+		/*
+		 * In our selftest case the only failure we can expect is for
+		 * there not to be enough memory as we're not mimicking the
+		 * entire page cache, so verify that's the only error we can run
+		 * into here. The xas_nomem() which follows will ensure to fix
+		 * that condition for us so to chug on on the loop.
+		 */
+		XA_BUG_ON(xa, xas_error(&xas) && xas_error(&xas) != -ENOMEM);
 	} while (xas_nomem(&xas, GFP_KERNEL));
 
 	XA_BUG_ON(xa, xas_error(&xas));
+	XA_BUG_ON(xa, xa_load(xa, index) != p);
 }
 
 /* mimics page_cache_delete() */
_

Patches currently in -mm which might be from mcgrof@kernel.org are

tools-fix-userspace-compilation-with-new-test_xarray-changes.patch
lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch

