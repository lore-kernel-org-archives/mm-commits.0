Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742097DA9E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854867; cv=none; b=uIPy46dWJLN/+dKyrC4vsZ5j4U+iXhwgUt5CQtJv/YehFQDlswx5TWswIx62kIHKhGY+225+ZEKNPIdtOrQGKKZZHBshfCZsWHaiGjtKqos9bhtGtNdseOqNPPLlgIfucsCEO7319Tth1LH6SNgKFNVWAiIZDRJyrWPSIfUs2Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854867; c=relaxed/simple;
	bh=GbXXzyqOA/qW0COZ4oBSHy3RqaOQ+Dx/qlcEqeOQoNY=;
	h=Date:To:From:Subject:Message-Id; b=hMdzP+CV6CK92wusTrdsBpNo9M3SHtUETuCLj36/ydYN4NMIE17Wb8n/zktZDigIvMSKVSnY+fW3hVxLLbT00MMoZY/iDORhj2g3eM56OCFWrfSTEGlkaevWiShYx/KZ4ZwqWIxiApHtXyZ4EtWf41B8KziDJoIb/VDsx8xxSDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGtJwC6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGtJwC6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C02CC4CECF;
	Wed,  6 Nov 2024 01:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854867;
	bh=GbXXzyqOA/qW0COZ4oBSHy3RqaOQ+Dx/qlcEqeOQoNY=;
	h=Date:To:From:Subject:From;
	b=qGtJwC6knCIpA8cPkLXt4p/4qKaaj122e96F3wdcQh/QeGc+xhrDBe4enZ0oTScS5
	 dx4yrqXgPt43xwOp4sPZEOBWsX2gjQvcAdjTEEQSDyMv12tlrg2mQFqWgFgRaF0kOH
	 Fw1yyu/Qq+I2IysUQ2IL+FFNeWiur6sujdgXOUj4=
Date: Tue, 05 Nov 2024 17:01:06 -0800
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch removed from -mm tree
Message-Id: <20241106010107.4C02CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: use str_off_on() helper in build_all_zonelists()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/page_alloc: use str_off_on() helper in build_all_zonelists()
Date: Mon, 21 Oct 2024 11:13:40 +0200

Remove hard-coded strings by using the str_off_on() helper function.

Link: https://lkml.kernel.org/r/20241021091340.5243-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-str_off_on-helper-in-build_all_zonelists
+++ a/mm/page_alloc.c
@@ -5493,7 +5493,7 @@ void __ref build_all_zonelists(pg_data_t
 
 	pr_info("Built %u zonelists, mobility grouping %s.  Total pages: %ld\n",
 		nr_online_nodes,
-		page_group_by_mobility_disabled ? "off" : "on",
+		str_off_on(page_group_by_mobility_disabled),
 		vm_total_pages);
 #ifdef CONFIG_NUMA
 	pr_info("Policy zone: %s\n", zone_names[policy_zone]);
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mailmap-add-entry-for-thorsten-blum.patch
mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch
ipc-msg-replace-one-element-array-with-flexible-array-member.patch

