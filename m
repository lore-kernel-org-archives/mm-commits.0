Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946622A4FE
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567835; cv=none; b=Wyv9a8H2ewt7eojtiZn+5eXCWA/7VpL+IFlQ/YlW+KKQJY1VGMH2RihMMqFCIpqOqVlc88GbS9ubQmwFMk+AbGejNk6Ps1KIokSXRUeZ2yCbl3C760d8dfgqcvWYUlwPhBJFJGqpFpLh8aEaQXQZA1QVQGiRG/fh8Lt346GhL1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567835; c=relaxed/simple;
	bh=ceEHfnhAiI4FztYZ0SgjkZjeKPcAiYBhiC8tQXYlV10=;
	h=Date:To:From:Subject:Message-Id; b=jNCB2dbgADcmGnCe+bzlLPBLERQDNY53s7VU6ruYsBE04PtBMyohg43HxpkZP95Q9uqJHbwKW/tn6ZKJ6InZ+QfcHxAy56LWtlJkCJI9o3yyj7aJppwij2b66SvaDAc0ZDyxpR/Ofza5d6bM37ETetRbeu4FW6ruIpd/GmC4+oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CbhlKAvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CbhlKAvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CCAC4CEED;
	Sat, 26 Jul 2025 22:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567834;
	bh=ceEHfnhAiI4FztYZ0SgjkZjeKPcAiYBhiC8tQXYlV10=;
	h=Date:To:From:Subject:From;
	b=CbhlKAvDIkTzdfk2JL7yZ/e82S98aLprX83ly8IDodRKusRIlZo29/kD9M4LAclfT
	 fsHKFJDB6m+TNbH4U+kDzl9zJ4GRj6qDJSZSIWd6X+qd9AurZBpBIiKc9KH3tDjOtp
	 gX9mc9dg9zToD/T5s+qy9DHtTTuTYhTdyg4yEOeA=
Date: Sat, 26 Jul 2025 15:10:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch removed from -mm tree
Message-Id: <20250726221034.71CCAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing percpu-internal.h file to per-cpu section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing percpu-internal.h file to per-cpu section
Date: Tue, 22 Jul 2025 18:10:23 +0100

This file seems to most appropriately belong to the PER-CPU MEMORY
ALLOCATOR section, so place it there.

Link: https://lkml.kernel.org/r/20250722171023.139777-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-percpu-internalh-file-to-per-cpu-section
+++ a/MAINTAINERS
@@ -19459,6 +19459,7 @@ F:	arch/*/include/asm/percpu.h
 F:	include/linux/percpu*.h
 F:	lib/percpu*.c
 F:	mm/percpu*.c
+F:	mm/percpu-internal.h
 
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <bsingharora@gmail.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

