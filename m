Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6008FF9C1
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729119197; cv=none; b=QOoPp25hOf5Ia74PirbRsA4XUieged6nO4jlZ0sFGTXePOI//CJUy9p+3oR0IbNzXng4dFV9WMvPreLYzv0rd0reTTFRZdN21y7h2NGVtexXIE+2TJfQlnF2nNToY8fJ4wd0jK3Nwqzqk+lN8vB78TKpAMdQKwivVioig7aXg/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729119197; c=relaxed/simple;
	bh=huGLw2AXoARa4c3vazhaCtbrKB5bAcElzQY1WlKWbxo=;
	h=Date:To:From:Subject:Message-Id; b=TprBRQX6e3PwSChObFAd2neF8iH6Ak2pdHsbWkmIrq4XHAV3YdVvT/xh+bSZbovoDebIfZK6Nb5p3VqtnQ8O3Vssm61bi08DvIacMPpH4mO7wE9ldLNFvjmM3cNozcOEvBBXjF5b/8o3QdEuIyTE5AfbaYRgC16poVh2RFslWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=srIiP57Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="srIiP57Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA73C4CEC5;
	Wed, 16 Oct 2024 22:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729119197;
	bh=huGLw2AXoARa4c3vazhaCtbrKB5bAcElzQY1WlKWbxo=;
	h=Date:To:From:Subject:From;
	b=srIiP57YebHOdQ8f5c5rtNb0rUI+GuO1yTqwMeOKkfGrZ5cfzMNdNwRvvY/5XB59p
	 c1Dhp2Eiv+7bZ1UkXQtK159AajOkKbo2dFeUijCWznZ4oCaSvER9FbuX23x9OY0KrP
	 CjSyWTYW+Xs1j/temMsaV+PPr+pq7DXAsSRHghIk=
Date: Wed, 16 Oct 2024 15:53:16 -0700
To: mm-commits@vger.kernel.org,yuji2.ishikawa@toshiba.co.jp,rppt@kernel.org,anshuman.khandual@arm.com,nobuhiro1.iwamatsu@toshiba.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016225316.DDA73C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: numa_clear_kernel_node_hotplug: Add NUMA_NO_NODE check for node id
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: mm: numa_clear_kernel_node_hotplug: Add NUMA_NO_NODE check for node id
Date: Wed, 16 Oct 2024 18:21:01 +0900

The acquired memory blocks for reserved may include blocks outside of
memory management.  In this case, the nid variable is set to NUMA_NO_NODE
(-1), so an error occurs in node_set().  This adds a check using
numa_valid_node() to numa_clear_kernel_node_hotplug() that skips
node_set() when nid is set to NUMA_NO_NODE.

Link: https://lkml.kernel.org/r/1729070461-13576-1-git-send-email-nobuhiro1.iwamatsu@toshiba.co.jp
Fixes: 87482708210f ("mm: introduce numa_memblks")
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/numa_memblks.c~mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id
+++ a/mm/numa_memblks.c
@@ -349,7 +349,7 @@ static void __init numa_clear_kernel_nod
 	for_each_reserved_mem_region(mb_region) {
 		int nid = memblock_get_region_node(mb_region);
 
-		if (nid != MAX_NUMNODES)
+		if (numa_valid_node(nid))
 			node_set(nid, reserved_nodemask);
 	}
 
_

Patches currently in -mm which might be from nobuhiro1.iwamatsu@toshiba.co.jp are

mm-numa_clear_kernel_node_hotplug-add-numa_no_node-check-for-node-id.patch

