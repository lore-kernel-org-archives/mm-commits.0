Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA818785C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854769; cv=none; b=CvublmTdkj1i6hzYSN0ovC7n16F7B5dHmmK4D6QUTCbjdDb6lZU0C4A5S/IfCTOYd4bEzhzz613f+zXK9ya09IvdgcyVHKsIcoo8+X0WAUSBfrRwFy8FzFpyyJOsYpHCpSKD/EtpgM5YcvucxnIW+L5opyv7IZVbzVCn5Z5AK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854769; c=relaxed/simple;
	bh=B9JYp87X6dDQo8Xh/zcXeTASEcwNo5UlcTGDWkyk5tQ=;
	h=Date:To:From:Subject:Message-Id; b=iIPosODzWhLTLPiZNX6GdL6ey/KfApVevVS0WZ8OB+HojXJyZtNt3EJQcjJxm2NjDE7Dij4v2jhbUUhqHkF5kFdpaZ+DZQ/R2beryffcq7eBy2uSvlHpZBDf7SHMneNEsangL0iw5xbE8vuDiTLdHdhminNRSU4/hHi2QY75hEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RSk0F4ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RSk0F4ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8EDC4CECF;
	Wed,  6 Nov 2024 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854769;
	bh=B9JYp87X6dDQo8Xh/zcXeTASEcwNo5UlcTGDWkyk5tQ=;
	h=Date:To:From:Subject:From;
	b=RSk0F4nsasR/EK7CfWR6Fh8OAF0CfUJbxtXijBC2V7cuJgegl6IKnp0IC9QKXmOGy
	 WMGWISnkYMZf7LnzdexwOolOfQ4irPmwxrgKVjAeAx6PSoaKo63m+J646He9eEVzV+
	 Z7GWmlRW2IXqO48tOApGjr3JNXtgJE8M0qLjw0HI=
Date: Tue, 05 Nov 2024 16:59:28 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch removed from -mm tree
Message-Id: <20241106005928.EC8EDC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove misleading 'unlikely' hint in vms_gather_munmap_vmas()
has been removed from the -mm tree.  Its filename was
     mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: remove misleading 'unlikely' hint in vms_gather_munmap_vmas()
Date: Fri, 4 Oct 2024 09:48:31 -0700

Performance analysis using branch annotation on a fleet of 200 hosts
running web servers revealed that the 'unlikely' hint in
vms_gather_munmap_vmas() was 100% consistently incorrect.  In all observed
cases, the branch behavior contradicted the hint.

Remove the 'unlikely' qualifier from the condition checking 'vms->uf'.  By
doing so, we allow the compiler to make optimization decisions based on
its own heuristics and profiling data, rather than relying on a static
hint that has proven to be inaccurate in real-world scenarios.

Link: https://lkml.kernel.org/r/20241004164832.218681-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-remove-misleading-unlikely-hint-in-vms_gather_munmap_vmas
+++ a/mm/vma.c
@@ -1254,7 +1254,7 @@ int vms_gather_munmap_vmas(struct vma_mu
 		else if (is_data_mapping(next->vm_flags))
 			vms->data_vm += nrpages;
 
-		if (unlikely(vms->uf)) {
+		if (vms->uf) {
 			/*
 			 * If userfaultfd_unmap_prep returns an error the vmas
 			 * will remain split, but userland will get a
_

Patches currently in -mm which might be from leitao@debian.org are

scripts-decode_stacktracesh-remove-trailing-space.patch

