Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E970C369219
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966525; cv=none; b=bJBIM9k3aunGDItPyga6k0H2Za79pgenzBW45isuGgEH+GBAu4P69x5hM51q967tcWd2eXChkEA2chuiBf0+IhA42s+606ErIWqj3BdEszfcsye/tPZOJeZPsMw1UPfl8GndOgERoaL28FHcs2T37imfwFCQ+IizRfGMU2Hkplk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966525; c=relaxed/simple;
	bh=k26Agjwv8zC8T+fbhpGbZOE/fWoLOlO/0V+EOL8X8bw=;
	h=Date:To:From:Subject:Message-Id; b=iZjPBz3ET94E/Pl/Gbx/A8Ck1v3Hw8ixb68Uig9MXUqcR5q6Mu0ED0QRmUaSnyjuAesifbnq8dYYWK/lFAbyx9osMSNRcT7IhhshQSFYeJGoiq+hbrDsikHPKgUTXVwCGfm4i2HzVjzkM8dzLZ0eme80/ytK0DBTbGWazqHe3dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBzivgFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBzivgFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69992C19423;
	Wed, 21 Jan 2026 03:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966524;
	bh=k26Agjwv8zC8T+fbhpGbZOE/fWoLOlO/0V+EOL8X8bw=;
	h=Date:To:From:Subject:From;
	b=dBzivgFkAgt9SqEHLYCg2Rdu7stkbxZtohBf4SsSsnUrRe6TCB8TFCv+12xyssXWQ
	 cUk+NVdtgbbzagwCTWmQUiosSUwSvFjLQQozydX9+LmDhSxD/Jy1YAM7JNN1Wz2bQw
	 IB2tPpgQz3pZWQN6+AJ9y1xtrKKdWdaPmsPkueOE=
Date: Tue, 20 Jan 2026 19:35:23 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] list-add-primitives-for-private-list-manipulations-fix.patch removed from -mm tree
Message-Id: <20260121033524.69992C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list-add-primitives-for-private-list-manipulations-fix
has been removed from the -mm tree.  Its filename was
     list-add-primitives-for-private-list-manipulations-fix.patch

This patch was dropped because it was folded into list-add-primitives-for-private-list-manipulations.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: list-add-primitives-for-private-list-manipulations-fix
Date: Mon Jan  5 02:36:38 PM PST 2026

fix kerneldoc

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20260105160459.013ffb1e@canb.auug.org.au
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/list_private.h~list-add-primitives-for-private-list-manipulations-fix
+++ a/include/linux/list_private.h
@@ -81,7 +81,7 @@
 	list_private_entry(ACCESS_PRIVATE(pos, member).prev, typeof(*(pos)), member)
 
 /**
- * list_prev_entry_circular - get the prev element in list
+ * list_private_prev_entry_circular - get the prev element in list
  * @pos:	the type * to cursor.
  * @head:	the list head to take the element from.
  * @member:	the name of the list_head within the struct.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
list-add-primitives-for-private-list-manipulations.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

