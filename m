Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6655E247280
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744849; cv=none; b=FZCx99NrnN9HewK8ErMS+SwyyO6/39l6E64T1TjRLPuNZmljIH1ISe3j+gwnbByGyiAtQDQz2PCdlrw06Eluvf78w5dZFOKEkDUQhTgVVHfaiaWbcqolqMV+2gUiioHMYQQ6lat5ewfVD4HAzqy9KILE+5uJYTi1r9NqDyWjAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744849; c=relaxed/simple;
	bh=NVEKQ4w51K1tqRbJ/gdQcIKjm+pg+43YUEjU+vs2rAs=;
	h=Date:To:From:Subject:Message-Id; b=bFetDYmLuwsv9+3FXZXUO2tMz0CgKXUhdOQ7skfBn22hQfuMFn6QkjhCGIPrVASAZdh9VmdVVf1tOBP2x1rp2B1jQZZHmmCSH5u3Nx+2tQZ9TURmiBrbSjPfD9JuKVgEtxJ4v3qeJxf26FXJ9/7tCPaqo2McP8h/lVfDD+MHBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xmz76UXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xmz76UXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F039C4CEF7;
	Sun, 29 Mar 2026 00:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744849;
	bh=NVEKQ4w51K1tqRbJ/gdQcIKjm+pg+43YUEjU+vs2rAs=;
	h=Date:To:From:Subject:From;
	b=xmz76UXtX9Yl3jdp1vC076GqwmFnhG1zvMHAwQq84beIyIcVRniRluMbaPnECFWQj
	 xPD0XFpvw0qyvzXqu7hW550ia97rDAgLWD9t2bgmMLnNwH72Tvqqb9gTCGor617KZs
	 0tMKS+5ASIHWH8KavTHWH21+t9EBejkB1liFZOUU=
Date: Sat, 28 Mar 2026 17:40:48 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ritesh.list@gmail.com,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kvm-ppc-remove-hugetlbh-inclusion.patch removed from -mm tree
Message-Id: <20260329004049.3F039C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: PPC: remove hugetlb.h inclusion
has been removed from the -mm tree.  Its filename was
     kvm-ppc-remove-hugetlbh-inclusion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: KVM: PPC: remove hugetlb.h inclusion
Date: Mon, 9 Mar 2026 16:19:01 +0100

hugetlb.h is no longer required now that we moved vma_kernel_pagesize() to
mm.h.

Link: https://lkml.kernel.org/r/20260309151901.123947-5-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv.c~kvm-ppc-remove-hugetlbh-inclusion
+++ a/arch/powerpc/kvm/book3s_hv.c
@@ -36,7 +36,6 @@
 #include <linux/gfp.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
-#include <linux/hugetlb.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from david@kernel.org are


