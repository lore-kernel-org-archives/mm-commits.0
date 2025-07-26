Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBBA22333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567838; cv=none; b=DaDmUaur8OaX/tzl+TNhe9sds98hCO+JFtvkQtTXni0z2l1yOVubrvJ9ZYIdsqWxfkpmOff2Vm/4kCoIGsIKzKq9ozVWxLJrJM1cw3NcpRni3DvKNSrANwWkFKBMnX8XutoRsefSpsrudeR1rZJZ7RGXslBpODFFuSN9SVqu19s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567838; c=relaxed/simple;
	bh=lhsiBz3hv9e5JFMxRkFOBwVwSRGAYYel6KZ1LiYB+Y4=;
	h=Date:To:From:Subject:Message-Id; b=NSWJh7Ct8j8E4vMpqkf5UQIXwPH+VPS0zqfNIZA3DY3bSsem7/Pae4nIEBYlPED0jaH0bfwOhC/VuEMZksUuzKKi31uTc7dX7hks6GHr5MLjOnTbtI28GN2ZP9MFVyG08efrEeU/+SrOk+CJqFOVvUMsS0fKAphxKcJt3/cXlUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=owCt4rIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="owCt4rIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE0EC4CEED;
	Sat, 26 Jul 2025 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567838;
	bh=lhsiBz3hv9e5JFMxRkFOBwVwSRGAYYel6KZ1LiYB+Y4=;
	h=Date:To:From:Subject:From;
	b=owCt4rIhbJuF2cDmBRenDzZzUznvoIiUydS/8bHqj5RPy3fCxOWSqM6EmeyiA2G/Z
	 3Z0FLtdjNjMsXF0W9Ai0J9p0mC0k/kTXQN6nFNWS76hRfzt3YMStcV9TtsMi2W7gp7
	 vzfDT7ceFE7LhGItB7fS6Wgv2kMeGvqxOPkVBwOc=
Date: Sat, 26 Jul 2025 15:10:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-mm_sloth-file-thp-section.patch removed from -mm tree
Message-Id: <20250726221038.6FE0EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing mm_slot.h file THP section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-mm_sloth-file-thp-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing mm_slot.h file THP section
Date: Tue, 22 Jul 2025 18:19:04 +0100

This seems to be the most appropriate place for this file.

[lorenzo.stoakes@oracle.com: also add mm_slot.h to KSM section]
  Link: https://lkml.kernel.org/r/685747e2-a8cb-4620-a0c0-5cd9048d69b8@lucifer.local
Link: https://lkml.kernel.org/r/20250722171904.142306-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dev Jain <dev.jain@arm.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-mm_sloth-file-thp-section
+++ a/MAINTAINERS
@@ -15820,6 +15820,7 @@ F:	Documentation/mm/ksm.rst
 F:	include/linux/ksm.h
 F:	include/trace/events/ksm.h
 F:	mm/ksm.c
+F:	mm/mm_slot.h
 
 MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15965,6 +15966,7 @@ F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
+F:	mm/mm_slot.h
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

