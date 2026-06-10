Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8BC25B08A
	for <mm-commits@vger.kernel.org>; Wed, 10 Jun 2026 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781054845; cv=none; b=QCQRJrmycZWUFNCjaLO2HlrysGuufDkBI8e1/jtzRuV85tTcFCbQtXzFBitmZXTn80s3cWUAmxdCXiju+6JNb5/Sls765imPAO1F6EP1nqwsvHitpFjw0u2jTfO4Du/ZW3EN7ZTK0pYfi5fnQ+YUN3GqbaK9/cEsn86yLFnM6T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781054845; c=relaxed/simple;
	bh=dbBob+B/CEUHPby8RjSvVw2TWqQ9rdDNA3uHgLGj+fg=;
	h=Date:To:From:Subject:Message-Id; b=ucNrBwdXBkLeAMAEBqSMoKmvx5opRcGduUkLsu+sLvAg12wUHJa8CEkiD/a82SYlTrKd/kgDNS9qUq/Ho9ruq6pGwfnWRNVeT5lBwwexKjBzqK/mDX7YCrbEh+qgfMU9fofvpkNju8P7FAL9ZAxhtWYF/V8cyDEzdVVTHY02CP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LM6+/fkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LM6+/fkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CE21F00893;
	Wed, 10 Jun 2026 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781054844;
	bh=BuIrA7ZCs+XGaEhLAeP77ad5JdhxvF95jQ7Xh4IZv+8=;
	h=Date:To:From:Subject;
	b=LM6+/fkBBgDG0KjdWgQtRmXWh3y5QtvFmBM6JzRWHNtLYior367XA0bFsOmnjsYJn
	 27VtwU0QuMGQHAqwXLeYySJ5ioSyyf6Zlb1WYNKpE/JKhdO42BCvD7+zB4sc5SKDM7
	 zIbR2W/+5AG3wPncX9JCtZOclfAtuOhTqF8W2xvE=
Date: Tue, 09 Jun 2026 18:27:23 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-reject-wrapped-user-ranges.patch added to mm-nonmm-unstable branch
Message-Id: <20260610012724.01CE21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup_test: reject wrapped user ranges
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-gup_test-reject-wrapped-user-ranges.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-reject-wrapped-user-ranges.patch

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
Cc: David Hildenbrand <david@kernel.org>
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

mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch
lib-test_firmware-allocate-the-configured-into_buf-size.patch
lib-interval_tree_test-validate-benchmark-parameters.patch
mm-gup_test-reject-wrapped-user-ranges.patch

