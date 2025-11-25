Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCC632B990
	for <mm-commits@vger.kernel.org>; Tue, 25 Nov 2025 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092737; cv=none; b=JUzIISegPMEQO7GK4x9a0wh72p62bzftaJVezac8RDMQvEeILEZO6KdEGbXrYn/OBuMY3mk4skNfF3vkpOekbVja8S8ROPHWiyHZ99cMxAA33e9VdYfXUdN+2M5Mepy65lJQsREh/wIcYB6n3t7BefFXTdpzVSmZZizgZXZa6rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092737; c=relaxed/simple;
	bh=hy6okQFUesb9HdbrjrGP8+wjTa6GPDk6P5yJ6LlnHdM=;
	h=Date:To:From:Subject:Message-Id; b=i1aAWdrvDCJ0KiuZrCtsTZOJbVkbBoK23iLkpnp+fMKCMn7FCK9ahJUaUcX0SPhOGFWc3prvRBpMCFK2b/R7W4mAeCqybX0HjS1RqnsqbB5V2drvvdZXUkalp4Sq0NoMVqMvbwTcmNE4Zn2tM9A1VLLx1LQgr59lx4XO398KhhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UC6nZPwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UC6nZPwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3692EC4CEF1;
	Tue, 25 Nov 2025 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764092737;
	bh=hy6okQFUesb9HdbrjrGP8+wjTa6GPDk6P5yJ6LlnHdM=;
	h=Date:To:From:Subject:From;
	b=UC6nZPwEFGMzdHifgp6q4pbRBwNwuISkf8Pa6k1F+WHkn8+/goszUoEL4cUW43C66
	 D1UGNJWJJVccIn1x1ydQXJPrwbDzDeQER2XR0yo6YNghTuLbLdFJvUloOzeuggA/3r
	 Mj2SnyA7KdGzZK2NH7tDI5yymj3prmYsHYircaFc=
Date: Tue, 25 Nov 2025 09:45:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix.patch added to mm-unstable branch
Message-Id: <20251125174537.3692EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix
Date: Tue Nov 25 09:43:05 AM PST 2025

enhance comment, per David

Link: https://lkml.kernel.org/r/e5118fe1-7963-4f09-a80b-e6185ffcb366@kernel.org
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix
+++ a/mm/huge_memory.c
@@ -3714,7 +3714,8 @@ int folio_check_splittable(struct folio
 	 * caller that there was a race.
 	 *
 	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
+	 * swapcache.  Currently it will also refuse folios without a mapping
+	 * in the swapcache (shmem or to-be-anon folios).
 	 */
 	if (!folio_test_anon(folio) && !folio->mapping)
 		return -EBUSY;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memory-change-folio_split_supported-to-folio_check_splittable-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

