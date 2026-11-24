Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540591;
	b=D+FlOCOmn0N37sCa9hN7iS0UiZvov9Kdf9vZsVMaCB3D+Nx7yQZTkF7w5jc5RRpFPbEc
	 hgu2LSPI2RLu+dep8dfHO0fyuFLmROoBvwHGsK4f+4z063dKnQq9bzH+Ex7dnL1N6wG5N
	 RUQd4LB42QxJ1NEVhBCOVDpJI+9ulieYroNeSI0p0yGjBHZ318orN6PWjgoJyNjPSLb5S
	 JqvmpRxrBap3Jw2xNWwShxi+fiBpTrP94iJDv21TEnIikqUS/oRDNl/r1ZUBp0iswPlPd
	 DanFbrzvGOsGWeWTMBCmrOZb1mbOH+lwM0wicggzBliue6FR8OE5TUJfhKc1elfJjHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540591;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ZboCA09FI5iFGDNcW/Ig2xkj7O4ITX+6jeVm112mQdM=;
	b=DhGLnDKFloKxuTz8OLrMndKLUJhIKeaX+o8x94hgBfPIfF6kctz8utDMs42rne/HdpzP
	 k5o2V7ZhK5S75xAGriid7Pi6UReyv4qAieXiPzJrFrkM70jjK+DGG/HgefZXYygnBBsq6
	 Pr/jGjVcIwjIsXVazYbX8fizqeF6E63pk77dsQ/6zsUwYzjXtkfJSeWZ2pBy6pttaez3a
	 ZM+U7i4B2UMBYPdf0wPFpC8fGTSZA/6CnjT3wy6vOrygFmVZotyRGWfNffnBxM2q1OG7H
	 QV6aU4jHIcih5bG8phNxrKtbv1fOM+mDgVZLJ4TenjQ+GTlgwBRnNUapOnys56eNCIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=meH7vDUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C204606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=meH7vDUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB591F000D4;
	Tue, 24 Nov 2026 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540590;
	bh=ZboCA09FI5iFGDNcW/Ig2xkj7O4ITX+6jeVm112mQdM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=meH7vDUI3H1+/Xn6L/XQshL7y6bxFchTuHFl4ylU8Dh/KZLBJXDv6lU3sSxyUFqUx
	 p33vBlmxRm1cotCUxsB+oPDR0jN0ULMRkFQcHzRlAfUgDcpDwYtAFVUJa5PmxLcgi1
	 8C/zZ7y7npZQTRvgDhPD1UnC0Ga54e1eSxx1b4yg=
Date: Tue, 24 Nov 2026 09:16:30 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,saileshnandanavanam@gmail.com,
	lienze@kylinos.cn,jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153021.90142-2-sj@kernel.org>
References: <20261124153021.90142-2-sj@kernel.org>
Subject: + mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout.patch added to mm-new branch
Message-Id: <20261124171630.9AB591F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/paddr: skip non-LRU folios as a whole in pageout
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/paddr: skip non-LRU folios as a whole in pageout
Date: Tue, 24 Nov 2026 07:30:17 -0800

Patch series "mm/damon: improve efficiency (paddr, core), fix a selftest,
add a kunit".

Improve efficiency of DAMOS_PAGEOUT in paddr and apply_probes() in core
by skipping unnecessary operations, via patches 1 and 2 from Aveline
Noir.  Fix a selftest for a false positive failure, via patch 3 from
Aveline Noir.  Add a kunit test for damon_call(), via patch 4 from
Sailesh Nandanavanam.

This is a batched reposting of separately posted and reviewed patches
for being merged into the mm.git.  Refer to changelog on each patch for
changes that were made before this reposting.


This patch (of 4):

damon_pa_pageout() uses damon_get_folio(), which rejects folios that are
not on the LRU.  For a large non-LRU folio such as a hugetlb folio, the
loop then looks up the same folio once per base page even though
pageout cannot reclaim it.

Use damon_get_monitor_folio() and skip any returned non-LRU folio as a
whole by advancing to its end.  Do this before the filters, the
accounting and the last_applied check, so that adjacent regions within
the same non-LRU folio are not walked by base page either.

In an x86-64 KVM pageout microbenchmark, traversal time dropped by
about 99.7% for regions covering whole 2 MiB hugetlb folios. For
4 KiB regions within hugetlb folios, traversal took about 1 ns more
per region.

Link: https://lore.kernel.org/20261124153021.90142-1-sj@kernel.org
Link: https://patch.msgid.link/20261124153021.90142-2-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>

 mm/damon/paddr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout
+++ a/mm/damon/paddr.c
@@ -268,7 +268,9 @@ static unsigned long damon_pa_pageout(st
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
-		folio = damon_get_folio(PHYS_PFN(addr));
+		folio = damon_get_monitor_folio(PHYS_PFN(addr));
+		if (folio && !folio_test_lru(folio))
+			goto put_folio;
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch
mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch
mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout.patch
mm-damon-core-skip-apply_probes-when-no-probes-are-installed.patch
selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds.patch

