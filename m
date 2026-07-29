Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0E38F249
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298404; cv=none; b=AND4JiiFwS7bW3gIUazbe3btrMGpwLvqnI5EMhh0agIElESY0hfuZtnqv2QVsHIvZvfQT+nT9LYcQ5LTSlvGPZ4FHGHbPRQefzq/7C8Gg4Elj99CnwCAAIT9K9UGPgwp+vWrr8ZywCyWsUh1x/EUhjnUXkin6FtKhneJppNqE1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298404; c=relaxed/simple;
	bh=p9SYvEU2asamPMho2Lzcog86G58QpfX7W9Cyl1IdmHc=;
	h=Date:To:From:Subject:Message-Id; b=VnlvWsN+bmxxxSD1Grv++orxrpYLED/JNkFuiMwsqBpnvZ45cLWpNjf8gze2HLbeaj8tvtHMiPZWRdyNL2yvbWZXDGt5A9eEUJ/7OAVeEaE5CVsGrnF1E2pmA98FmuQ5eOdjUJ3dREG4xrapVTyiG89r5DCK9Mh2lDoJEy0mJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z/drjQZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z/drjQZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DC61F000E9;
	Wed, 29 Jul 2026 04:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298403;
	bh=wzAAAII19Voq3VBWIzWbCfinIPe9iHLB2HVAww4GTc4=;
	h=Date:To:From:Subject;
	b=z/drjQZCxJncJg3y8vsxqnfVYzCinq6A3hDxMqcUvZFcn6h+9clKkurkWK9WqITLq
	 cVDBzmDdCPB134Xhy5zrBo0tCItS7KJOC3jl/uYJGMV8FhdqELEBfii99hEKvOxVE4
	 /tKr8n9ua1qtSAmGrPhk4c/n4Y3jQL/H6pr3rB0s=
Date: Tue, 28 Jul 2026 21:13:22 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,david@kernel.org,anthony.yznaga@oracle.com,enelsonmoore@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch removed from -mm tree
Message-Id: <20260729041323.12DC61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in comment
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: mm: hugetlb: correct CONFIG_CGROUP_HUGETLB macro name in comment
Date: Mon, 15 Jun 2026 17:01:31 -0700

A comment in <linux/hugetlb_cgroup.h> incorrectly refers to
CONFIG_MEM_RES_CTLR_HUGETLB, which has never existed in the kernel,
instead of CONFIG_CGROUP_HUGETLB.  Correct it.

Discovered while searching for CONFIG_* symbols referenced in code but not
defined in any Kconfig file.

Link: https://lore.kernel.org/20260616000135.62815-1-enelsonmoore@gmail.com
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment
+++ a/include/linux/hugetlb_cgroup.h
@@ -267,5 +267,5 @@ static inline void hugetlb_cgroup_migrat
 {
 }
 
-#endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
+#endif  /* CONFIG_CGROUP_HUGETLB */
 #endif
_

Patches currently in -mm which might be from enelsonmoore@gmail.com are

maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch
mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch

