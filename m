Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11286320F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955327; cv=none; b=CigCs+3+Dmx6V8zbBxagFAfsqcL+WY6l/i3+Rl+aj4VkjAdVIk58Bxt/GKaEXXbHBjK5oWSJT1N8dUvku5k2BVmb9xcx77ihtZfiGMG89Y1D6lcxK+8uLAHVc/HhhJJ/aoUkMIIL8/TcKGRfmVnXLZnEFOxTb4D/J4zaBmo3ryE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955327; c=relaxed/simple;
	bh=JTjhm8IFErJVO6EnBqdngEvBUqoP16xULjgGkFXZjVU=;
	h=Date:To:From:Subject:Message-Id; b=N5Zf1F8xXxvEoivQx8gxdFuj84NnAYO5jpYELdwYsE8CXJnMtOsyFaDDJCVThp8CF4LezlFNGBULs5HH3/gWfKZR2OuBlLJE6//CV7ako+lX3WYu4rbEkl6mMMWoRPOmway2QkcyxgdSjGi1PCMAeM0Ab2ajYT/Sb2mGIGE+E9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D3ns/EaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D3ns/EaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF20DC116B1;
	Mon,  6 May 2024 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955326;
	bh=JTjhm8IFErJVO6EnBqdngEvBUqoP16xULjgGkFXZjVU=;
	h=Date:To:From:Subject:From;
	b=D3ns/EaUh23DpcpJqULyxqxey27ebJOjo0jjHLBDRCVmXaLX3+a+hWcso+1vAYWw4
	 YyrpisM9JC4UZyVZKmruEJT1mP/D4AfCzcvlhwsijsq27oPtvG68g8jU1GWGpoFGOR
	 uGu6ZbqNcIsRUebJSDN0++I0B9ml/XT7F1ehM9eo=
Date: Sun, 05 May 2024 17:28:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,Liam.Howlett@oracle.com,djwong@kernel.org,david@fromorbit.com,da.gomez@samsung.com,mcgrof@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch removed from -mm tree
Message-Id: <20240506002846.CF20DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_xarray.c: fix error assumptions on check_xa_multi_store_adv_add()
has been removed from the -mm tree.  Its filename was
     lib-test_xarrayc-fix-error-assumptions-on-check_xa_multi_store_adv_add.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


