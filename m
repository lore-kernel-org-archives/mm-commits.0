Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77B7290DBB
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719240; cv=none; b=pJJpcXwzKcN868DpMpctX5jghoE4E8u74pDAb87GI9H8P6V/iYt9ruRYCNlTxzUQujwVOno0BQUz2aVLooxuj4bjtt66tXLpcsV5riBJ/NsR/bsIk6l8/5NZ5NuNgqS2YjMMHXIN7dlHg3eD8EjJm1CSHMUSrSVyu3b1KxZQ5UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719240; c=relaxed/simple;
	bh=wV6ZUHkYg3chALAt2pvcJeSdEPQR5ipXTB+76dY8/ZY=;
	h=Date:To:From:Subject:Message-Id; b=EvWyDPgT0QMbXbCu8E7SO7CD9jTktVWGOmge1KDIIAHBR65o9WdfzzH9AUDgYYDxdWbx37HTJGCYAlglWfgFRilUKAQBglLO6k5gajU32MA1cJXNAzeEQBRSEJCclfW7HZBSerY5ybmBqlsfdcQ9WWgXrMCMDty5VVVNn3p81qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zYZbP/z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zYZbP/z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E136C19425;
	Thu, 14 May 2026 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719240;
	bh=wV6ZUHkYg3chALAt2pvcJeSdEPQR5ipXTB+76dY8/ZY=;
	h=Date:To:From:Subject:From;
	b=zYZbP/z4muTwk+TV8ppBTBVe8Xu+ojZrQr540KTOr8neI6KYtZ0j7EkVM9xp4XH7W
	 aeuPRvIIZbJBJXECUWYMo2IKOcruueTrRfTAz2+7hDMAwSCyLaYzQuOftCHF5oqbJF
	 gZzhYIH42hWhVvCLp/+JJku/O9UkbKS/IuXzchbE=
Date: Wed, 13 May 2026 17:40:39 -0700
To: mm-commits@vger.kernel.org,joshlaw48@gmail.com,davidgow@google.com,lk@c--e.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-kunit_iov_iter-fix-test-fail-on-powerpc.patch removed from -mm tree
Message-Id: <20260514004040.5E136C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: kunit_iov_iter: fix test fail on powerpc
has been removed from the -mm tree.  Its filename was
     lib-kunit_iov_iter-fix-test-fail-on-powerpc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Christian A. Ehrhardt" <lk@c--e.de>
Subject: lib: kunit_iov_iter: fix test fail on powerpc
Date: Tue, 21 Apr 2026 09:07:07 +0200

Increase buffer size to accommodate machines with 64K PAGE_SIZE.

Link: https://lore.kernel.org/20260421070707.992873-1-lk@c--e.de
Fixes: 0913b7554726 ("lib: kunit_iov_iter: add tests for extract_iter_to_sg")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reported-by: David Gow <davidgow@google.com>
Closes: https://lore.kernel.org/34a81ec2-af84-465d-9b5e-7bb5bf01680f@davidgow.net
Tested-by: David Gow <davidgow@google.com>
Tested-by: Josh Law <joshlaw48@gmail.com>
Reviewed-by: Josh Law <joshlaw48@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/kunit_iov_iter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/tests/kunit_iov_iter.c~lib-kunit_iov_iter-fix-test-fail-on-powerpc
+++ a/lib/tests/kunit_iov_iter.c
@@ -1128,7 +1128,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct kvec kvec;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	kvec.iov_base = data.buffer;
@@ -1146,7 +1146,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct bio_vec *bvec;
 	struct iov_iter iter;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	bvec = kunit_kmalloc_array(test, data.npages, sizeof(*bvec),
@@ -1173,7 +1173,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct iov_iter iter;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	folioq = iov_kunit_create_folioq(test);
@@ -1190,7 +1190,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct iov_iter iter;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, false, &data);
 
 	xarray = iov_kunit_create_xarray(test);
@@ -1206,7 +1206,7 @@ static void __init iov_kunit_iter_to_sg_
 	struct iov_iter iter;
 	size_t bufsize;
 
-	bufsize = 0x100000;
+	bufsize = 0x200000;
 	iov_kunit_iter_to_sg_init(test, bufsize, true, &data);
 
 	iov_iter_ubuf(&iter, READ, data.ubuf, bufsize);
_

Patches currently in -mm which might be from lk@c--e.de are


