Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456100;
	b=S517mktUDId82oXtBteBNhE4bow671D1fdZCx1l0sBwgb/w5aJNOrJcFM6zmQXHf3yI9
	 F/ijFEgvc/Fs3Ddvn8zmIocY6ZlBIYM1CTKNDgwagOwJQcdUgmvKDXHyCFm7J2LrE49SQ
	 NXUUSLtvBC0EenynltJDIlCBP/tKD9PfgMipx8HDEVJA5gdyAcf7aSKwldxW+xbY8A/P7
	 OtdCqAH9hI7OXUQmGQbGWCf2OBKjNGG97bJ2daSO155u4A9oyVEyEuZ/MuEBIK3tpMvd+
	 z0jaZopPCr9aAuT8jayjSQ3dS+wiZFGqfpFUTJ3ybMhP44d67JQ30sLcVPnnEobp/og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456100;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XYT6CaqXQE3esk26vTkd2vqNXRlrBY+zwvKwnnJCP90=;
	b=16YLciUt8N0RgV34d2fpkBzF4E8dy9sp1B2zUlD62PPbZxOffu6xJ6zNqW6sJYsCeLqW
	 R8qNwsWBneIA7PVv7ZHULyfIbDhZ7tV3EbomJIffUwFxDN1qS6QFVII9qhcfQ3OOnoq++
	 Rif+n4Zcyz9bTlO5rM8Pk58CayDC1ywD8lOFOpM+Mu3vYY9t5CJw4Ecg2LY/RF527LDrc
	 PpJnPiRxRiB1BpdwgGkwH7uPIspY/G06lZ1/2Ed9fFg6wQqqDjGm3/aQ/Ms73pl7G+2np
	 2/Ok0tRHjXuqSnfm+kkvf+VNv5NP03HOMyKXVWkBYNOPAxeMM0qceY/bGHkFX889BcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gV4QCwXm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25AB606A31E;
	Mon, 23 Nov 2026 17:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gV4QCwXm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9B91F000D0;
	Mon, 23 Nov 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795456100;
	bh=XYT6CaqXQE3esk26vTkd2vqNXRlrBY+zwvKwnnJCP90=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=gV4QCwXmM6mZ7j5ik+l6KweDsKnSDSEw/iwefcSvZusgqulpMrZnH3Z5h3z1jPa47
	 A4eSk7jAikOQY0Nte6Q4Tyq3fQhZ/1uizfLGg7JaIn1nXAtqd9oKzBRxlVk0DeCk8h
	 FBJr/JpKCNMveCH9Y3IYPoADNUPbQdsWlPWnU9Y8=
Date: Mon, 23 Nov 2026 09:48:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	jm5905938@gmail.com,evanfengff@gmail.com,devnexen@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123150049.81317-2-sj@kernel.org>
References: <20261123150049.81317-2-sj@kernel.org>
Subject: + mm-damon-stat-avoid-32-bit-overflow-in-idle-time-milliseconds.patch added to mm-hotfixes-unstable branch
Message-Id: <20261123174820.1E9B91F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/stat: avoid 32-bit overflow in idle time milliseconds
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-avoid-32-bit-overflow-in-idle-time-milliseconds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-avoid-32-bit-overflow-in-idle-time-milliseconds.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Carlier <devnexen@gmail.com>
Subject: mm/damon/stat: avoid 32-bit overflow in idle time milliseconds
Date: Mon, 23 Nov 2026 07:00:46 -0800

Patch series "mm/damon: three fixes for idle_time overflow and damos_walk()
hang".

Avoid 32-bit overflow of idle time calculation in DAMON_STAT, via
patch 1 from David Carlier.  Fix a damos_walk() hang that can happen
under certain watermarks setup and a watermarks commit internal state
overwrite issue, via patches 2 and 3 from Yifan Feng.

This is a batched reposting of separately posted and reviewed patches
for being merged into the mm.git.  Refer to changelog on each patch for
changes that were made before this reposting.


This patch (of 3):

On 32-bit, the region idle time in microseconds is computed in a long
before the division to milliseconds. It wraps once a region has been
idle for about 36 minutes regardless of the intervals, so the cold end
of memory_idle_ms_percentiles reports wrong values with flipped signs.

Do the multiplication in 64 bits and divide with div_s64() so the sign
of recently accessed regions is kept.

Link: https://lore.kernel.org/20261123150049.81317-1-sj@kernel.org
Link: https://patch.msgid.link/20261123150049.81317-2-sj@kernel.org
Fixes: e5d2585d9e85 ("mm/damon/stat: calculate and expose idle time percentiles")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>
Cc: Yifan Feng <evanfengff@gmail.com>
Cc: <stable@vger.kernel.org>

 mm/damon/stat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-avoid-32-bit-overflow-in-idle-time-milliseconds
+++ a/mm/damon/stat.c
@@ -129,8 +129,8 @@ static void damon_stat_set_idletime_perc
 		accounted_bytes += region->ar.end - region->ar.start;
 		while (next_percentile <= accounted_bytes * 100 / total_sz)
 			memory_idle_ms_percentiles[next_percentile++] =
-				damon_stat_idletime(region) *
-				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
+				div_s64((s64)damon_stat_idletime(region) *
+				c->attrs.aggr_interval, USEC_PER_MSEC);
 	}
 	kfree(sorted_regions);
 }
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-damon-stat-avoid-32-bit-overflow-in-idle-time-milliseconds.patch

