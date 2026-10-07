Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA642C3245
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334142; cv=none; b=q0LbEM5qDHiYtQ3XPFJ6EtAve4zV+y+Rx57jIZsJkfIjDUmGUgmJVFviVpsd1Rrxk0TKPTpjYiWIZxkHjWlSoxxZhqU7SrxFENbAsBRWKhM+EcbAEwlp/RyxYNg8rOx5KH1Z6L3oVwlRVxyDelq95Svrjti8EBz6NUvP6bvyjJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334142; c=relaxed/simple;
	bh=7bwS2SNLFrKwl75ItK7pQJRhkSTB6KLPRDWpUIcfuRE=;
	h=Date:To:From:Subject:Message-Id; b=dTrbANEJufGnlEjAsoIXhfA6yT7OClL7iiEI4vD0BT6SOskHJwp55oOakJykbx1Wnn8MsQb5is3xS5Zpsd9VlZeDeko6bc7kRlGOxnYwXo0/U1LxnTw2ZDkLlTToce/85BQJ+ecsRPZmsTwDO3s+euMLcW8GL6yN6hG1glF/W5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tX1IFZMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tX1IFZMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDF41F0089B;
	Wed,  7 Oct 2026 00:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334141;
	bh=pGzHVXs+TW4KM1yhAhlyepuJouXh0oB1+rJ2m9z71gw=;
	h=Date:To:From:Subject;
	b=tX1IFZMdGCEZ0T2pO472DyuuE92onaYOV0c/0MEcyAY/RAWCo02zliu7I4issnZUp
	 PO4Vpn5PCmPMt6ZdAsr+8zYCcFrCBkqdOk0IRaUWpnygqpbh6+GdU/fJj3cn2joEpP
	 VVbLnR7tDk1AQyMHaJdq3W9cATGsVWye1yw+dmeg=
Date: Tue, 06 Oct 2026 17:49:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ljs@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshumantewari123@gmail.com,akpm@linux-foundation.org,david@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-khugepaged-remove-str_dup-usage.patch removed from -mm tree
Message-Id: <20261007004900.DBDF41F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: khugepaged: remove str_dup() usage
has been removed from the -mm tree.  Its filename was
     selftests-mm-khugepaged-remove-str_dup-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: selftests/mm: khugepaged: remove str_dup() usage
Date: Tue, 25 Aug 2026 13:20:59 +0200

We don't check str_dup() return value and never free it.  While both
things are irrelevant in practice, let's just clean it up by working on
argv[0] directly and avoiding the str_dup().

Nobody after us needs these parts of the argv[0] string anyway.

This patch is inspired by previous work from Anshuman Tewari [1].

Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
Link: https://lore.kernel.org/20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Anshuman Tewari <anshumantewari123@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-remove-str_dup-usage
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1227,7 +1227,7 @@ static void parse_test_type(int argc, ch
 		return;
 	}
 
-	buf = strdup(argv[0]);
+	buf = argv[0];
 	token = strsep(&buf, ":");
 
 	if (!strcmp(token, "all")) {
_

Patches currently in -mm which might be from david@kernel.org are

mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
arm64-mm-move-__check_safe_pte_update-fix.patch

