Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46042486658
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866026; cv=none; b=ExdjQxTx6A7DJDrcOvCh+ORKxxKbloU9W5dgFE1qXqTVfyvfCvp2Je/qN6Bg/M1e9Wpy9KzDcGG7tBaOe8lz831J4DpDbADqmuipmHwWqaHbWfC7iu4yIKh4CTDDVSqYC5PHVWFZL9WGoqGNKhZWUZAL89e+aAX4QDf4u3beej8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866026; c=relaxed/simple;
	bh=z+udP7+ds3yBFt7BdTdDSKyufrbbQ2QgOwnHvMZJHSo=;
	h=Date:To:From:Subject:Message-Id; b=FW2dTOCBiqAALlqdBbnBaTEoA4b/NfZSxr2B76gmdnLR4UYxzxzplw+Ngi53qZtFIz0GridtPSefS4j57FZo/QPdQ9BwHTMYi6yeqfjJ+W5Y0Pi3kh/F6Y8Ucxnf/S+jlCj4IrQPKldWXDQPKUg4a9JtBjqBWrbho/0j/rjw3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j+B/Yaju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+B/Yaju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3361F00898;
	Tue, 13 Oct 2026 04:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866022;
	bh=S3vKdG+u6r8ILngkdgMBjFlYI6p6vfDUV4YHTWrFfC4=;
	h=Date:To:From:Subject;
	b=j+B/Yajuc4ys5OTpA0Wnno3c9xHKeAKtfyk1xwrXWAGZfJ9yuD2stAml6sAKp9yuV
	 GKoDotvlnJWPyE+FWtAsW6S4CGDQDo8Jw1EWZofF2ZCvCiyanY/ncSn7Pzv13blNHG
	 eqQiAIpEJ3POfnKZjz3Gb6vioUCIkICBdvx2s6TM=
Date: Mon, 12 Oct 2026 21:33:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch removed from -mm tree
Message-Id: <20261013043342.1F3361F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
has been removed from the -mm tree.  Its filename was
     selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
Date: Sat, 19 Sep 2026 01:24:36 +0100

__madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
khugepaged out of the range and to prove MADV_COLLAPSE ignores the
setting.  It clears the global controls only, which is no longer enough. 
A per-order control overrides them, and -s, which makes the cases fault in
folios of one order, leaves that order's control at "always".  khugepaged
then collapses the very range the case is working on, and the case fails
on a collapse that was interfered with rather than refused.

Clear the per-order controls too.  MADV_COLLAPSE does not consult them:
anon never did, and shmem stopped with "mm: shmem: ignore sysfs configs
for shmem forced collapse".

Link: https://lore.kernel.org/20260919002451.496763-7-kirill@shutemov.name
Fixes: b7f16963efe7 ("mm/khugepaged: run khugepaged for all orders")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-stop-khugepaged-during-the-madv_collapse-cases
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -538,8 +538,8 @@ static bool is_anon(struct mem_ops *ops)
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
-	int ret;
 	struct thp_settings settings = *thp_current_settings();
+	int ret, i;
 
 	ksft_print_msg("%s...", msg);
 
@@ -555,6 +555,10 @@ static void __madvise_collapse(const cha
 	 */
 	settings.thp_enabled = THP_NEVER;
 	settings.shmem_enabled = SHMEM_NEVER;
+	for (i = 0; i < NR_ORDERS; i++) {
+		settings.hugepages[i].enabled = THP_NEVER;
+		settings.shmem_hugepages[i].enabled = SHMEM_NEVER;
+	}
 	thp_push_settings(&settings);
 
 	/* Clear VM_NOHUGEPAGE */
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

