Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9EC2253EE
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567841; cv=none; b=YHNe1TVyoHdtNVMkDtOT+Lf95G+7P/c0zqhpjRCT5iSNg21d5jVIQYoN8+e7tEWdCwbqNUfGaZtmqGGjouKIdHsHQuvFHxFlPIgTjNTAE8OOv2HsSdFrSc0jICirysBSZEkD7/CMACuq0fsR5S3n4p5htNrDsnOER9FaF7Juf18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567841; c=relaxed/simple;
	bh=X2iObhrwVgjZalKbodhtmdqIRT5nqtoPPc9lnpNCIfs=;
	h=Date:To:From:Subject:Message-Id; b=Wli9/w2hNcyJWBOa5PhWAUEjdFqqMc5wJT3XpwocWudL8Cg7lRwxLASRrPqpfbjh1dY3+BVkXE33gzWJrvGWayvo8VNafZcvk9ZxVF3kPv5WOHjnqqg019ENcCph5utxyj0i2K52TpNXWEP7cKbrkRLgpOHkDSAtyml80EocXTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZEDpr0hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZEDpr0hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57FDC4CEED;
	Sat, 26 Jul 2025 22:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567841;
	bh=X2iObhrwVgjZalKbodhtmdqIRT5nqtoPPc9lnpNCIfs=;
	h=Date:To:From:Subject:From;
	b=ZEDpr0hqPII1yixXEpRW9DOBkAt3iCmvpKtnRDO7jh4p6dUd8fajquErNchNeYcKo
	 KzbLZOh25PRLo2MCFoYjr5vb31jUqvfthTsHrB9heMZoj3nT9Kc4NKCeT1XckY+Iy8
	 lPeg5Aa325W8y7d3V49OaLK4j6jFILJenkEnIRcA=
Date: Sat, 26 Jul 2025 15:10:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-move-memremap-to-hotplug-section.patch removed from -mm tree
Message-Id: <20250726221040.E57FDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: move memremap.[ch] to hotplug section
has been removed from the -mm tree.  Its filename was
     maintainers-move-memremap-to-hotplug-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: move memremap.[ch] to hotplug section
Date: Tue, 22 Jul 2025 18:22:58 +0100

This seems to be the most appropriate place for these files.

Link: https://lkml.kernel.org/r/20250722172258.143488-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-move-memremap-to-hotplug-section
+++ a/MAINTAINERS
@@ -15728,6 +15728,8 @@ F:	Documentation/admin-guide/mm/memory-h
 F:	Documentation/core-api/memory-hotplug.rst
 F:	drivers/base/memory.c
 F:	include/linux/memory_hotplug.h
+F:	include/linux/memremap.h
+F:	mm/memremap.c
 F:	mm/memory_hotplug.c
 F:	tools/testing/selftests/memory-hotplug/
 
@@ -15746,7 +15748,6 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/linux/mempool.h
-F:	include/linux/memremap.h
 F:	include/linux/mmzone.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

