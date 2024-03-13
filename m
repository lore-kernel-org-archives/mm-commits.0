Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0447133996
	for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2024 19:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710357183; cv=none; b=SrPC3zIZvAKHRscgcqfiOIE/aExp81KHnq+aFGnStPCaW8yGNAc4vjNMibZZTVklrc/NrxsWt/VkvchsoR7P50xFv1Tzwy+nopdZxyLcj0dV3o5WrsMcU29ofRmRIVbBme4WEJ2FF/sefrxC22PTxEnuO1pDGN6sI4B5I6qliaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710357183; c=relaxed/simple;
	bh=1L1sAD5lQEV5Hlp6eALDFfAkUuH7kVjwk52WgPDniXA=;
	h=Date:To:From:Subject:Message-Id; b=lx+5Svl44biLgfWg9e5Mpz4GCcL6tyWoSQE4I1C+jM4EzSWR4iXTKAWcwJH4gLsDA4l/oAeDj6pX7kSSTVA6rSFU9GS2qaJi2hNmuTCfHirGiAZ8aijeuTg0LeoHB/u62L2Btt2FEqDMg43EM8vllQLbCdpPetFfB+ccUINyMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZAmcYiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZAmcYiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC97C43390;
	Wed, 13 Mar 2024 19:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710357182;
	bh=1L1sAD5lQEV5Hlp6eALDFfAkUuH7kVjwk52WgPDniXA=;
	h=Date:To:From:Subject:From;
	b=SZAmcYiGcbKvdNIXJl02cvLvWtu0Lpq6oMAbXc6VmdrkvlMKtGtFoHHhpYGPr3iu8
	 bifaPJLfaQsslyvpuKiLLHRIUkXAv6l8k6qORQoXxK7phOpBsJUHQXsbgSjc2cx/MH
	 r1W6E4orrbOeqGzUE6KTqeaK9xqds7L7Z6IYeLS4=
Date: Wed, 13 Mar 2024 12:13:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lkp@intel.com,jgg@nvidia.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-recover-pud_leaf-definitions-in-nopmd-case.patch removed from -mm tree
Message-Id: <20240313191302.6AC97C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: recover pud_leaf() definitions in nopmd case
has been removed from the -mm tree.  Its filename was
     mm-recover-pud_leaf-definitions-in-nopmd-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: recover pud_leaf() definitions in nopmd case
Date: Mon, 11 Mar 2024 12:10:45 -0400

This reverts one change in commit 924bd6a8c967 ("mm/x86: drop two
unnecessary pud_leaf() definitions").

One issue with that is it broke nopmd builds for at least both arm64 and
riscv (CONFIG_PGTABLE_LEVELS=2).  The other issue is it was overlooked that
it's a common change rather than x86 specific (relevant to the commit
message of the commit).

Normally there's no need for empty definition of pXd_leaf() because of the
fallback functions, however this logic may not apply to pgtable-nopmd.h,
because that's a header that can even be used by arch *pgtable.h headers,
which can use the *_leaf() definitions _before_ the fallback functions are
defined.  Leave it there to pass PGTABLE_LEVELS=2 builds.

Link: https://lkml.kernel.org/r/Ze8vFNV9YSdgC2S7@x1n
Fixes: 924bd6a8c967 ("mm/x86: drop two unnecessary pud_leaf() definitions")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403090900.OwPqmRuI-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202403101607.a42gaLOS-lkp@intel.com/
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable-nopmd.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/pgtable-nopmd.h~mm-recover-pud_leaf-definitions-in-nopmd-case
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -31,6 +31,7 @@ static inline int pud_none(pud_t pud)		{
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
+static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
_

Patches currently in -mm which might be from peterx@redhat.com are


