Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5CD253340
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744848; cv=none; b=eIt0ervxODxAN2/waF8eTVsrzTQubFD3XfPXAtGJxaqtaQ4gy3eEEomZFd5GOgBReGmSC493jPO2WOa/U2Rtf9hoiGBOX/VjXL2g0Ig1ZVQPi/+Sc3sfoeRWQlU2+cwWWGJQvufUk2nvmrLm0BRDb5Nk6NnGmzUGzMKkoRNf8Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744848; c=relaxed/simple;
	bh=gHNgwSo+ZIX0JtZjNdk8JKNfnFHZs1l7yHLc1F1rWrQ=;
	h=Date:To:From:Subject:Message-Id; b=D/SGo33asbjgp3LiP+r/z8rd+QkznXwp7RXx7c+Ojq3HyLDgLJbAbxGxtufw/z8IIZF16IjzT2XfjEiky5fOPWeF7hKKD4H4hCGJ+ahKGB3JPgvO0/il9nGTrWEFqOK31EBWMoEGyQwKSMQSysZ2NzRYeVS79lveiEgQVbyLmFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NZLMmNjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NZLMmNjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7310C4CEF7;
	Sun, 29 Mar 2026 00:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744848;
	bh=gHNgwSo+ZIX0JtZjNdk8JKNfnFHZs1l7yHLc1F1rWrQ=;
	h=Date:To:From:Subject:From;
	b=NZLMmNjGzzS6sadiEpacJ2yiiT7iKvWwTOI22+DNIwKldWn/gD9D66j0gwqoGK5zA
	 1PK59iBdIDynVaNPvoakeoIxlIQaJG0gNtnygSbaNKlPrLkHz+oSFE7ZpusjgFUuHa
	 3t+XlP4PozFEpTGBLOQUUpAaJYmwh7pz+jI+Cky0=
Date: Sat, 28 Mar 2026 17:40:47 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kvm-remove-hugetlbh-inclusion.patch removed from -mm tree
Message-Id: <20260329004047.E7310C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: remove hugetlb.h inclusion
has been removed from the -mm tree.  Its filename was
     kvm-remove-hugetlbh-inclusion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: KVM: remove hugetlb.h inclusion
Date: Mon, 9 Mar 2026 16:19:00 +0100

hugetlb.h is no longer required now that we moved vma_kernel_pagesize() to
mm.h.

Link: https://lkml.kernel.org/r/20260309151901.123947-4-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

 virt/kvm/kvm_main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/virt/kvm/kvm_main.c~kvm-remove-hugetlbh-inclusion
+++ a/virt/kvm/kvm_main.c
@@ -41,7 +41,6 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
-#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
_

Patches currently in -mm which might be from david@kernel.org are


