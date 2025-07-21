Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096321D3CD
	for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2025 22:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753137863; cv=none; b=QohI7t7JnRXV6whqmWT28sIVt0SkEtgBLepTuW5ad2KJ76/Hqr/2HO0qiw7NyrtZOxT/egYEAE417rSXmvquIVLW+dypuzRNaZR0v74FGpDIw149Ohhz3gcnJJvZ5eSZBs7mUEg7Cfg1aDUz5M39AAurqlOSGb5CqNxwzb8YAsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753137863; c=relaxed/simple;
	bh=IwkCtb4H6w+hU2wsNZdE/Kbm1DO2/vPIpAdS+IF+YUc=;
	h=Date:To:From:Subject:Message-Id; b=bb0sBpaCWvsBIkqnF6BoDFzox/7Cg8e0KiIhgQqQw8OIre2caDCwsCX/bpimQMPAbNS4yh1qDWRtRSZseAAXiNSei+xr1gRWBC4NrdTeSMkxFUo28knAqeuRQJ93qdBtx3LrH7kPdhaKx7rmMc8O2b6LnGFLhMB3r5JZmRd3Uq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t7zaavOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t7zaavOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0982BC4CEED;
	Mon, 21 Jul 2025 22:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753137863;
	bh=IwkCtb4H6w+hU2wsNZdE/Kbm1DO2/vPIpAdS+IF+YUc=;
	h=Date:To:From:Subject:From;
	b=t7zaavOUxywpSyoC8DLukBmcS80fSWQVXREZpwTDxgLbegA3i9KirBt/T3E1c3luN
	 ctsotOmdoLIO6/+0UgPrB2zaqtrB90z7L9i9fxLOdNAuDaRXlBrftoW7leLXPEsXL0
	 ODyQDfrUBjSgpZGGezCDV74JbwHs1lzea59yWRV0=
Date: Mon, 21 Jul 2025 15:44:22 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,paulmck@kernel.org,mengensun@tencent.com,linux@weissschuh.net,legion@kernel.org,ebiederm@xmission.com,bigeasy@linutronix.de,ubizjak@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucount-fix-atomic_long_inc_below-argument-type.patch added to mm-nonmm-unstable branch
Message-Id: <20250721224423.0982BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucount: fix atomic_long_inc_below() argument type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucount-fix-atomic_long_inc_below-argument-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucount-fix-atomic_long_inc_below-argument-type.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: ucount: fix atomic_long_inc_below() argument type
Date: Mon, 21 Jul 2025 19:45:57 +0200

The type of u argument of atomic_long_inc_below() should be long to avoid
unwanted truncation to int.

Link: https://lkml.kernel.org/r/20250721174610.28361-1-ubizjak@gmail.com
Fixes: f9c82a4ea89c ("Increase size of ucounts to atomic_long_t")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: MengEn Sun <mengensun@tencent.com>
Cc: "Thomas Weißschuh" <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/ucount.c~ucount-fix-atomic_long_inc_below-argument-type
+++ a/kernel/ucount.c
@@ -199,7 +199,7 @@ void put_ucounts(struct ucounts *ucounts
 	}
 }
 
-static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
+static inline bool atomic_long_inc_below(atomic_long_t *v, long u)
 {
 	long c, old;
 	c = atomic_long_read(v);
_

Patches currently in -mm which might be from ubizjak@gmail.com are

ucount-fix-atomic_long_inc_below-argument-type.patch
ucount-use-atomic_long_try_cmpxchg-in-atomic_long_inc_below.patch

