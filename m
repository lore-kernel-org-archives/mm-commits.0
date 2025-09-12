Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92424EF76
	for <mm-commits@vger.kernel.org>; Fri, 12 Sep 2025 23:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757718318; cv=none; b=gKKQvPGWeX0ayeBEa3DcE37dnUC/T2dNdpci/PGB4GNzFqOH0gQxr6DhKOhnr+bBh3DIIIOuiV/RePKukUR7/2IG1zElOsYdXuK+Ck4gW1qcptlvkKU+eOOpt+tGF7d6xDBzGvDj6Tm+heKcgwket8XYbLduPfNKID/dpylFcgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757718318; c=relaxed/simple;
	bh=leq3zg615cez0Aw2Vd7dHjDF1Qq2ZnKE1HAiuzfYx4Q=;
	h=Date:To:From:Subject:Message-Id; b=TLWjJVr43iM3y6M498Eb7MrnhFjWZweMlUf0Ss6lWzNdUJ7pzly8seHOTn+fO/ZF3k2WhX7Mrsg1ItMkko6EedaAy0ahZS+WrdTkElSNArOESTjhHh0upupMjrfzjdJ5jgr/z7wxdDW3aCy3PfBWXO58Z5wFffvaMZx4abDPlqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VNNF+WuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VNNF+WuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E3FC4CEF5;
	Fri, 12 Sep 2025 23:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757718317;
	bh=leq3zg615cez0Aw2Vd7dHjDF1Qq2ZnKE1HAiuzfYx4Q=;
	h=Date:To:From:Subject:From;
	b=VNNF+WuLaR9Of714WtXyPxVNYCm1HsJxWe2KaPu+JayailKAar2oDxbJNPD8o4jOH
	 n6WQXizMSrPEWFXPNmk+zqqFil9xu5QaB2kk1rimb8oCI+ZjtaI+89IFBc1brfg2hv
	 6k/ohhe3tsyxLpVjkBFw9tw1NqLpp8lZgOvLxsR0=
Date: Fri, 12 Sep 2025 16:05:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kevin.brodsky@arm.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-fix-dead-code.patch added to mm-new branch
Message-Id: <20250912230517.B9E3FC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: protection_keys: fix dead code
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-protection_keys-fix-dead-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-fix-dead-code.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: protection_keys: fix dead code
Date: Fri, 12 Sep 2025 17:30:22 +0500

The while loop doesn't execute and following warning gets generated:

protection_keys.c:561:15: warning: code will never be executed
[-Wunreachable-code]
                int rpkey = alloc_random_pkey();

Let's enable the while loop such that it gets executed nr_iterations
times. Simplify the code a bit as well.

Link: https://lkml.kernel.org/r/20250912123025.1271051-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-fix-dead-code
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -557,13 +557,11 @@ int mprotect_pkey(void *ptr, size_t size
 	int nr_iterations = random() % 100;
 	int ret;
 
-	while (0) {
+	while (nr_iterations-- >= 0) {
 		int rpkey = alloc_random_pkey();
 		ret = sys_mprotect_pkey(ptr, size, orig_prot, pkey);
 		dprintf1("sys_mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
 				ptr, size, orig_prot, pkey, ret);
-		if (nr_iterations-- < 0)
-			break;
 
 		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
 			" shadow: 0x%016llx\n",
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-centralize-the-__always_unused-macro.patch
selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch

