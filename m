Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8ADCA5A
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 21:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933054; cv=none; b=MheD7XKDBVEF3d5iQhTwh7mKVEQb3kTZlSTR26DUoTol34q53rqIz01925JNNiWtrTW9QM5kxnKlUGFWrAhUuuj3txrGtf00iGYZ0BW3hsu7ZiX6yPkTfKasQXXLDE/5GargZ7XBxSzL47hol2v5B5DhT1FRzd3K1+HsXN8APk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933054; c=relaxed/simple;
	bh=TVbq3W0CR4/M6FsuE6dF5nvZYCe0YpMwmzNo8bqMnZg=;
	h=Date:To:From:Subject:Message-Id; b=ZffAoFZ/UHY33WaHdpwNrNd8ZFJaW8iy1yqB3awq8znE34SNu95lNoUlw8xwJOs2mXdCn4OXD5Of4u/xeW0KIVWNMAfhzPZo3TOl7shhBXughfxZnnciqpw0PH63TgIRirnX/w5/TcNcz2QxMGhRYnPiW3RMLEYtSbopbZqjLe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4VoLKMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4VoLKMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BCBC4CEF7;
	Thu, 12 Feb 2026 21:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770933054;
	bh=TVbq3W0CR4/M6FsuE6dF5nvZYCe0YpMwmzNo8bqMnZg=;
	h=Date:To:From:Subject:From;
	b=V4VoLKMqTMMwb4BAvZZJeWDVx9+yyuD4ZurdvUUD568n44IYVn4oKZiK4r+UxxgxL
	 DJn2Fok0Ud+twq108C2dGEQa/QsZpMPxzSWtG7dh4j2CoBqQ2qNwDHpuqyFeMywhB0
	 whm3zpi29oHPT2CN2ON45eqYvTyztKDgDRl+ZKnE=
Date: Thu, 12 Feb 2026 13:50:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,liam.howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch removed from -mm tree
Message-Id: <20260212215054.60BCBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix
has been removed from the -mm tree.  Its filename was
     mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix.patch

This patch was dropped because it was folded into mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix
Date: Wed, 28 Jan 2026 16:41:55 +0000

fix check_brk_limits(), per Chris

Link: https://lkml.kernel.org/r/3aab9ab1-74b4-405e-9efb-08fc2500c06e@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Mason <clm@fb.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix
+++ a/mm/mmap.c
@@ -108,7 +108,8 @@ static int check_brk_limits(unsigned lon
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_ok(current->mm, current->mm->def_flags, len)
+	return mlock_future_ok(current->mm,
+			      current->mm->def_flags & VM_LOCKED, len)
 		? 0 : -EAGAIN;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

