Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B31C863B;
	Fri, 20 Jun 2025 03:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391355; cv=none; b=kdgM/U5K80akIsv+fk1RSyh45SX1771L8VsKYZrSecIPUVBLFJb3NQnDfjzM3amAcfbXxoDFH8C5NNSxqEv5hC/DYZ9Dc9/vkHzTRzgl3RPU0fbjznkSmMFBjbM3m74o0Bjx/vDEG//BzpBjIYxn1/LXyb0JYc5SoXlQfXQ+4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391355; c=relaxed/simple;
	bh=ie0glEOrnx8CjsKPO2WPPJKrNLZt2ghKrkhAhlu40rA=;
	h=Date:To:From:Subject:Message-Id; b=TscaphFB2XTqfKAucbUlfGfsv+X8eUBukfuDpDhzIK/cQ8/CmZM7MLup3qHx7o3Dfv3X22hkX1Nk//jH/16AK1KRoUEeZ0oPO6FeB6nSpanj/PhonaUnj3txJFhPrcUtosDYfH5R5vH8pHz3j6CZWEy3sKvTPpAnnuGoCROpDFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w+vuSqta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w+vuSqta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAB4C4CEED;
	Fri, 20 Jun 2025 03:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391355;
	bh=ie0glEOrnx8CjsKPO2WPPJKrNLZt2ghKrkhAhlu40rA=;
	h=Date:To:From:Subject:From;
	b=w+vuSqta6g7zs37wU0OfjkdaX5QjX3M+1O+xEc1a+JhylWK2NjnFwkJTlZiP4RGi6
	 ztTF67KupHDS1zdnR/e+aVRCWUSv8GeLVsnawUyQe32OTh3waGcvE26UnPsyISBL5q
	 PDRLmcaZccM00X8GX+GC620JaG6rti15X0b5yNUU=
Date: Thu, 19 Jun 2025 20:49:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,robertpang@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,colyli@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] bcache-remove-unnecessary-select-min_heap.patch removed from -mm tree
Message-Id: <20250620034915.3EAB4C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcache: remove unnecessary select MIN_HEAP
has been removed from the -mm tree.  Its filename was
     bcache-remove-unnecessary-select-min_heap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: bcache: remove unnecessary select MIN_HEAP
Date: Sun, 15 Jun 2025 04:23:53 +0800

After reverting the transition to the generic min heap library, bcache no
longer depends on MIN_HEAP.  The select entry can be removed to reduce
code size and shrink the kernel's attack surface.

This change effectively reverts the bcache-related part of commit
92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API
functions").

This is part of a series of changes to address a performance regression
caused by the use of the generic min_heap implementation.

As reported by Robert, bcache now suffers from latency spikes, with P100
(max) latency increasing from 600 ms to 2.4 seconds every 5 minutes. 
These regressions degrade bcache's effectiveness as a low-latency cache
layer and lead to frequent timeouts and application stalls in production
environments.

Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20250614202353.1632957-4-visitorckw@gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Acked-by: Coly Li <colyli@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/bcache/Kconfig~bcache-remove-unnecessary-select-min_heap
+++ a/drivers/md/bcache/Kconfig
@@ -5,7 +5,6 @@ config BCACHE
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	select CLOSURES
-	select MIN_HEAP
 	help
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

