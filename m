Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB0632ABCA
	for <mm-commits@vger.kernel.org>; Mon, 22 Dec 2025 19:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766430731; cv=none; b=tb2aMceue/Nf8P6735/vKhFHkQaX+tPR5RkOa0tO2R7sdBTUkw3U+8lcO3FC/p2rsb+46Aj3aEo+XDfYZrDD9q9RFr84N8oe/ZZ5jp3P4DEqdkzKq97yoe8+NcBCt8sCpJjVec7G+kF6OrTFpSSXAAf/pV1CWjTM62Zib7jVbDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766430731; c=relaxed/simple;
	bh=SXPDQ9eixt91d2OC1YGHK/H2r2IE9Am+lCTkzcb1fSo=;
	h=Date:To:From:Subject:Message-Id; b=MEqBaRdGTNz3+LbE8XJxiQ5exRxTsDpZNR3q6qlvLUR/NUGxBi1hrli4wOQdSoff7NhNdzrR6I6tph0gd/tP4i+Wurvf6oTQF3kZ5V9kRDngx+cWcmQs499769YmG8UniImil6wHNHGi7hidkDPmCnzhGa9am6fE+mYrUbQLx/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tl89kQfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tl89kQfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51515C4CEF1;
	Mon, 22 Dec 2025 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766430731;
	bh=SXPDQ9eixt91d2OC1YGHK/H2r2IE9Am+lCTkzcb1fSo=;
	h=Date:To:From:Subject:From;
	b=tl89kQfR1u5Yk8Q+uxdH9mUDmG1dhflOgXaSxQYcUzUTtXUIzUlSlb4GRjybEIPST
	 Dtc1Vs53N3IMY3Y1mSt+qgWVjLTjZiIN7RX+5CVQyEEPui1yTsVelMm/KbrBlbxmVl
	 AvbGtTZz06AFOfWiecHAPHo7bNdcGUo0PlOTbVbg=
Date: Mon, 22 Dec 2025 11:12:10 -0800
To: mm-commits@vger.kernel.org,arnd@arndb.de,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-uapi-remove-dependency-on-libc.patch added to mm-nonmm-unstable branch
Message-Id: <20251222191211.51515C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/shm: uapi: remove dependency on libc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-shm-uapi-remove-dependency-on-libc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-uapi-remove-dependency-on-libc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: ipc/shm: uapi: remove dependency on libc
Date: Mon, 22 Dec 2025 08:55:10 +0100

Using libc types and headers from the UAPI headers is problematic as it
introduces a dependency on a full C toolchain.  shm.h does not even use
any symbols from the libc header as the usage of getpagesize() was removed
a decade ago in commit 060028bac94b ("ipc/shm.c: increase the defaults for
SHMALL, SHMMAX")

Drop the unnecessary inclusion.

Link: https://lkml.kernel.org/r/20251222-uapi-shm-v1-1-270bb7f75d97@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/uapi/linux/shm.h~ipc-shm-uapi-remove-dependency-on-libc
+++ a/include/uapi/linux/shm.h
@@ -5,9 +5,6 @@
 #include <linux/ipc.h>
 #include <linux/errno.h>
 #include <asm-generic/hugetlb_encode.h>
-#ifndef __KERNEL__
-#include <unistd.h>
-#endif
 
 /*
  * SHMMNI, SHMMAX and SHMALL are default upper limits which can be
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

ipc-shm-uapi-remove-dependency-on-libc.patch

