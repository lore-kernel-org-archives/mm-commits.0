Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1822E888A
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 05:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752046; cv=none; b=Xr5hilg13Am8IAymIyHEBIjrvqjr6HT01h0Dldkrr3MORHaAqZ1b9y7iQ8O2HKOJnJ6plYsgcjjzUtcyCzA9YTWP3DB3WyCD4XhKwK0yaD2MUIFEPVLMFayqaSa0tJzsFSAajBbQnY70P33hhotkYD1UPMZcr/7zhnTsdr1TD0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752046; c=relaxed/simple;
	bh=J7zVS9qBSYb1dQ+yDWFNlTZi+PyP5VJlP9EQJEn37jE=;
	h=Date:To:From:Subject:Message-Id; b=SvpkYFI5rp+uqOLuf7a11QeKpojF2DeF3LsEwoJyDx6ykKav7DdEvy2VU0cBesjCZM6P/IktNi2WHdJtM8MI0yWQ1uMXBnhkDEldsnlOw4mrQRP9KrMEGUnS0ZAul1DKhlESVLdOkaG9LCzKAmzo6d3zNbCneZ7kH8qCCo7o7Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m8taKHSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m8taKHSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031DAC4CEFB;
	Mon, 10 Nov 2025 05:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752046;
	bh=J7zVS9qBSYb1dQ+yDWFNlTZi+PyP5VJlP9EQJEn37jE=;
	h=Date:To:From:Subject:From;
	b=m8taKHSyAMoWc6UFEuOSRUQUa4NMrEJDMycpC7TTuRudLe74mngJIWVt1XX0gq+XS
	 bRpgwnP3gndes0XsFlA9iv9gVUlK1YDSkdxpYN/9UWgXmZvvsL3fLnS7HLjF8Ajy33
	 reoE40gy24z40POGnPNLhgdbVQSGHOFEHWaeJXo8=
Date: Sun, 09 Nov 2025 21:20:45 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch removed from -mm tree
Message-Id: <20251110052046.031DAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix out-of-bounds access of vmalloc chunk
has been removed from the -mm tree.  Its filename was
     kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: fix out-of-bounds access of vmalloc chunk
Date: Mon, 3 Nov 2025 12:01:57 +0100

The list of pages in a vmalloc chunk is NULL-terminated.  So when looping
through the pages in a vmalloc chunk, both kho_restore_vmalloc() and
kho_vmalloc_unpreserve_chunk() rightly make sure to stop when encountering
a NULL page.  But when the chunk is full, the loops do not stop and go
past the bounds of chunk->phys, resulting in out-of-bounds memory access,
and possibly the restoration or unpreservation of an invalid page.

Fix this by making sure the processing of chunk stops at the end of the
array.

Link: https://lkml.kernel.org/r/20251103110159.8399-1-pratyush@kernel.org
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_handover.c~kho-fix-out-of-bounds-access-of-vmalloc-chunk
+++ a/kernel/kexec_handover.c
@@ -889,7 +889,7 @@ static void kho_vmalloc_unpreserve_chunk
 
 	__kho_unpreserve(track, pfn, pfn + 1);
 
-	for (int i = 0; chunk->phys[i]; i++) {
+	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn = PHYS_PFN(chunk->phys[i]);
 		__kho_unpreserve(track, pfn, pfn + 1);
 	}
@@ -1012,7 +1012,7 @@ void *kho_restore_vmalloc(const struct k
 	while (chunk) {
 		struct page *page;
 
-		for (int i = 0; chunk->phys[i]; i++) {
+		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 			phys_addr_t phys = chunk->phys[i];
 
 			if (idx + contig_pages > total_pages)
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch

