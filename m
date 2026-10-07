Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FDE3264DA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334362; cv=none; b=XXkkIS8MuMm5gXehpNV6fpEkcEucfCqGVmdyeayKuW6Hkc02oSksn/CFB2mZGpz9ZS7PYIAdcL2gleWd3mRHFuhvmjaVYytil8BL0BiXfz95ftRrGHuXEhiQOLxgfQGhg95I/9e37t02tWSj3wY8v8OV4XQEc2WimFcBlsya75U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334362; c=relaxed/simple;
	bh=3Xu5K0gkGNuDUgaJuX8AXDV+9N6UfDNjcq+7qCydM0U=;
	h=Date:To:From:Subject:Message-Id; b=MwSCPoMumd/ALN+1ikxH8cW4QFwKLM2FSOo5YJtYIcB3uXAZ6F+vkDEvEAPoxMKaVO9UA8fwoNqbfDro77BxnMbQK4LR38O5MfQ1AlY+WKjbCnr3jTlPhVOyg0Pn78W93+7P5v5DgW0MmLetJrizPaGLJcCjHoEL4pHWc44nN30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0S+PZ7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0S+PZ7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAD71F0089C;
	Wed,  7 Oct 2026 00:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334360;
	bh=H5fOO82jpgW/OGbvGhnhqiWjBdhKdQ8MopUQYMzwcLI=;
	h=Date:To:From:Subject;
	b=j0S+PZ7gRro6yf6H1bS5nQKNH6xfFEkYcwuwGkvRDiDNkY5eSTlZbYFd7DYgPZ6fe
	 rbdyrWNer20gPGPK8UT+Hrfy5hOKQ2vkEMPeZlvNa0IuLzRyUQDqtYLA/T9AdVveFP
	 5lZ+yI74ZpVjmW8ts9HSDhUhXKo4RZzwetBm5zlQ=
Date: Tue, 06 Oct 2026 17:52:40 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch removed from -mm tree
Message-Id: <20261007005240.BAAD71F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: remove unnecessary return in pcpu_populate_pte()
has been removed from the -mm tree.  Its filename was
     percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: percpu: remove unnecessary return in pcpu_populate_pte()
Date: Wed, 2 Sep 2026 01:53:04 +0900

Since commit c6f239796b55 ("mm/memblock: add memblock_alloc_or_panic
interface"), pcpu_populate_pte() no longer has an error label after the
return statement, so the return statement has no effect.

Remove unnecessary return.

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-5-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---

 mm/percpu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/percpu.c~percpu-remove-unnecessary-return-in-pcpu_populate_pte
+++ a/mm/percpu.c
@@ -3178,8 +3178,6 @@ void __init __weak pcpu_populate_pte(uns
 		new = memblock_alloc_or_panic(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
 		pmd_populate_kernel(&init_mm, pmd, new);
 	}
-
-	return;
 }
 
 /**
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

