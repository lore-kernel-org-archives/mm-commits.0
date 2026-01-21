Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0CF29B8E8
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960381; cv=none; b=m4PxAmtTbgphWP1ya5DJwnMZYbQKtms8GFErVvrM1V0mpL8f1ZQT9omwdfAjWaJ4wmkXRR5+qbcT1tLktKodaYjmB+g/AUk0pjFKG/OJikdkKA8b1y2kkUb8LRBdbbflZwJ/A9wt1iuEW3YesNymC2VkH1zcJVWTvFSm8t4MGBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960381; c=relaxed/simple;
	bh=TNMckFxDmnUQulwPXS+TT9xdBYLyO5zDxOAvV7rke0I=;
	h=Date:To:From:Subject:Message-Id; b=sMuhCBdn8ml8vca0VEgS4HQlfrbVt6SbS7Fjw7Sr5v78EyuEFlWnec0Ik5gu45WXqO5YAs6e+xSwZ71cutkErT4aLTXEUVNekfIfCGe0APvCiYge2bqcc5WUaCwCdp5dLycQd4/+tfFkyQYIweJJoH723OORXJGnQIIUdrjwJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a8dWI2aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8dWI2aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB88FC16AAE;
	Wed, 21 Jan 2026 01:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960379;
	bh=TNMckFxDmnUQulwPXS+TT9xdBYLyO5zDxOAvV7rke0I=;
	h=Date:To:From:Subject:From;
	b=a8dWI2aQGXWniqBTXms2G1lZ75b/P2hZOkBEWmla36TJjIGtCScaVnUyrinocJTat
	 agrBa9e5ha8YwxkaKUKRQVQ/AZ6LX5jCTv+NFkPXtQ8TVtF9HPC8MU7fGqliJEIHEn
	 npzmG9AfKJQIbjLSgpESERvfizJV6jH2LFpQCiE4=
Date: Tue, 20 Jan 2026 17:52:59 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,lkp@intel.com,kartikey406@gmail.com,hch@infradead.org,hannes@cmpxchg.org,axboe@kernel.dk,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-block-fs-remove-laptop_mode-fix.patch removed from -mm tree
Message-Id: <20260121015259.CB88FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-block-fs-remove-laptop_mode-fix
has been removed from the -mm tree.  Its filename was
     mm-block-fs-remove-laptop_mode-fix.patch

This patch was dropped because it was folded into mm-block-fs-remove-laptop_mode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-block-fs-remove-laptop_mode-fix
Date: Mon Dec 22 06:06:52 PM PST 2025

fix Documentation/admin-guide/laptops/index.rst

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512212211.GvfwAGPP-lkp@intel.com/
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/laptops/index.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/admin-guide/laptops/index.rst~mm-block-fs-remove-laptop_mode-fix
+++ a/Documentation/admin-guide/laptops/index.rst
@@ -10,7 +10,6 @@ Laptop Drivers
    alienware-wmi
    asus-laptop
    disk-shock-protection
-   laptop-mode
    lg-laptop
    samsung-galaxybook
    sony-laptop
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

