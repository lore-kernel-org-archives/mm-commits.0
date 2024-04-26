Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7885E74E0C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100617; cv=none; b=kC9pUqIKtAFArTWyTNBUBjGVFG6XyCYOKmuMFDXUmFR+z98CQmY0PBST/v9xyh3Ha9DhiIT/u9XnotAlVHgApbkTZhjpkCoOFMrMKSLYHSkaYgJr0WiZ73vkgwGLwECqL8xJi2m2qIpAbC+lcF6Lbi01+XXpGNAsCVNumBex3m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100617; c=relaxed/simple;
	bh=rSEatG+BFiRYnP+KWh/IDuyGFXBecV722vnv5H0dyPY=;
	h=Date:To:From:Subject:Message-Id; b=kgF57ZbGd4JnclwvK/uNC+87QxuqnBfdyZBDQLFPOtPLdtrbL2bW+2orCmXWtEDZxomoKUZsFGdRJWSvDbU+0511OqhJURvq7fqtFQOdPvBDqzMdpjMugQ4EsHP6h6ht2Dxe3dSupxzwDwrTlVouZuzVGJenhkOAYObdj1vCHWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=As/S2R1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="As/S2R1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE5C2BBFC;
	Fri, 26 Apr 2024 03:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100616;
	bh=rSEatG+BFiRYnP+KWh/IDuyGFXBecV722vnv5H0dyPY=;
	h=Date:To:From:Subject:From;
	b=As/S2R1ztgd7CdJFCKw/taNJlMjvGjeyWkhnG5A9Kswn3MftuEv8ieQHiR1aK0TUT
	 4zUtL10PA7jCx56vX683vUzT+DsThtzEZH2uqAXjsDa+w/YS/nFk//TPrwQliJPJ9e
	 UfZFpKu0COOjZH29uKviT49Of9osMsSBCMI3ObV0=
Date: Thu, 25 Apr 2024 20:03:36 -0700
To: mm-commits@vger.kernel.org,aneesh.kumar@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3.patch removed from -mm tree
Message-Id: <20240426030336.D4EE5C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3.patch

This patch was dropped because it was folded into mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3
Date: Thu, 21 Mar 2024 06:29:50 -0500

add "* @vmf: structure describing the fault" comment for mpol_misplaced()
to fix the warning.  

Link: https://lkml.kernel.org/r/d8b993ea9dccfac0bc3ed61d3a81f4ac5f376e46.1711002865.git.donettom@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node-v3
+++ a/mm/mempolicy.c
@@ -2718,7 +2718,7 @@ static void sp_free(struct sp_node *n)
  * mpol_misplaced - check whether current folio node is valid in policy
  *
  * @folio: folio to be checked
- * @vma: vm area where folio mapped
+ * @vmf: structure describing the fault
  * @addr: virtual address in @vma for shared policy lookup and interleave policy
  *
  * Lookup current policy node id for vma,addr and "compare to" folio's
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-mempolicy-use-numa_node_id-instead-of-cpu_to_node.patch
mm-numa_balancing-allow-migrate-on-protnone-reference-with-mpol_preferred_many-policy.patch

