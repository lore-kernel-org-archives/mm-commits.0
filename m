Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E343F252292
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 03:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769223748; cv=none; b=har2KftQirhAUdghVZ7cTY2Nmql0rz2VI24yRd5S1+Zqg5lRRZXB9Tzha0VGE8J00jx4p6nRYQruEDELfQkM8XwjgGvweT2wOMK1VeQ+hlk4GvVB/m0OW7crZ3Sk+E3Eh/ltvL+wiz55R9NjyPC3Zgr9mNsDs/4bQNKid9HfeHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769223748; c=relaxed/simple;
	bh=H0f2HcSZFofWkFG/ES6IRPOdHL80vEBkCFBRNxD0FK0=;
	h=Date:To:From:Subject:Message-Id; b=bC7xZ6fHamSr5L0QvoTQc4VxcSX1UrMzsQRu1QbzTQ6uTaMysr9sDqZRHI57vtrEI3RySwH9WugTo9S4UXz0Z1n9rl/M0C9vog6oz+7IJeHb4kOmLfUV3+ubcu2GmmFiWyeI176ml9chk8fXt2nhWUOyBO681sBXhKxM/cSurVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ji78NHjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ji78NHjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E244C4CEF1;
	Sat, 24 Jan 2026 03:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769223747;
	bh=H0f2HcSZFofWkFG/ES6IRPOdHL80vEBkCFBRNxD0FK0=;
	h=Date:To:From:Subject:From;
	b=ji78NHjZuvHykrTLQIoJWnbaHKL1PPbAdcdAmuliad3wikMt4/NugKmfIX7RGb3Nb
	 KWQ1KCwuiIMZI41qMzJgprLw3o8cCHjK3fx6FI+IQkyVptp1QJrSTtrB8FOWjhboAp
	 514quEi0nQraHi5B9cnDM/Eh4hU57K4uolBzGc8A=
Date: Fri, 23 Jan 2026 19:02:26 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-khugepaged-make-khugepaged_collapse_control-a-local.patch removed from -mm tree
Message-Id: <20260124030227.7E244C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: make khugepaged_collapse_control a local
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-make-khugepaged_collapse_control-a-local.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Garg, Shivank" <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control a local
Date: Fri, 23 Jan 2026 15:03:58 +0530

Make this collapse_control instance local to the only function which uses
it.

Link: https://lkml.kernel.org/r/ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-a-local
+++ a/mm/khugepaged.c
@@ -827,10 +827,6 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
-
 static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
@@ -2618,13 +2614,16 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
+	struct collapse_control cc = {
+		.is_khugepaged = true,
+	};
 	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
-		khugepaged_do_scan(&khugepaged_collapse_control);
+		khugepaged_do_scan(&cc);
 		khugepaged_wait_work();
 	}
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch

