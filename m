Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A82372B37
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388643; cv=none; b=iB/UnlqKUMvmwOVKN0Ve4mAgvbEwBtnhTReit7WrL1o3nWQP6Q4a8pgmGDoRCawwSwYsgEUzhF5aFQQEVQiVReI2i/IXs0RoW/zfpV04B8dHOaP6QZuJtVb8HU7Yk6jd3hCD5m7sS3Ow/HuXrIUXN5yVS3lVCyONsPqf+BcqoVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388643; c=relaxed/simple;
	bh=roSsQCFsp60jjf6FbjgLqmZOkUx1LjZcMZPPVHaIFN4=;
	h=Date:To:From:Subject:Message-Id; b=ulaFi1d7SL0tH6AvX19loa/+9OwPryHm+PD12nJBiS3Pf6U5oiKeSksUVdMzajD7TSxhzF1qvgx7zlrVBv9rG5yu3UAeaxYVrBzlTWOM/8A24Hm4TSJ+8IiOobNem431Am+kH1sHGPuOo6K3zvXv33S6jn7hooUgVrEr/1gWOEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LK77RQcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LK77RQcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43571C19424;
	Tue, 24 Mar 2026 21:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388643;
	bh=roSsQCFsp60jjf6FbjgLqmZOkUx1LjZcMZPPVHaIFN4=;
	h=Date:To:From:Subject:From;
	b=LK77RQcLvXwjUWzYJscwgOWuezdD2lp6IgeM1BxgjCzmuQIm/KHwe/ymcZthbQVf7
	 ImVBpjfB0bp77a3YlwLQZtAQUFhKrSsw/7cVzMMvr/D0i8K75xvmhgFdhD+m7KR9rn
	 MwKeCVvhRyXecYJYDOseqUguhD48lf8rqUyynmJk=
Date: Tue, 24 Mar 2026 14:44:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch removed from -mm tree
Message-Id: <20260324214403.43571C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/vdso: undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
has been removed from the -mm tree.  Its filename was
     x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: x86/vdso: undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
Date: Fri, 27 Feb 2026 19:42:49 +0000

The 32-bit VDSO build on x86_64 uses fake_32bit_build.h to undefine
various kernel configuration options that are not suitable for the VDSO
context or may cause build issues when including kernel headers.

Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP in fake_32bit_build.h to
prepare for change in HugeTLB Vmemmap Optimization.

Link: https://lkml.kernel.org/r/20260227194302.274384-12-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h~x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32
+++ a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,6 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
+#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
_

Patches currently in -mm which might be from kas@kernel.org are


