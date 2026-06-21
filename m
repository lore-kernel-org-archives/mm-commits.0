Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B554370ADF
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067220; cv=none; b=hOfVrfSs+BdnrPSTn9hEZl92vdBo5Rj4Fgn3gCPMUz3/B0iZcQWx6R7QCnW0FKue4GcSwsa8VHiqK917teoBEYCsdvulwnc1GDG5D1PaZ2VWgqASJTRf392aJkcj23jKOcOgOs15n1gKlpVGK1D6sDKKCvvpVf0qcvzLeSB+Jew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067220; c=relaxed/simple;
	bh=xy15blx3vA8OMdEzAmrg4rOWoiqzuDCZIIbNqmMUEuU=;
	h=Date:To:From:Subject:Message-Id; b=VJtAINMbEYYFgoz/EeMkHuLTsqlWIJl9PpjXsC4kzGXuUno36BEyAePRT/OV6KJsxWdfy8twkZYlfxgkb7o9eEH4b80X8r+R5Ja5YqTjXp/8c87RYS1nnGGMfJdPvqTwQvfbPQKWHaG5NrQOi85bGSiL9fyhxhE04z0T9V+/daU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DG1B6Xrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DG1B6Xrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AD51F000E9;
	Sun, 21 Jun 2026 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067219;
	bh=uSLyld5T5hVG2D9k8ezn5lbjlWMLbhRRAFCa48evRYk=;
	h=Date:To:From:Subject;
	b=DG1B6XrzYrGwW8TId5x+xfccofQycOUpU0dlu5Xk21ZKOkNu0qybc9OKCbQHRpQcD
	 OLbET8oMYRALKirxS/s68zDkNbYgocwi34J9Np9jYzsODtnsRkVS8pt0TxbjGeak+w
	 d9sqAnlR9RWnkkr3qp+yMOjhBUkFl9gwvTRJFwNg=
Date: Sun, 21 Jun 2026 11:40:18 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup_test-reject-wrapped-user-ranges.patch removed from -mm tree
Message-Id: <20260621184019.30AD51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup_test: reject wrapped user ranges
has been removed from the -mm tree.  Its filename was
     mm-gup_test-reject-wrapped-user-ranges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Moelius <sam.moelius@trailofbits.com>
Subject: mm/gup_test: reject wrapped user ranges
Date: Tue, 9 Jun 2026 00:48:15 +0000

gup_test accepts an address and size from the debugfs ioctl and repeatedly
compares against addr + size.  If that addition wraps, the loop can be
skipped and the ioctl returns success with size rewritten to zero.

Compute the end address once with overflow checking and use that checked
end for the loop bounds.

Assisted-by: Codex:gpt-5.5-cyber-preview
Link: https://lore.kernel.org/20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/gup_test.c~mm-gup_test-reject-wrapped-user-ranges
+++ a/mm/gup_test.c
@@ -105,11 +105,15 @@ static int __gup_test_ioctl(unsigned int
 	unsigned long i, nr_pages, addr, next;
 	long nr;
 	struct page **pages;
+	unsigned long end;
 	int ret = 0;
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+		return -EINVAL;
+	if (check_add_overflow((unsigned long)gup->addr,
+			       (unsigned long)gup->size, &end))
 		return -EINVAL;
 
 	nr_pages = gup->size / PAGE_SIZE;
@@ -125,13 +129,13 @@ static int __gup_test_ioctl(unsigned int
 	i = 0;
 	nr = gup->nr_pages_per_call;
 	start_time = ktime_get();
-	for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
+	for (addr = gup->addr; addr < end; addr = next) {
 		if (nr != gup->nr_pages_per_call)
 			break;
 
 		next = addr + nr * PAGE_SIZE;
-		if (next > gup->addr + gup->size) {
-			next = gup->addr + gup->size;
+		if (next > end) {
+			next = end;
 			nr = (next - addr) / PAGE_SIZE;
 		}
 
_

Patches currently in -mm which might be from sam.moelius@trailofbits.com are


