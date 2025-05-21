Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2E01CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846633; cv=none; b=J4Dq3am5WNgt8SAduq/yqB+l1R0NOHrVVkXqkpsOHensH0vehcO4kOhwSpUY+995eDvF5hfCupvCPXVHoPv/MMDwbNY9y+y1ya6HDtW+wAwEXQCU1pEKjXgBhWx2ioVuXeZ9nrGAnKefwnJv+1+vlbcXSF/KAmI5T2clJlM8Qko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846633; c=relaxed/simple;
	bh=FTB/puJXMRu2HtQHjt9LxT/ZDzb+c4zZry9FWr8KzIE=;
	h=Date:To:From:Subject:Message-Id; b=Ra7YXF07N2jcDiZaUlesj+eGHPL3CyP1dhHXJ4bH1apYZAUOkGoJMUFwdFdEv7ISnIFRXj1XEgaJazFwgX2BZ6DVD86tUTaJvX9u1ONG5OH15Q1lCxq1S7i2k73C/sjkvoQjv2yQMWa8CEJtC0lgJOmvC7bmSiGlejrFEE4uWJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y2dYbltv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y2dYbltv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D11C4CEEF;
	Wed, 21 May 2025 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846633;
	bh=FTB/puJXMRu2HtQHjt9LxT/ZDzb+c4zZry9FWr8KzIE=;
	h=Date:To:From:Subject:From;
	b=Y2dYbltvJxxVGgTMjWN20+u6NsJRj15I9bkzcgBd0P8tcrZHOnyDAkktdUqAXS4D2
	 Ga6qNkj8v2tSJ0Oh39hTyMFE9GZ3u/wLkIqnaZA1VzAd9sPLJtnZel0VPGiUx/NnNd
	 aU0SThUGbFdWgGgWicHXJead8pTZVrBByb+Q3n1M=
Date: Wed, 21 May 2025 09:57:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch removed from -mm tree
Message-Id: <20250521165712.F3D11C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm/pat: remove strict_prot parameter from reserve_pfn_range()
has been removed from the -mm tree.  Its filename was
     x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/mm/pat: remove strict_prot parameter from reserve_pfn_range()
Date: Mon, 12 May 2025 14:34:20 +0200

Always set to 0, so let's remove it.

Link: https://lkml.kernel.org/r/20250512123424.637989-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org>	[x86 bits]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range
+++ a/arch/x86/mm/pat/memtype.c
@@ -858,8 +858,7 @@ int memtype_kernel_map_sync(u64 base, un
  * Reserved non RAM regions only and after successful memtype_reserve,
  * this func also keeps identity mapping (if any) in sync with this new prot.
  */
-static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
-				int strict_prot)
+static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot)
 {
 	int is_ram = 0;
 	int ret;
@@ -895,8 +894,7 @@ static int reserve_pfn_range(u64 paddr,
 		return ret;
 
 	if (pcm != want_pcm) {
-		if (strict_prot ||
-		    !is_new_memtype_allowed(paddr, size, want_pcm, pcm)) {
+		if (!is_new_memtype_allowed(paddr, size, want_pcm, pcm)) {
 			memtype_free(paddr, paddr + size);
 			pr_err("x86/PAT: %s:%d map pfn expected mapping type %s for [mem %#010Lx-%#010Lx], got %s\n",
 			       current->comm, current->pid,
@@ -906,10 +904,6 @@ static int reserve_pfn_range(u64 paddr,
 			       cattr_name(pcm));
 			return -EINVAL;
 		}
-		/*
-		 * We allow returning different type than the one requested in
-		 * non strict case.
-		 */
 		pgprot_set_cachemode(vma_prot, pcm);
 	}
 
@@ -959,7 +953,7 @@ int pfnmap_track(unsigned long pfn, unsi
 {
 	const resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
 
-	return reserve_pfn_range(paddr, size, prot, 0);
+	return reserve_pfn_range(paddr, size, prot);
 }
 
 void pfnmap_untrack(unsigned long pfn, unsigned long size)
_

Patches currently in -mm which might be from david@redhat.com are


