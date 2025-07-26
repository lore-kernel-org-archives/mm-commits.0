Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FDB220F3F
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567851; cv=none; b=T9nk2NrdToimCK8zNhstHlV6jagUEGne6uFZ1asY2jpkFbM8loIw0DOIuGdvoKeMsRg+jatoVE0Di3v/Un+Zwp2jBoC6SvWA635R6r7IRd2lozcTE+48HDSqQHXVkPQngze2Afp+JwB9RJiMNdvGWsd+kl8+kmvZtR4JgjgNRqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567851; c=relaxed/simple;
	bh=dXRw6qncQrzdXPbarO14TEJ4iGf6ec75Z4FaAG41Kp8=;
	h=Date:To:From:Subject:Message-Id; b=BXGESKT2sz0ANiXDvH0E6+LMwDZGFZZkv3XRSNVXep8DfPl4LjYrlLjrZp/Ug+4PcxdibWez9THeH5lhZ6fy7MojWVP/waPnFvyeO0j1zv3gQ83Gd2tYGBO+qweVaBun1+ezm8gq6lrnIBL3jZuu4IfrmMjw8n5shgmbmCdCy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TuR/y7hL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TuR/y7hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC163C4CEED;
	Sat, 26 Jul 2025 22:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567850;
	bh=dXRw6qncQrzdXPbarO14TEJ4iGf6ec75Z4FaAG41Kp8=;
	h=Date:To:From:Subject:From;
	b=TuR/y7hLQGPPEqC1FPptrOWp+gUM7BpIHsSoPsT4QIzAE4/wUIlAEC5u0VgVy05vI
	 rmxNrHZn0LX+oSZCojxfdXsEZ9IJS/ysoiuBVZR5+2Hmg8ZQ7wRjk4Q5JTuHh8yQkq
	 LD1s+lWBbNlRKdoREzN2NOO7mxxVcUBdf+9kk7sE=
Date: Sat, 26 Jul 2025 15:10:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-file-to-cgroup-section.patch removed from -mm tree
Message-Id: <20250726221050.AC163C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing file to cgroup section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-file-to-cgroup-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing file to cgroup section
Date: Thu, 24 Jul 2025 14:54:21 +0100

The page_counter files seems most appropriately placed here.

Link: https://lkml.kernel.org/r/20250724135421.54510-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-file-to-cgroup-section
+++ a/MAINTAINERS
@@ -6163,9 +6163,11 @@ L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memcontrol.h
+F:	include/linux/page_counter.h
 F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
+F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

