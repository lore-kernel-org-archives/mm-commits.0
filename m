Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86172484236
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865987; cv=none; b=c2Oqbi3q8LM3umYL/YL+frr06jMGn1l+StYfstmQ+9x+yMtV8YAdGnHJrvnCcPVr71UXhuN97dQyMaqTH+0Gh/rRrYGI8YhFPeC944+8EOYJZ0PJNig2nlA1M0223ybKSyt31sB10IKdgdrSLy2JFQtwDuZwjtPCrBefrMVz3mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865987; c=relaxed/simple;
	bh=/Rx0HGyd+MpmU1ghGHEiytwfdA0dHT9G1tdOc0QwANU=;
	h=Date:To:From:Subject:Message-Id; b=mexsEbCLkric29LXoTphre71W/GQG9d6zoqw8JadJONMOwQLb201+/dDlCMw+bdz0m6rul/R9S6tyPRzsgs8rFH5omPsORXJJkW04RVDoeONNLkOLCGQz3TWrf9NcuhPXLN4icGNVxdZ9udBOsG07G6QbYVrMV6LvPSzrCMyF7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pLrWwthn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pLrWwthn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540631F000FF;
	Tue, 13 Oct 2026 04:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865985;
	bh=1jHrpsH2vGWqxBeAhZla+sggs3X42IMJ269e5XeXfbM=;
	h=Date:To:From:Subject;
	b=pLrWwthnFvZolPsepTEacnoHqgxD3gNnM4smQxak6FUd7bHY+k1IiAedD2ml8LIGz
	 DsT+4dQDpvZg6vjOu89osSuAHtTojd5FHbzI+Weg0hSYqBiVE3eThzvDWq1dBfikmT
	 olKoG4Xr3yjq3n7A4JpSb6z1TeeQFlMpDnT6kwVY=
Date: Mon, 12 Oct 2026 21:33:04 -0700
To: mm-commits@vger.kernel.org,yu.c.zhang@linux.intel.com,xiaoyao.li@intel.com,vbabka@kernel.org,vannapurve@google.com,tabba@google.com,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,rientjes@google.com,riel@redhat.com,pbonzini@redhat.com,nao.horiguchi@gmail.com,michael.roth@amd.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jiaqiyan@google.com,isaku.yamahata@intel.com,hughd@google.com,hidehiro.kawai.ez@hitachi.com,david@kernel.org,dave.hansen@linux.intel.com,baolin.wang@linux.alibaba.com,andi@firstfloor.org,ackerleytng@google.com,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch removed from -mm tree
Message-Id: <20261013043305.540631F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lisa Wang <wyihan@google.com>
Subject: mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
Date: Thu, 17 Sep 2026 20:43:50 +0000

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio.  Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies
that the page still has elevated refcounts.  Hence, set extra_pins to true
if the return value is MF_DELAYED.  This is aligned with the
implementation in me_swapcache_dirty(), where, if a folio is still in the
swap cache, ret is set to MF_DELAYED and extra_pins is set to true.

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-4-4b00856b5364@google.com
Signed-off-by: Lisa Wang <wyihan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
---

 mm/memory-failure.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases
+++ a/mm/memory-failure.c
@@ -1040,17 +1040,13 @@ static int me_pagecache_clean(struct pag
 	}
 
 	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
-	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
_

Patches currently in -mm which might be from wyihan@google.com are


