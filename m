Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA6035EDAE
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966056; cv=none; b=H0OPbBLFMCmlPA88+zeSjMl0FposE2MSNpXIymp0vq0YIQUf9T46fsydMH/VO7iABqBErYYrSpabXo755f9J9V11wPBYBEvD4hWJuxWuqKIFhQCnqJZeb9Pi8/DOsm2/4XwimrsWyYps+2wkKMO7tuiWr4sxSX7neBcFppeqjWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966056; c=relaxed/simple;
	bh=Dfa/wWTY+3J1R3v/aBHf/OKfRGJ6uNoXSO4Bf1FaV8I=;
	h=Date:To:From:Subject:Message-Id; b=q1jDFrxt082FEdpv5TovM4LDiuN30rYLB6G7ZCVXP3hzmOaKiX/b8teLrkNUUQfg8Y+LsrVm4fU0WAN8UkgXlJNxmEfra45ak4T8wx1sMekrmFgH1GFEuaKLB5j34XJ2DOH0O2Cl62wtwsVjSHLwMcXFysyq0nFibB6WNBN4ThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QwMJmbLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QwMJmbLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A99C16AAE;
	Wed, 21 Jan 2026 03:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966055;
	bh=Dfa/wWTY+3J1R3v/aBHf/OKfRGJ6uNoXSO4Bf1FaV8I=;
	h=Date:To:From:Subject:From;
	b=QwMJmbLiAJlF4jDDvAegPeB64AUdhf2aYmJ5D1qIPbnqZzh9+V5RdSrVzKD8zxcpR
	 SGVRMvule/XR1MBO23l3heKy0un8UqOGsCDyn8rxhigPUzvKMfKyYNaVmw9URX5Hcy
	 QYBzP1Wy/ChSpDS5rzR//RzmqpdqZyEKDkfN8rCc=
Date: Tue, 20 Jan 2026 19:27:34 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,swarajgaikwad1925@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store.patch removed from -mm tree
Message-Id: <20260121032735.75A99C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: remove outdated TODO in target_nid_store()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: mm/damon/sysfs-schemes: remove outdated TODO in target_nid_store()
Date: Thu, 11 Dec 2025 03:27:22 +0000

The TODO comment in target_nid_store() suggested adding range validation
for target_nid.  As discussed in [1], the current behavior of accepting
any integer value is intentional.  DAMON sysfs aims to remain flexible,
including supporting users who prepare node IDs before future NUMA hotplug
events.

Because this behavior matches the broader design philosophy of the DAMON
sysfs interface, the TODO comment is now misleading.  This patch removes
the comment without introducing any behavioral change.

No functional changes.

Link: https://lkml.kernel.org/r/20251211032722.4928-2-swarajgaikwad1925@gmail.com
Link: https://lore.kernel.org/lkml/20251210150930.57679-1-sj@kernel.org/ [1]
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store
+++ a/mm/damon/sysfs-schemes.c
@@ -2288,7 +2288,6 @@ static ssize_t target_nid_store(struct k
 			struct damon_sysfs_scheme, kobj);
 	int err = 0;
 
-	/* TODO: error handling for target_nid range. */
 	err = kstrtoint(buf, 0, &scheme->target_nid);
 
 	return err ? err : count;
_

Patches currently in -mm which might be from swarajgaikwad1925@gmail.com are


