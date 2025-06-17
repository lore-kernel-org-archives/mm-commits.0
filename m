Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950E92957CE
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 22:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750200835; cv=none; b=WyX5rqECf1zKISmc1eZAzDQVBrCd+PGPBOAQh8prLo7PW52BIkgBHGVSxVMffbVXWrY848W/JNhyD3y0aPa4Z9B05+WbKaJlFQ0WEZMq3oBySD77CCg3QSaURbS2ZIvbvzmGJnjF2pZpFz0l3ZOC6RV9rDPVxbm4a+fNpXwqgLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750200835; c=relaxed/simple;
	bh=wvY/ENzW/9zyZftWHe1mqAO8XfteGwqFOXl4P1kYugk=;
	h=Date:To:From:Subject:Message-Id; b=RoaxqCIddttoVsMM71LoBm9YaGc3Lr82aRILiNbgsd1DDvkUZzHWdAzm5IMoJ7tBW9CkPf4qy2CKhGrIy1O9e5d6ZzP0HrXwP6UJCa5q2fjAb/aBJInAENpajXxjWRIn4UbeNz6pXJLIX0T8rhp4qxwX1j9XJOcRqkMrxVpBBqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPGFz38J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPGFz38J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6C6C4CEE3;
	Tue, 17 Jun 2025 22:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750200835;
	bh=wvY/ENzW/9zyZftWHe1mqAO8XfteGwqFOXl4P1kYugk=;
	h=Date:To:From:Subject:From;
	b=lPGFz38Jy6C4iu6Gs+YBqHgyHjh7yCetcFPTTXk9eK2EdM02W16hbp74DtlZcP4Z9
	 2XFw2zNfcNw4wBqWtKXmBM0YeTFOtU22kAmsoNREp0MybJn2JoPDwny9qMF8W0JTkx
	 itZhonvK/gh3wEC94JcmuC+5VeAimrx4l8Xtsu0c=
Date: Tue, 17 Jun 2025 15:53:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-maintainers-for-hugetlb.patch added to mm-hotfixes-unstable branch
Message-Id: <20250617225355.0F6C6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update maintainers for HugeTLB
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-maintainers-for-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-maintainers-for-hugetlb.patch

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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

maintainers-update-maintainers-for-hugetlb.patch
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

