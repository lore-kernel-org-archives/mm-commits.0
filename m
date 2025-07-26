Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452711D90AD
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567492; cv=none; b=uqNdoYFvLiCV5Ug3l3z4sUbz3RT+qJg3LpDtGV0nf93P5Iy9EafSng86NT17W69f/HkndGuQ5ypmkcKIOur1FWFAKL9wda0vci2uHr3HJK+RjtIoawbeNtXhFurqhnLz6d1WCgmsn5hI0qJKJt8+Yh/L7/2v/fbauig3Gr1bhbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567492; c=relaxed/simple;
	bh=WMHVPvgczZJNOPCJxGhmkMywRFYlqYXK6JWVnaXmwuU=;
	h=Date:To:From:Subject:Message-Id; b=TjkYJYUsIJxH6YGQk4rb8M9MtlPw8k2/4JF+X7agssZZDECns50QqbQDvw2WsoINGJqxrFDSD0K8LBDJC/F10j0bDWfke8ZNyQUD3u0Yz9Wa0qcGupLfjO5BufsvL1s04kK81KvaTMh9k0Z6LtQElNHdZpba+uZuHBEeRbnDO1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+4gNWsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+4gNWsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAD6C4CEED;
	Sat, 26 Jul 2025 22:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567491;
	bh=WMHVPvgczZJNOPCJxGhmkMywRFYlqYXK6JWVnaXmwuU=;
	h=Date:To:From:Subject:From;
	b=k+4gNWsgVbZkVk8Yjw0KV2JDhlQ86aN2WcM0Et8jZ7f/y9Y6fx1gM9DJqcPCWUQpF
	 gHj/wn+UdCgGWuw3eZuvp9zdJZZDiOEqRZ78vUInxJ9oDPeM3sC6gzLeVXW5yJzPZ6
	 2VvzcWWVuu4mdgcKAfl+Vwi0/Rj2NW9oCzOCuzXo=
Date: Sat, 26 Jul 2025 15:04:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-missing-mm_sloth-file-thp-section-fix.patch removed from -mm tree
Message-Id: <20250726220451.AFAD6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: also add mm_slot.h to KSM section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-mm_sloth-file-thp-section-fix.patch

This patch was dropped because it was folded into maintainers-add-missing-mm_sloth-file-thp-section.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: also add mm_slot.h to KSM section
Date: Wed, 23 Jul 2025 05:50:08 +0100

The mm_slot implementation is in fact common between THP and KSM so ought
to be included in both sections.

Link: https://lkml.kernel.org/r/685747e2-a8cb-4620-a0c0-5cd9048d69b8@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-mm_sloth-file-thp-section-fix
+++ a/MAINTAINERS
@@ -15821,6 +15821,7 @@ F:	Documentation/mm/ksm.rst
 F:	include/linux/ksm.h
 F:	include/trace/events/ksm.h
 F:	mm/ksm.c
+F:	mm/mm_slot.h
 
 MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

