Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3081A255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744895; cv=none; b=fzcKPW3oFnY84NpvKkc0sLKq38F9B0lJy1BNmiolmiGWEs44It7YunR85L/firVqEsuPh3whJG5t/n8xLDpf4MbZCor4Lb2702jdyT2eon30G/e4dFXpGsafHyeB1z2q7uvGl9CuzJzAgjU1+ssC96HxYBRaatwsVCtcDPgSNTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744895; c=relaxed/simple;
	bh=JJq1o0W3RKDUldjBC5SURh5nYHzxD3N8RatE0HgpPls=;
	h=Date:To:From:Subject:Message-Id; b=sezcPZqX1CgCChOQl4eRxrvWqxZaCBf9b5p2UDSFxfRYqf5jpf4b20nDDZdm1x4G2ggBhbVsgMN6MkyXQCPZNJC49KaeEldG6hIUOAxDNwn6HBP3hQYma2Y4dn80paiKSw92EzXmjPCCZbk23fknXnIbk6ZkWSS/1j95mK+i8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qs3fYl73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qs3fYl73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084C4C4CEF7;
	Sun, 29 Mar 2026 00:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744895;
	bh=JJq1o0W3RKDUldjBC5SURh5nYHzxD3N8RatE0HgpPls=;
	h=Date:To:From:Subject:From;
	b=qs3fYl73ClEtB5k68BjR6jI3Wn/9j8dj5SLxuS5yItezp+BUO1DgPWzkrDRBZdNIt
	 I/n0baF0Vvwyz5kNRGd361iJ75mssF/bCyWTa3Z4bhiEaobwYUjzTkZQPj7tWWLL6J
	 Db+FV4MaSIG6/4LRejvuk9Xd/b4yxS3k5SJdK3m8=
Date: Sat, 28 Mar 2026 17:41:34 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch removed from -mm tree
Message-Id: <20260329004135.084C4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
Date: Tue, 10 Mar 2026 22:29:23 -0700

damon_find_biggest_system_ram() sets an 'unsigned long' variable with
'resource_size_t' value.  This is fundamentally wrong.  On environments
such as ARM 32 bit machines having LPAE (Large Physical Address
Extensions), which DAMON supports, the size of 'unsigned long' may be
smaller than that of 'resource_size_t'.  It is safe, though, since we
restrict the walk to be done only up to ULONG_MAX.

DAMON supports the address size gap using 'addr_unit'.  We didn't add the
support to the function, just to make the initial support change small. 
Now the support is reasonably settled.  This kind of gap is only making
the code inconsistent and easy to be confused.  Add the support of
'addr_unit' to the function, by letting callers pass the 'addr_unit' and
handling it in the function.  All callers are passing 'addr_unit' 1,
though, to keep the old behavior.

[sj@kernel.org: verify found biggest system ram]
  Link: https://lkml.kernel.org/r/20260317144725.88524-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260311052927.93921-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram
+++ a/mm/damon/core.c
@@ -3064,31 +3064,43 @@ done:
 
 static int walk_system_ram(struct resource *res, void *arg)
 {
-	struct damon_addr_range *a = arg;
+	struct resource *a = arg;
 
-	if (a->end - a->start < resource_size(res)) {
+	if (resource_size(a) < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end + 1;
+		a->end = res->end;
 	}
 	return 0;
 }
 
+static unsigned long damon_res_to_core_addr(resource_size_t ra,
+		unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(ra, addr_unit);
+	return ra / addr_unit;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
  */
 static bool damon_find_biggest_system_ram(unsigned long *start,
-						unsigned long *end)
+		unsigned long *end, unsigned long addr_unit)
 
 {
-	struct damon_addr_range arg = {};
+	struct resource res = {};
 
-	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
-	if (arg.end <= arg.start)
+	walk_system_ram_res(0, -1, &res, walk_system_ram);
+	*start = damon_res_to_core_addr(res.start, addr_unit);
+	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
+	if (*end <= *start)
 		return false;
-
-	*start = arg.start;
-	*end = arg.end;
 	return true;
 }
 
@@ -3118,7 +3130,7 @@ int damon_set_region_biggest_system_ram_
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end))
+		!damon_find_biggest_system_ram(start, end, 1))
 		return -EINVAL;
 
 	addr_range.start = *start;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

