Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB203750D5
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865941; cv=none; b=HmAJYRhuOsuW+Z2NQkDuaIvfjKg6WRbWbZU5YpD2E4X1e8XeMP8snFHtzPGAxLxckCm5wgTA6mZbUSvxmBIdMMGHE8Xk/wbTyqh5WEVz4fe3VZ09dd5aiC9ye01vnYfuWzmwywC9G/TEgFHyI0MH9UiqdXYgj2B1hhA8opFxxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865941; c=relaxed/simple;
	bh=I7PzHCfpqezJwIpKrKR2KTJMvPqcjOdlsmuttuBVdVY=;
	h=Date:To:From:Subject:Message-Id; b=HxKSKaFs8RHQ1kW++WR+vMVv4NRS4px6qW9ZlHLD1rpveID4G7/itlP7H57Xa983zuWeCzxVeyP3FWMd3NOoJubLwGsTRiennIrb/bCzLydxVw0f/Y7ACfj0z9SkCAuX0D5czVmqdc+6Jq8l+bVvj6T8/4YPOKZgwL2exnF7434=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RgRr8pV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RgRr8pV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2C71F000FF;
	Tue, 13 Oct 2026 04:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865940;
	bh=u4JzTWpPwEEIysp9CiCwcHSH0CcU/wf+CYtZaiMj0/c=;
	h=Date:To:From:Subject;
	b=RgRr8pV024toFutV175ksikRqgF79kgzNsdqjTm0Qh1/xw4YraOJzmo7vefT17eUs
	 z8VjrDq2u3J9cgI2Ckf51TE1D0CjCzlYX7OwHFE854gj8kp8Km7l0q6rbHuM9xi9m0
	 QbQRx/scxfhHqrFP3IlWOPoPlacusSF/0zGBhQKA=
Date: Mon, 12 Oct 2026 21:32:19 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,kas@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_test-safely-calculate-gup-batch-size.patch removed from -mm tree
Message-Id: <20261013043220.0E2C71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup_test: safely calculate GUP batch size
has been removed from the -mm tree.  Its filename was
     mm-gup_test-safely-calculate-gup-batch-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: mm/gup_test: safely calculate GUP batch size
Date: Tue, 15 Sep 2026 15:55:24 +0530

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.  If it
wraps, the next > end check is bypassed and a large value of nr is passed
to the GUP call, even though the pages array was allocated according to
gup->size.  This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages.  The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and the
pages remaining in the address range.  Reject zero sized and non page
aligned gup->size values and zero nr_pages_per_call value.

Link: https://lore.kernel.org/20260915102524.125758-1-sarthak.sharma@arm.com
Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
---

 mm/gup_test.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-safely-calculate-gup-batch-size
+++ a/mm/gup_test.c
@@ -116,7 +116,8 @@ static int __gup_test_ioctl(unsigned int
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -139,11 +140,9 @@ static int __gup_test_ioctl(unsigned int
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are


