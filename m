Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061307;
	b=zyPjZZwVex9yWnoFGsr+nW0YFhbJrp/uzuNRRIsFhwansnMzHFC/SiggFiNvvS7GtJE7
	 Dhui/x2KVmfu1lmk25AVZm8kwroyDFU+nLQQShdWBKM6gs/7BRF8KQEi4lX5/gcNEdSbE
	 g9G/ZTbgv2ShwvjmPVSu/qaEt2mosSmfHGy6VcM7WY4CBY0+yY4ZPUlsAbU/5lCmX2cFP
	 1M0wVpFPiTGI2cCQF6job7kHGb9KgBHTQcVuEN9Fed/C1G9lT9VNOUkLp/2IhzTuk68+x
	 o4Mki5kBbGobBL05sB3fpwUinPw7atrWjX+fOOJzhfUSIQQ3rcImfX3o7RC3Dqk6s3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061307;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=j/W83122PSvZZkqxInSejnBvMkuLcCQ9G8rOkSOKmBs=;
	b=ov5VTKtiRJazDZovlViRzKZNNSfwbxQ6RxUnDWSj+x2xNkDgXIEEWBOQXKdEW6bLBz/p
	 sTItTbRxP5vhXknqvMkbs0WmK4KqrQ/QC0YG3IUTj5KSyy8rDIp6X05sBNFfg3UhOAuAJ
	 h7gLWcFasQrYNYcWy13GY1PsNbghJ2J+0LKN5MbHZH2f3Mol489PpJAjvnOJF9B0QtfeP
	 KSK67hj5Ye5NbtXekWQESd7O19k3XyopJ7bkBojeveT1Vx+yk8RCeftmJHV4nucXPwDZS
	 xIewsspuPcBi3WpMtOYTKcoHjJuceGO0iHMfta9eD5cPmeJ7m+ERRS+T9YUn725eA8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="uGzmB/1x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C400606A320
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 04:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uGzmB/1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0679F1F000C4;
	Thu, 19 Nov 2026 04:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795061307;
	bh=j/W83122PSvZZkqxInSejnBvMkuLcCQ9G8rOkSOKmBs=;
	h=Date:To:From:Subject;
	b=uGzmB/1xGqfHyNTqlbH/edd2WHAzvc42uWgpEpCp3nf6ShHEx8B1Ruc3XSByVZ3XR
	 H7Vf40Q4BxqLM6OMJ4ZnMxxoIV8lmLHOEyD1PqPmaty9XXmdhBvhFvh/ppl4DsKZ9Q
	 wP4ym8htNOURDuFpnZ0cCvDdItBtE83eRzLsL7QM=
Date: Wed, 18 Nov 2026 20:08:26 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	anshuman.khandual@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch removed from -mm tree
Message-Id: <20261119040827.0679F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
has been removed from the -mm tree.  Its filename was
     mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
Date: Sat, 03 Oct 2026 01:05:34 +0900

vmf_insert_mixed() just calls __vm_insert_mixed() with the same
arguments.

So merge __vm_insert_mixed() into vmf_insert_mixed().

No functional change.

Link: https://lore.kernel.org/20261002160535.661399-4-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>

 mm/memory.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed
+++ a/mm/memory.c
@@ -3014,8 +3014,8 @@ static bool vm_mixed_ok(struct vm_area_s
 	return false;
 }
 
-static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
+vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
@@ -3064,6 +3064,7 @@ static vm_fault_t __vm_insert_mixed(stru
 
 	return VM_FAULT_NOPAGE;
 }
+EXPORT_SYMBOL(vmf_insert_mixed);
 
 vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write)
@@ -3085,13 +3086,6 @@ vm_fault_t vmf_insert_page_mkwrite(struc
 }
 EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
 
-vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn);
-}
-EXPORT_SYMBOL(vmf_insert_mixed);
-
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch
fault-injection-fix-typo-in-failcmdsh.patch

