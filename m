Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4AB2E762C
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689445; cv=none; b=sRvZaVXWnx/4aUDsd4R+l4meUkQQwCq8B+rc3DpSUy3FpYA+9MLcgryzAEtCqP60ZCfndJAgw9H6+wtLY4LrEIBl2vX/BhmOZ39Vkr+1wHbmDdhkZqBOshZ+UVyiQO+JIs2lv1L1JLYvE0cTTLxiSgerISWQ7hF2VhQ0EhVbUow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689445; c=relaxed/simple;
	bh=C3rryUfKvuSS76HTK/YV42i/RUrn5SnAVgaiSP+OpQQ=;
	h=Date:To:From:Subject:Message-Id; b=ZZdrs/YfYI4SaKZQe+zdNVazOOoKDT30Uktlg5qmrAEtIsGjAbRq5gdjRAga0j+OR8Z3Q1ILatpusv+THumTBYdPht8MK0fclz1OgpAyhVyLRhzHeaRr42NStR8UlRXKjl+OI5kG6OUuTBATWVGjP5qpRpq1q9XbZjhkoj0mkZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g9ciNzul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g9ciNzul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475B01F000FF;
	Thu, 17 Sep 2026 23:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789689443;
	bh=JQYCIww7vcjM3YocO/HUhD5TtRiTHdiDur9HCQXzmu0=;
	h=Date:To:From:Subject;
	b=g9ciNzullS381KXTFv3t2ad3hI3Zp/UWSA+xDVpIrVMC8Jt4V4IyaahAs5+QFoXEf
	 WgQ5gFr8YCzoniJTOdqY1pQLonGlNxB5Lz0k9HjBMSA5zA4T7OczQibEVMWnt7zoOp
	 K+DNtjrFo5KOEVfUYYo4IeJzHl35jEZZaSijD/Ik=
Date: Thu, 17 Sep 2026 16:57:22 -0700
To: mm-commits@vger.kernel.org,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_failure-clarify-the-mf_delayed-definition.patch added to mm-new branch
Message-Id: <20260917235723.475B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_failure: clarify the MF_DELAYED definition
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_failure-clarify-the-mf_delayed-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_failure-clarify-the-mf_delayed-definition.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-memory_failure-clarify-the-mf_delayed-definition.patch
mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch
mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch
mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch
mm-selftests-add-shmem-into-memory-failure-test.patch

