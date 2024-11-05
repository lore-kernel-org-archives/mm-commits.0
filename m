Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4F541C69
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 06:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730787892; cv=none; b=kGExj0ayiv+6DDPz+8W0jS6ftXml2nB39g9PcYHSfmqVJWjFSw2j0ZEQaL7jsJjhA4Tv+/6FlHAS/19mGxK9nLaV2YG2veYS9R/VeAPPDJojAFFU/5EMTIF4U7HMVa8E+1uMy+E/sAAXqGsITnxwBV7VL8e9PTx6Cm/0u8iPlqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730787892; c=relaxed/simple;
	bh=KOK55Nas2H0VhqxluKpcdLhYrtQLIiY2Z6Wur9Nklp4=;
	h=Date:To:From:Subject:Message-Id; b=GFEvr2Gu2imQoROnwFUySSC9MFGbGSxCWSAAeOQ5HwC7OtHyFVXN70ONIF6MktJ0vbGvHTPluz42vP7oG4DRpYOsNP8AeGIBLU8xHZM0TigFB75DX0kwWo8vlkbfhrmK0s7aEb+7Wc3bnTV5Al8k5iwPaHO7ihrhSy1YHy5GnHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tledxfiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tledxfiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FF8C4CECF;
	Tue,  5 Nov 2024 06:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730787891;
	bh=KOK55Nas2H0VhqxluKpcdLhYrtQLIiY2Z6Wur9Nklp4=;
	h=Date:To:From:Subject:From;
	b=tledxfiO4fx+NH+Jiahru9cTEXOANzfYvDHT6Ug+YbVc5tGL31A3k8vMgmoJf0Fk7
	 m9OVVNyykLeNwYE5uiOd+QzuDOTXtWwwTdl01ACJJRW+RbLYOSrMd1XFtK3P6vqmIM
	 qTn470feDIy5+C8HDLB8dhVIi3nxQe2vnreY6YPI=
Date: Mon, 04 Nov 2024 22:24:51 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,catalin.marinas@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch removed from -mm tree
Message-Id: <20241105062451.D6FF8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix
has been removed from the -mm tree.  Its filename was
     mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch

This patch was dropped because it was folded into mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix
Date: Wed Oct 30 04:20:15 PM PDT 2024

fix whitespace, per Catalin

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mman.h~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix
+++ a/include/linux/mman.h
@@ -158,7 +158,7 @@ calc_vm_flag_bits(struct file *file, uns
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
 	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
-		arch_calc_vm_flag_bits(file, flags);
+	       arch_calc_vm_flag_bits(file, flags);
 }
 
 unsigned long vm_commit_limit(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch
mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

