Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC653C3BED
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439137; cv=none; b=fqCsjDaBZKxTckdm5+XY+jhpiznE7sXBx/PiWgB6H3oh5DO1QOErwFP+oYzQQ1mzQyqai7FYHWh7poGf63dEMpmt7JW+YLEaUrkm9TVd99IkPxpsIpt9TBKFMRvlvbruu/QAWAlBfIlajNqUSHvrvbW1JM1V28c2WZJZqUDN17M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439137; c=relaxed/simple;
	bh=jOIpMgHMvhn1zwUqXBJ+4eMWRXSNOIbMvKyQlBEhCD8=;
	h=Date:To:From:Subject:Message-Id; b=Snm0SGc0ZvwYVTDBmex0E9qCxhzOCAeefBPycwJH7U9rNBvMzrWjCt+4NsCwFRV+DYzzGCc+6RbnoeUCS1E5BrJTRBoG6qV7ZAHLGNlNRhh8j7E0HrjYhtMbgIcSB6S0s7R5MQH+cYocan9u4obhgn//LG1h8TZH/b6fp2knV2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g0czykb8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g0czykb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016841F00898;
	Tue,  2 Jun 2026 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439136;
	bh=N8odnrwWETYGdcR9cUytc4hZ8w8GtRdSfwGwQGvFX+E=;
	h=Date:To:From:Subject;
	b=g0czykb8eQfGyy/204MJ4t8Kp9+JXtv4lTs+GCP2ZgbnVHN5beV5O8FoxvVjXugvq
	 omUmtlwKWWRcFIhodTpkmTBZTTc2//M6w9cUNBGEiZJKzQYVpQ1UUortGjt9qDuEjr
	 qgxMATGPmGjt4mJEqJyfyC9aDYB+5F1+axCWfA/U=
Date: Tue, 02 Jun 2026 15:25:35 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,liuqiang@kylinos.cn,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch removed from -mm tree
Message-Id: <20260602222536.016841F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
Date: Mon Jun  1 05:49:07 PM PDT 2026

fix dmirror_devmem_fault_alloc_and_copy() retval handling

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Qiang Liu <liuqiang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
+++ a/lib/test_hmm.c
@@ -1167,9 +1167,9 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-		if (ret) {
+		if (dmirror_devmem_fault_alloc_and_copy(&args, dmirror)) {
 			migrate_vma_finalize(&args);
+			ret = -ENOMEM;
 			goto out;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-switch-deferred-split-shrinker-to-list_lru-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

