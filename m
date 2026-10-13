Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCAB4848A8
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865982; cv=none; b=nNfGmjyDHMxiztNz2fyjKDrDCtMH9wtBO2jyRKbeVmjrJZ3FpCfYMxz0Q1RsxrdpPZjR4JmnpjzwTf4e1KtfUveu7X2if/93Z42fY5hc2wNDAPzXKv2cvpB2Jo4SOQXXqYAUyExceqDcEdT242riyWloBEnmKBgYXzQPeb43eTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865982; c=relaxed/simple;
	bh=J3hPLaaYY4RQT2vsgZi69lMvi75M1qs3m3DaDQyKuu8=;
	h=Date:To:From:Subject:Message-Id; b=ZMQI4Qi5D+bh8K9mmnqcwBT1ppJOUpeV+cUPqe623v581S8P3h4tuob5V2jiqlDu8MtUrbDaoeO9zPhppr9wW8ulMCC5sThFlfQAKukyG1uE1xe2OSJJx6U2O3c8nTit6Mh7okU4kH2vta88UVZiJW7JoEb7W+5Tr9dzgIVdfr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vPE6AN1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vPE6AN1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8CF1F000FF;
	Tue, 13 Oct 2026 04:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865980;
	bh=V9T1wBzGqV7ZwJsn1PO8oMc+dvXZqRF+ot1PMMzLv7Y=;
	h=Date:To:From:Subject;
	b=vPE6AN1GoPL/QS26lIC+Wog/w5V3qGaoL2qQ75YZWaFwb5FfFu6zb3CqMnE9KkKt1
	 gngXXSwhPo2Ys1ttnquyelMzNUtI+KJgR0w5Rftg86heCHV/5HSAFD6/H9FO9gwWNq
	 qEcmTcrbQzCBGEKSL4qF5c047IdYHvriR/jF79TY=
Date: Mon, 12 Oct 2026 21:33:00 -0700
To: mm-commits@vger.kernel.org,yu.c.zhang@linux.intel.com,xiaoyao.li@intel.com,vbabka@kernel.org,vannapurve@google.com,tabba@google.com,surenb@google.com,shuah@kernel.org,seanjc@google.com,rppt@kernel.org,rientjes@google.com,riel@redhat.com,pbonzini@redhat.com,nao.horiguchi@gmail.com,michael.roth@amd.com,mhocko@suse.com,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,jiaqiyan@google.com,isaku.yamahata@intel.com,hughd@google.com,hidehiro.kawai.ez@hitachi.com,david@kernel.org,dave.hansen@linux.intel.com,baolin.wang@linux.alibaba.com,andi@firstfloor.org,ackerleytng@google.com,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_failure-clarify-the-mf_delayed-definition.patch removed from -mm tree
Message-Id: <20261013043300.AD8CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_failure: clarify the MF_DELAYED definition
has been removed from the -mm tree.  Its filename was
     mm-memory_failure-clarify-the-mf_delayed-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lisa Wang <wyihan@google.com>
Subject: mm: memory_failure: clarify the MF_DELAYED definition
Date: Thu, 17 Sep 2026 20:43:47 +0000

Patch series "mm: Fix MF_DELAYED handling on memory failure", v6.

This series addresses an issue in the memory failure handling path where
MF_DELAYED is incorrectly treated as an error.  This issue was discovered
while testing memory failure handling for guest_memfd.

The proposed solution involves -
1. Clarifying the definition of MF_DELAYED to mean that memory failure
   handling is only partially completed, and that the metadata for the
   memory that failed (as in struct page/folio) is still referenced.
2. Updating shmems handling to align with the clarified definition.
3. Updating how the result of .error_remove_folio() is interpreted.


This patch (of 5):

This patch clarifies the definition of MF_DELAYED to represent cases where
a folio's removal is initiated but not immediately completed (e.g., due to
remaining metadata references).

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com
Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-1-4b00856b5364@google.com
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

 mm/memory-failure.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-clarify-the-mf_delayed-definition
+++ a/mm/memory-failure.c
@@ -847,24 +847,25 @@ static int kill_accessing_process(struct
 }
 
 /*
- * MF_IGNORED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_IGNORED - The m-f() handler marks the page as PG_hwpoison'ed.
  * But it could not do more to isolate the page from being accessed again,
  * nor does it kill the process. This is extremely rare and one of the
  * potential causes is that the page state has been changed due to
  * underlying race condition. This is the most severe outcomes.
  *
- * MF_FAILED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_FAILED - The m-f() handler marks the page as PG_hwpoison'ed.
  * It should have killed the process, but it can't isolate the page,
  * due to conditions such as extra pin, unmap failure, etc. Accessing
  * the page again may trigger another MCE and the process will be killed
  * by the m-f() handler immediately.
  *
- * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
- * The page is unmapped, and is removed from the LRU or file mapping.
- * An attempt to access the page again will trigger page fault and the
- * PF handler will kill the process.
+ * MF_DELAYED - The m-f() handler marks the page as PG_hwpoison'ed.
+ * It means the page was unmapped and partially isolated (e.g. removed from
+ * file mapping or the LRU) but full cleanup is deferred (e.g. the metadata
+ * for the memory, as in struct page/folio, is still referenced). Any
+ * further access to the page will result in the process being killed.
  *
- * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoison'ed.
  * The page has been completely isolated, that is, unmapped, taken out of
  * the buddy system, or hole-punched out of the file mapping.
  */
_

Patches currently in -mm which might be from wyihan@google.com are


