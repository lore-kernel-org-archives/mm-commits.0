Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A860322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391361; cv=none; b=H0K2x2LYk0j2zfvIuoeDzwjZH5F29iYDdxbxQZK/F6VJ6fIWCkFqX8EEVQITSeQKc1UA4GjHFGk4HW0E1lLWmWr/pUX8g92hTOP7gz6Hayb62f6Ex1yD2SpkYM0e+e4xEd0Ga5F36hfsIwgpaOqI6QBQd2aiLvvNfOLoC+m6jdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391361; c=relaxed/simple;
	bh=/HCvJJslof5FgcO6F9LE3zBvnod7ARZJSroWuEjLHiM=;
	h=Date:To:From:Subject:Message-Id; b=lXc87yh2VPBY7Vosn9+KLrp6g66mrceCEIGAL3n8nqGnWmhXpSmN/N19L9DYZfnYZz3IOVtOzFpBwuqAqOgm1FQbRWN+Qc4SbSYv2QE+MaTeuIeaDVsyjH2+r5NY9q6lB6aAw83v4Xj3XeOMogym001+kVOSHkbdFbulJ5TeUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yL27b3+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yL27b3+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D68EC4CEE3;
	Fri, 20 Jun 2025 03:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391361;
	bh=/HCvJJslof5FgcO6F9LE3zBvnod7ARZJSroWuEjLHiM=;
	h=Date:To:From:Subject:From;
	b=yL27b3+uTov4MgQBaqzviN2b/9xZEWoa3z/dtI+o8ZqADpFL1wEUz6AINwE67ReqE
	 5bdUOTGlmJaS8GDffUE0uvMc5OGOQ7EQ5JohsNc32lha0NoKUrNd2nCPxjCRlBVNnf
	 paOfvaiBKDiikhNMdPNafJL7q6rSlOHJGX18FBMI=
Date: Thu, 19 Jun 2025 20:49:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-maintainers-for-hugetlb.patch removed from -mm tree
Message-Id: <20250620034921.4D68EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update maintainers for HugeTLB
has been removed from the -mm tree.  Its filename was
     maintainers-update-maintainers-for-hugetlb.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: MAINTAINERS: update maintainers for HugeTLB
Date: Tue, 17 Jun 2025 20:59:10 +0200

Change my role to Maintainer as I am quite involved in HugeTLB
development, and will be more so with the upcoming HugetLB-pagewalk
unification, so I would like to help Munchun take care of the code. 
Besides, having two people will help in offloading some pressure.

Also add David as a Reviewer since he has quite some knowledge in the
field and has already provided valuable feedback.

Link: https://lkml.kernel.org/r/20250617185910.471406-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-maintainers-for-hugetlb
+++ a/MAINTAINERS
@@ -11157,7 +11157,8 @@ F:	include/linux/platform_data/huawei-ga
 
 HUGETLB SUBSYSTEM
 M:	Muchun Song <muchun.song@linux.dev>
-R:	Oscar Salvador <osalvador@suse.de>
+M:	Oscar Salvador <osalvador@suse.de>
+R:	David Hildenbrand <david@redhat.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
_

Patches currently in -mm which might be from osalvador@suse.de are

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch

