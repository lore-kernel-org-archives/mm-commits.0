Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEDA27281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490003; cv=none; b=Ss/HF1Qsttg6XUKWRVPkNkE2viFVAmLC5/Ww3V4920BFkRCYigyQDU9Bf7YL4oc+gxYz13PlALUBBEPSApfuLoS4xaEpzagU7nBZ5UNKT4t/XdoROTmNdT+RHEGgKFTz7BMVD0TcCRZKtD0IG38s+pctI073w1oO6uPHfcDoq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490003; c=relaxed/simple;
	bh=J9KLL+Df2xnN/znbP3sthIhfuPWKdF2/lW3k02SM3MU=;
	h=Date:To:From:Subject:Message-Id; b=FN2srBh3/X4zWMObr4ILf4IwtHuKwoFvfkybwEOdvlUmZ9fls8nr1NFUb24QAhbL1zrribhsFr4CzNIOztrxPk3Q8PgZ6DN5c9O69fIR++wfoIb4DnyDP4vyVPHLfkRfnuBm621TTjpTqOIexQtdpSddV+2+tGCJ8QmQEILP/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tpKEQnvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tpKEQnvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ADAC4CEE7;
	Sun, 21 Sep 2025 21:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490003;
	bh=J9KLL+Df2xnN/znbP3sthIhfuPWKdF2/lW3k02SM3MU=;
	h=Date:To:From:Subject:From;
	b=tpKEQnvLNe/Q/RIs8nmmfLfsNLRUrVk8yqeijGIvXYmsAqPMRQMnMu6Ome3GXNlVw
	 RdUJx0NgU1C5PsZEMBWAmh9MDhGmECdf4RCLDtW4ADYp0EnidKsyf9mxYW0qsq4uhC
	 grL+3A1hyijgMw/GSE2QIDx80SkRI7VF7kMh5t7w=
Date: Sun, 21 Sep 2025 14:26:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kevin.brodsky@arm.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-protection_keys-fix-dead-code.patch removed from -mm tree
Message-Id: <20250921212643.50ADAC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: protection_keys: fix dead code
has been removed from the -mm tree.  Its filename was
     selftests-mm-protection_keys-fix-dead-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Zi Yan <ziy@nvidia.com>
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


