Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DE334CDD
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731312955; cv=none; b=QNTt3qUA1FIEZ6YPCCP3VOnaLoSSDEbAKZWdoni0TlF71Kzu6AIrDQ/+wRRx/BaQB61cx2AEDg1y7+DFMihfGN6VfPsC6ZZu15YC2eIALhMntLeTAnsDOfZXZw+n6Tl9gbfLEEq4SfUWaKTL8uz6KYz9/4NsiB27VmwRy1BBRk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731312955; c=relaxed/simple;
	bh=H9Ft0qLekf4aPLO4atQykCyKauk2cLXOUyuiDogD6bA=;
	h=Date:To:From:Subject:Message-Id; b=gZcgmpCQEWKi2RK2NGrvkeqc15CWO7nFIQkG7UA1PpFHQG5sc1mhrZUWmucjDaCKeO9rWmu3V1DhSbBDDu15uUnqe5lq258FRQ8rvNcuMwERETHpwVrHAt5XYsPYHdlZnp7KKhVLkYzzOIzySPQE4v4+3w76MzoNoU1/JuiHhNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=deU2VmhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="deU2VmhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6617C4CED0;
	Mon, 11 Nov 2024 08:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731312955;
	bh=H9Ft0qLekf4aPLO4atQykCyKauk2cLXOUyuiDogD6bA=;
	h=Date:To:From:Subject:From;
	b=deU2VmhRGyoJpkq8IzW7eNS63DyKVhCN6m44H9jYvsKCe5JGj/v+O3j2lbkAhUm80
	 mhCaPHcGyTLusStgxE2IMT+uP2l6NSMsmEWFnL3S/D+nXh1FzKF1dpDLzDWwzoGwss
	 n5GOAJGjCFScj6sNNW3BXbauo9fg2xjyFv1DCB/8=
Date: Mon, 11 Nov 2024 00:15:53 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-per-order-mthp-swpin-counters-v2.patch removed from -mm tree
Message-Id: <20241111081554.D6617C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-per-order-mthp-swpin-counters-v2
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-swpin-counters-v2.patch

This patch was dropped because it was folded into mm-add-per-order-mthp-swpin-counters.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm-add-per-order-mthp-swpin-counters-v2
Date: Thu, 31 Oct 2024 12:34:23 +1300

add a blank line in doc

Link: https://lkml.kernel.org/r/20241030233423.80759-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-per-order-mthp-swpin-counters-v2
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -533,6 +533,7 @@ anon_fault_fallback_charge
 zswpout
 	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
+
 swpin
 	is incremented every time a huge page is swapped in from a non-zswap
 	swap device in one piece.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-add-per-order-mthp-swpin-counters.patch

