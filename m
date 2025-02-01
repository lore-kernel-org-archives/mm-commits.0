Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E83153565
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410848; cv=none; b=RfR4lwsEoDLj7POLMLlDFzEc8sdqcZOnZWql3tEaf+/1+tf9vFwAWbUmUMer8MFeK7xLvjim9dtnBBQcx1PePCTVIaCoUwSc+OiAlJnerFMmqVhuTR7rOIgySZh49rAD0LByH6964kJvNfmm/gxjss6gmH3biWb39JLsfsbVJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410848; c=relaxed/simple;
	bh=31SJBrEkDiqrk+ZKS9o1Kz02SpUchoghWeus5PM9Lj0=;
	h=Date:To:From:Subject:Message-Id; b=g8Gn7/jEcV6/Icn+sptHMJ7dUGjMkPaXl8tkqYSNBb6L7TSfes5Dlb8W9Nb2SRiw8LDkxt2xxsk2qfusrqbz18QGDqgcfk6mGyawb59Xl1saT12/ZmRyetilQjboAKGiUym07CHOSTpz5UUlGTPb/LMfelZW0UlGBH71zkC7wvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=akCnLJ/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="akCnLJ/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD23C4CED3;
	Sat,  1 Feb 2025 11:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410848;
	bh=31SJBrEkDiqrk+ZKS9o1Kz02SpUchoghWeus5PM9Lj0=;
	h=Date:To:From:Subject:From;
	b=akCnLJ/AyjKjZBi/wz+ixA29PmzdFUrbq9I/k71ad+UW1H9fZY394zhZIYytB2kIZ
	 V7yqUSVB0XeLDhBCqBI11oCkLQIRm5z84mmvtJieka3dwYSW9b13PJsVsYUo6EbOWe
	 Qt6zvL+vco56SURuUMjTi/fpIrvZK9FB2AoXCiBk=
Date: Sat, 01 Feb 2025 03:54:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,rafael@kernel.org,lenb@kernel.org,jhubbard@nvidia.com,hyeonggon.yoo@sk.com,david@redhat.com,bfaccini@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fake-numa-handle-cases-with-no-srat-info.patch removed from -mm tree
Message-Id: <20250201115408.5BD23C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/fake-numa: handle cases with no SRAT info
has been removed from the -mm tree.  Its filename was
     mm-fake-numa-handle-cases-with-no-srat-info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bruno Faccini <bfaccini@nvidia.com>
Subject: mm/fake-numa: handle cases with no SRAT info
Date: Mon, 27 Jan 2025 09:16:23 -0800

Handle more gracefully cases where no SRAT information is available, like
in VMs with no Numa support, and allow fake-numa configuration to complete
successfully in these cases

Link: https://lkml.kernel.org/r/20250127171623.1523171-1-bfaccini@nvidia.com
Fixes: 63db8170bf34 (“mm/fake-numa: allow later numa node hotplug”)
Signed-off-by: Bruno Faccini <bfaccini@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <hyeonggon.yoo@sk.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/srat.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/acpi/numa/srat.c~mm-fake-numa-handle-cases-with-no-srat-info
+++ a/drivers/acpi/numa/srat.c
@@ -95,9 +95,13 @@ int __init fix_pxm_node_maps(int max_nid
 	int i, j, index = -1, count = 0;
 	nodemask_t nodes_to_enable;
 
-	if (numa_off || srat_disabled())
+	if (numa_off)
 		return -1;
 
+	/* no or incomplete node/PXM mapping set, nothing to do */
+	if (srat_disabled())
+		return 0;
+
 	/* find fake nodes PXM mapping */
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (node_to_pxm_map[i] != PXM_INVAL) {
@@ -117,6 +121,11 @@ int __init fix_pxm_node_maps(int max_nid
 			}
 		}
 	}
+	if (index == -1) {
+		pr_debug("No node/PXM mapping has been set\n");
+		/* nothing more to be done */
+		return 0;
+	}
 	if (WARN(index != max_nid, "%d max nid  when expected %d\n",
 		      index, max_nid))
 		return -1;
_

Patches currently in -mm which might be from bfaccini@nvidia.com are


