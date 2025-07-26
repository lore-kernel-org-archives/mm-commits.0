Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CFE21CA1D
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567845; cv=none; b=XhRDav/FX+8Ixq8J9ohQgeqQfZWQGMzmr+dHoCLh+tE0gBpHtyRYcQIXJOm3gtzmQGEwB4u3gQgwky/PcO7r0mDBkb6w6JkZ5CwJ/x6i7+33DbqMKbkIN5FyWk5+MLPv5VS5hgfLfsjKQmM81ffAbPgRpLUIST4cTkgXDeBZ2Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567845; c=relaxed/simple;
	bh=s9cqKaPA99BcnU1cUwfS3ySc0cY8TJ+nCj6b/ClbIoM=;
	h=Date:To:From:Subject:Message-Id; b=j7sddaepbbJDqmotaHBVROszT1EplJyYJLTNfQJy4iQ3iZGp0A63cZCw0VI2aDHCOTP6/swP2sYeMePBbYfIOR6t6Y5RRew6xkMmC1JLMHUTsJwAtC8/B5qiDyK4A2xArenZBzI20B5dEVD041KSZLnoyp2wXf2L16/uzAVgbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rPucobO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rPucobO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5BEC4CEED;
	Sat, 26 Jul 2025 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567844;
	bh=s9cqKaPA99BcnU1cUwfS3ySc0cY8TJ+nCj6b/ClbIoM=;
	h=Date:To:From:Subject:From;
	b=rPucobO76HS3uGuUMpgHuVnLaCUjEyYXz5XmpB0IJ6dU17cm5K+11s71RzTQgPEhl
	 Mr15VmQxDxymFZ8Q4wzPX0ebwCaaGJqj4cS7RRFxH5wepQYdNOwOqhvt86M1ZM3Ddk
	 UDNSm6guudGxuf+ozNHA2K51fDOdCYzA5JQOQZsU=
Date: Sat, 26 Jul 2025 15:10:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-files-to-page-alloc-section.patch removed from -mm tree
Message-Id: <20250726221044.BC5BEC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing files to page alloc section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-files-to-page-alloc-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing files to page alloc section
Date: Tue, 22 Jul 2025 18:41:43 +0100

There are a couple of mm/-specific header files that were accidentally
missed previously, and some page ref debug code also that ought to live
here.

Link: https://lkml.kernel.org/r/20250722174143.147143-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-files-to-page-alloc-section
+++ a/MAINTAINERS
@@ -15880,6 +15880,7 @@ F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
+F:	mm/debug_page_ref.c
 F:	mm/fail_page_alloc.c
 F:	mm/page_alloc.c
 F:	mm/page_ext.c
@@ -15888,8 +15889,10 @@ F:	mm/page_isolation.c
 F:	mm/page_owner.c
 F:	mm/page_poison.c
 F:	mm/page_reporting.c
+F:	mm/page_reporting.h
 F:	mm/show_mem.c
 F:	mm/shuffle.c
+F:	mm/shuffle.h
 
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

