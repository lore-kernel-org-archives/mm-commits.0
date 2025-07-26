Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578B21CA1D
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567843; cv=none; b=mpko8zLZg9Be0j+w1ydN3eT0gGoy4U6Bu4TX6THLP96+kmLun89ZqRVXhIFtnm8CpimKShIkc80uO1OkhZvyXEQoRGBsuljOHeZH/JMrCqouVlOweyylo9w2i3pFoQAJqhwzZtLO1pDeVconBnC2AZdOsjpAXvIgBKqLDMxRUT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567843; c=relaxed/simple;
	bh=Rg93E85nnk8vtyuGFOL/DNRlWh60cEMJB3PbQuVJfdU=;
	h=Date:To:From:Subject:Message-Id; b=bxMP3ez5o+3sk4CEHURIQMF7nivpBGe9QuWc0vzWwvhrKvOxeutSXEuU1zkpMBX6UjpSU2pUAYEr4oM3InwG+Fvb0RbxMvVP72CgLUEYk9Hjb/oHgXB9HWtd3i4skjXtjzmJM9Hwk4T6e7p8qmXWRiY+ZLDXGNtPrW2qwuGcoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zf9QJP5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zf9QJP5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE29CC4CEF5;
	Sat, 26 Jul 2025 22:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567842;
	bh=Rg93E85nnk8vtyuGFOL/DNRlWh60cEMJB3PbQuVJfdU=;
	h=Date:To:From:Subject:From;
	b=zf9QJP5aagxbEETWEcO/sd+gs5aLNQWQ4mgBvwl8OB5b6chmvhHjLd9n1EaHtCJwM
	 yAsgdUdD51b+7HmOWdB7osxzPuAPmL7aX++ktkZNzaCXxMD0ZfB+cUm8wh8bNHlLmz
	 HEpjd4p6y/d8gx1yplyeDqFSoFKwEmHVT6/2JKZk=
Date: Sat, 26 Jul 2025 15:10:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-shrinker-files.patch removed from -mm tree
Message-Id: <20250726221042.CE29CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing shrinker files
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-shrinker-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing shrinker files
Date: Tue, 22 Jul 2025 18:34:36 +0100

The mm/list_lru.[ch] files implement a shrinker-specific data structure so
seem most suited to the SHRINKER section.

Link: https://lkml.kernel.org/r/20250722173436.145526-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
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

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-shrinker-files
+++ a/MAINTAINERS
@@ -22635,7 +22635,9 @@ R:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
+F:	include/linux/list_lru.h
 F:	include/linux/shrinker.h
+F:	mm/list_lru.c
 F:	mm/shrinker.c
 F:	mm/shrinker_debug.c
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

