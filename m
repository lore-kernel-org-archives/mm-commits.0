Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415090;
	b=uZsVjPT+2dtg6tHpkFzAiJA+4xL/pmpv7JR7U8AXvZj8aju9bd6OPn+V/S3o4NMeUJ6Z
	 2kKoDkK2wnLNW0N7RVXOeTbk553KoZ+7jt7JQPxaSqqL7GJTwlx+13YGJq//VrQucgGzl
	 BsM226w8mx4rIQuQ6yiIsslEoiel3uKBkFJRD4lbYrYOXFg7NJWby5xq+8kWCouP2iMIg
	 bdqhciAairXwPHqXVlrZAgHiwAZbYzvS5UjTq4562zgFYanPcbUyejo7bMQ9SDa+3oe0f
	 8VjnIKp99Ro1YAgmet5KSIKMQ8+cyjsnD8ATszceSGdzr00U0Lq2etElOSuwLiat1qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415090;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fdKEs/QDkbO7PjhUkImioFqWR6yDrBXWLl28FOm4Ezs=;
	b=Yi7FxVYQKxxjyGcWoMdIazeY62NhRH479DM+sg5vAM7Q692gAGdJ53T+0eSN+/dGNmEX
	 atEQ6NJO2QQpDfzzddxpj88s1UKMVxMZtlxta9jR+TCaibhoM5g6idBRCx8egcwyF3WdQ
	 U8pppYeuhWpxXNzHIocxSM2C39Abjormup/1LhMzUgPGLtRdOVZIM1X4n9kZtJWTdtM6m
	 xyIXo9Onm1afhOPiQeRiYypPnW/FWi0JeA7q1QdyTH8EUcRoErpxw+yHwd7Wt7Y1R57JQ
	 iaisknzPPOqN80TmFqa399MOmjrzn+nIEm4M8GYQgyTR9Ossf1j89TsBHxBF5+QZOmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=upZ5uSmW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47044606A31E;
	Mon, 23 Nov 2026 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=upZ5uSmW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B604B1F000D0;
	Mon, 23 Nov 2026 06:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415089;
	bh=fdKEs/QDkbO7PjhUkImioFqWR6yDrBXWLl28FOm4Ezs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=upZ5uSmWkIFoCxhWC/dWgcRa9knXqwpVV8FIIGZ/2MCQfrdF8OmK8mSAQjIQXf3p1
	 Kqok6qoMjCvKjpy5g9GmVxCedvSptaHZSnUqIT8l3zjIqa75o6mxjW3AUuIkK6V0DE
	 y1dwPm/7fFtlX4B18Rm0C43OyoZF+7gaj63cdK88=
Date: Sun, 22 Nov 2026 22:24:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	gkwang@linx-info.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261110004816.100066-1-sj@kernel.org>
References: <20261110004816.100066-1-sj@kernel.org>
Subject: [merged mm-hotfixes-stable] mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation.patch removed from -mm tree
Message-Id: <20261123062449.B604B1F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Guangke <gkwang@linx-info.com>
Subject: mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Mon,  9 Nov 2026 16:48:14 -0800

estimated_memory_bandwidth is calculated by access_bytes * USEC_PER_MSEC *
MSEC_PER_SEC (= USEC_PER_SEC) / aggr_interval, and users read it via
/sys/module/damon_stat/parameters/estimated_memory_bandwidth.

On 32-bit systems, access_bytes * USEC_PER_SEC overflows unsigned long
once access_bytes exceeds about 4294 (U32_MAX / USEC_PER_SEC), so users
get a wrong value.

Fix it by doing the calculation in 64-bit and splitting the division into
quotient and remainder.

The issue was reproduced on a 32-bit system (qemu-system-i386): the
parameter estimated_memory_bandwidth reported 362 instead of the expected
1926150; with the fix, the value matches the expectation.

Link: https://patch.msgid.link/20261110004816.100066-1-sj@kernel.org
Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Signed-off-by: Wang Guangke <gkwang@linx-info.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>

 mm/damon/stat.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-avoid-overflow-in-estimated_memory_bandwidth-calculation
+++ a/mm/damon/stat.c
@@ -32,8 +32,8 @@ static bool enabled __read_mostly = IS_E
 module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
-static unsigned long estimated_memory_bandwidth __read_mostly;
-module_param(estimated_memory_bandwidth, ulong, 0400);
+static u64 estimated_memory_bandwidth __read_mostly;
+module_param(estimated_memory_bandwidth, ullong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
@@ -55,15 +55,18 @@ static void damon_stat_set_estimated_mem
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long access_bytes = 0;
+	u64 access_bytes = 0;
+	u64 remainder, bytes_per_us;
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t)
-			access_bytes += (r->ar.end - r->ar.start) *
+			access_bytes += (u64)(r->ar.end - r->ar.start) *
 				r->nr_accesses;
 	}
-	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
-		MSEC_PER_SEC / c->attrs.aggr_interval;
+	bytes_per_us = div64_u64_rem(access_bytes,
+			c->attrs.aggr_interval, &remainder);
+	estimated_memory_bandwidth = bytes_per_us * USEC_PER_SEC +
+		div64_u64(remainder * USEC_PER_SEC, c->attrs.aggr_interval);
 }
 
 static int damon_stat_idletime(const struct damon_region *r)
_

Patches currently in -mm which might be from gkwang@linx-info.com are


