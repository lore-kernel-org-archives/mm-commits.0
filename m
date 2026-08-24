Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A28306B08
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 19:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787600635; cv=none; b=dRYNvkd1LUkYYdhav11A060brHguv77QHqSXRfOYn5xS82C+IXMrWpIsrnAcMXE01dGxcm6TAXCBtTWscrpgNGR+SYfME6uCGzKNjojWqbX+0fbiiA2SgiIY+YNqHHCPZDLjXFHWXjKF6djX0dfdgpIGR9vUZALbYJvkf4zN2kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787600635; c=relaxed/simple;
	bh=c5t1NiPYLe7r35GtexQy2l9L02JlrLizDKqy3rnmJao=;
	h=Date:To:From:Subject:Message-Id; b=ABYSiPniiYSMlf58hKL+APa+CwhEH7pG9AZ3GpJSwqB7Anm6Vz3UyNRAJAvmMh9iwLxrOP5hyeoL3tVFcI5rS1pxlVZvWlI50mUcaWv7TM9chNuEvfNcUTYL2o8RODsUrSMAzWoTPnUutLox0t1S8gfj/BoCzwLVQ2LTvE3LVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+VeRVy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+VeRVy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4641F000E9;
	Mon, 24 Aug 2026 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787600633;
	bh=eKT85bs5F0Cvc72lz79lIyKNr3e6/VEy9LBRjmuO5f8=;
	h=Date:To:From:Subject;
	b=k+VeRVy/Jce0mRm+1Ka1d5hClikY/1j08iVET/0CQjD/m66NEgEBJxFS/Oa0mp78i
	 81X5I04cE00waghmf8xUMxGHZXiO3ySIGNuhb+QLALZKTYb9EfGDgzzQtculF4+A3T
	 m+dZkpQcsANGva/N74WeCD6kiRpUvsTEr4ezv5o0=
Date: Mon, 24 Aug 2026 12:43:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch removed from -mm tree
Message-Id: <20260824194353.BB4641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
has been removed from the -mm tree.  Its filename was
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch

This patch was dropped because it was folded into mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
Date: Thu Aug 20 09:15:38 AM PDT 2026

fix kerneldoc comment typo, per Lorenzo

Link: https://lore.kernel.org/aob1goSSPH6sTN9y@gremlin
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix
+++ a/include/linux/mm.h
@@ -2318,7 +2318,7 @@ static inline bool vma_flags_is_cow_mapp
 
 /**
  * vma_is_cow_mapping() - Is this VMA a CoW mapping?
- * @desc: The VMA to check.
+ * @vma: The VMA to check.
  *
  * See vma_flags_is_cow_mapping() for details.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
maple_tree-document-erase-and-allocations-better-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

