Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1913D965
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882967; cv=none; b=T7LW0EwMiOZktNRU4Gdj3dSSn0gihEjGHwKGNcIgRsUfy6IxnlVDl8Tj33V1Q15MyZVkF5t6T5ZTwU/lkMeOTQz7hi2vfQbEfOlNrwuVgZqKeN31pLF8zptqVEGgKprMJgfeTp7P3ADaTjA3AOTvIRxg/HlUnSOYEDAT1sDbUW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882967; c=relaxed/simple;
	bh=fMdGhFRxoQJBow+LCtm0NVg9sxPdgWkHLN+fuP248lc=;
	h=Date:To:From:Subject:Message-Id; b=jFKxssgZu4v7iLXcLsAqLr3zlpe+QUsNsPm4WhQXxWN4M1lU2PVmrHjiOloLsHklGHtQon54bfVpVJAe7zGcj1ik+2oTQ+3vwCP6eh2ZMPaODCcU73R+vNhHcyaFB6Ef0acGVHhoMze4vMjUR9HypMlQts9UGuKQr7u0zzKlGk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CN6Ew3wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CN6Ew3wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B30C43390;
	Tue, 19 Mar 2024 21:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882966;
	bh=fMdGhFRxoQJBow+LCtm0NVg9sxPdgWkHLN+fuP248lc=;
	h=Date:To:From:Subject:From;
	b=CN6Ew3wafAq3vmTCSTnOlL4IA2NZa+o0ev9zU2eMUSm6vdHW73mFgsP8q7RyCrsJ3
	 Ewjz2dexuXfyZJF21d6Zl4liqflCvaKoaIJVfjJ+Q/HE8fld9I3/LAxY4SjTdD0inl
	 xWGGgUEOx9SC//LHwMaJa9RAfBR38FKcTt56MvSc=
Date: Tue, 19 Mar 2024 14:16:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,peterx@redhat.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,l.stach@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-control-latency-caused-by-zone-pcp-draining.patch added to mm-unstable branch
Message-Id: <20240319211606.60B30C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: control latency caused by zone PCP draining
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-control-latency-caused-by-zone-pcp-draining.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-control-latency-caused-by-zone-pcp-draining.patch

This patch will later appear in the mm-unstable branch at
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
From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm: page_alloc: control latency caused by zone PCP draining
Date: Mon, 18 Mar 2024 21:07:36 +0100

Patch series "mm/treewide: Remove pXd_huge() API", v2.

In previous work [1], we removed the pXd_large() API, which is arch
specific.  This patchset further removes the hugetlb pXd_huge() API.

Hugetlb was never special on creating huge mappings when compared with
other huge mappings.  Having a standalone API just to detect such pgtable
entries is more or less redundant, especially after the pXd_leaf() API set
is introduced with/without CONFIG_HUGETLB_PAGE.

When looking at this problem, a few issues are also exposed that we don't
have a clear definition of the *_huge() variance API.  This patchset
started by cleaning these issues first, then replace all *_huge() users to
use *_leaf(), then drop all *_huge() code.

On x86/sparc, swap entries will be reported "true" in pXd_huge(), while
for all the rest archs they're reported "false" instead.  This part is
done in patch 1-5, in which I suspect patch 1 can be seen as a bug fix,
but I'll leave that to hmm experts to decide.

Besides, there are three archs (arm, arm64, powerpc) that have slightly
different definitions between the *_huge() v.s.  *_leaf() variances.  I
tackled them separately so that it'll be easier for arch experts to chim
in when necessary.  This part is done in patch 6-9.

The final patches 10-14 do the rest on the final removal, since *_leaf()
will be the ultimate API in the future, and we seem to have quite some
confusions on how *_huge() APIs can be defined, provide a rich comment for
*_leaf() API set to define them properly to avoid future misuse, and
hopefully that'll also help new archs to start support huge mappings and
avoid traps (like either swap entries, or PROT_NONE entry checks).

[1] https://lore.kernel.org/r/20240305043750.93762-1-peterx@redhat.com


This patch (of 14):

When the complete PCP is drained a much larger number of pages than the
usual batch size might be freed at once, causing large IRQ and preemption
latency spikes, as they are all freed while holding the pcp and zone
spinlocks.

To avoid those latency spikes, limit the number of pages freed in a single
bulk operation to common batch limits.

Link: https://lkml.kernel.org/r/20240318200404.448346-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240318200736.2835502-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-control-latency-caused-by-zone-pcp-draining
+++ a/mm/page_alloc.c
@@ -2216,12 +2216,15 @@ void drain_zone_pages(struct zone *zone,
  */
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
-	struct per_cpu_pages *pcp;
+	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+	int count = READ_ONCE(pcp->count);
+
+	while (count) {
+		int to_drain = min(count, pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
+		count -= to_drain;
 
-	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	if (pcp->count) {
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, pcp->count, pcp, 0);
+		free_pcppages_bulk(zone, to_drain, pcp, 0);
 		spin_unlock(&pcp->lock);
 	}
 }
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

mm-page_alloc-control-latency-caused-by-zone-pcp-draining.patch

