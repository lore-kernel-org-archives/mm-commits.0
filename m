Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0609483BFE
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865983; cv=none; b=NFdiK4HLbv/ZuKiwZjOPH2fSDLK7Oe1jGhx+edVXaNkeUluRgCaQcSHj7JBTve7boKmuNDVdqECevDohk2ZnhxozTUrpCTfQ2yFzzmLdC/kBIu/ugIFNLXrp8fYY0MzAWc2/lHER4lrtn8YDJ4jBhH2j0DHtgVUG/X9kW2dgsMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865983; c=relaxed/simple;
	bh=jL/T9Qbtz7+sWbLE9hat1fWFmX/ThG9iofRawRq+VC8=;
	h=Date:To:From:Subject:Message-Id; b=rmz1gW9wc/Tnf3GvKhlEPHEZEaEnKTWpL2/8ZNfj2e+h6f6BUl2gVnQ7gPZkvghEW+amD3tkbDBzo3/Ym7k/SasQl8PlEViITHAZ9tH7cVNNr/MaQsrpL8C/cwlD9GJ4IlYtuPwim40tDGvXJVyip4lCipA9GHTBrpjr/zpTtfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p2B32afc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p2B32afc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC561F00893;
	Tue, 13 Oct 2026 04:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865981;
	bh=L5dd90PnJHa7IYaifZ81TTmqx+0zifsa/AHF8vJSWqE=;
	h=Date:To:From:Subject;
	b=p2B32afceWsGGCqwL+UpvSRu+TYFN12PAIHSq5bLXPebk1FzmTuREl0bA+IpWAK3u
	 cQ0IP6wrd9+Qys7e6lkLGS5pFk0wl/cmi6Q9trNNagbcQ6cUaJ9VbAGJa87ROpaOwI
	 OiwztOPo4NHITwH8Nhsq6MNKk/eG0S+pb8gbTcqw=
Date: Mon, 12 Oct 2026 21:33:01 -0700
To: mm-commits@vger.kernel.org,yu.c.zhang@linux.intel.com,xiaoyao.li@intel.com,vbabka@kernel.org,vannapurve@google.com,tabba@google.com,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,rientjes@google.com,riel@redhat.com,pbonzini@redhat.com,nao.horiguchi@gmail.com,michael.roth@amd.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jiaqiyan@google.com,isaku.yamahata@intel.com,hughd@google.com,hidehiro.kawai.ez@hitachi.com,david@kernel.org,dave.hansen@linux.intel.com,baolin.wang@linux.alibaba.com,andi@firstfloor.org,ackerleytng@google.com,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch removed from -mm tree
Message-Id: <20261013043301.BFC561F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lisa Wang <wyihan@google.com>
Subject: mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
Date: Thu, 17 Sep 2026 20:43:48 +0000

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console.  MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED.  This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a memory
failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-2-4b00856b5364@google.com
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
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

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed
+++ a/mm/memory-failure.c
@@ -939,10 +939,12 @@ static int truncate_error_folio(struct f
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
-		if (err != 0)
+		if (err == MF_DELAYED)
+			ret = err;
+		else if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
-			pr_info("%#lx: failed to release buffers\n", pfn);
+			pr_info("%#lx: Failed to release buffers\n", pfn);
 		else
 			ret = MF_RECOVERED;
 	} else {
_

Patches currently in -mm which might be from wyihan@google.com are


