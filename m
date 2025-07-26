Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7EE244690
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567836; cv=none; b=rhpd8VbxQkLX5XIn2IzlVzGoEZDfuH7qE+nFNmXjkgztCD7EHeJYHnpKsMXBirhKYOOU4V/iWp6HBruJg5mevqM/Sie7sKflV31pQG58Lhjt4ojblTDLhHM2LrTZ93xcSKVntrg7qzmC5/8+eJiGGGnPlPodDsO3LfRH3dbWveM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567836; c=relaxed/simple;
	bh=Lka3LVZ87TyhNOAth5xKTRuwN8hJ6wnLPvPwkvREqo4=;
	h=Date:To:From:Subject:Message-Id; b=j1H1h503pFVhgHQMtZpyTNv7+GdaZ+RoMmYOhJ6afIjlnOsvT/IljZE5N7W/Tr7h+RuvzY2essCkcLEbB8LdHuQb04muNgvjnr0UkDRUArWMU/bRnSQAKEF8T+HCOykIdSLAZoon8cES+qyb49YHDCY6LqYiQhUxUIzeuQhO+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exiUhQDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exiUhQDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4ACC4CEED;
	Sat, 26 Jul 2025 22:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567836;
	bh=Lka3LVZ87TyhNOAth5xKTRuwN8hJ6wnLPvPwkvREqo4=;
	h=Date:To:From:Subject:From;
	b=exiUhQDUGHIUozL8Q0MPZQqDA/4KZlwfmYULEelVXHgz+82fV6vNedhXwo4niYO2g
	 Os0TeJO0wmKMkog4p5ykDBqlqxgvpIM5JAwJVQ951gkkucrWL0z3SAp2ydVJFrfvmy
	 V5/n+Kxo9zQ+HivNwfukYVjtIv4inoq4CVaBibcI=
Date: Sat, 26 Jul 2025 15:10:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-missing-interval_treec-to-memory-mapping-section.patch removed from -mm tree
Message-Id: <20250726221036.6F4ACC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add missing interval_tree.c to memory mapping section
has been removed from the -mm tree.  Its filename was
     maintainers-add-missing-interval_treec-to-memory-mapping-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing interval_tree.c to memory mapping section
Date: Tue, 22 Jul 2025 18:15:28 +0100

This seems to be the best place for this file.

Link: https://lkml.kernel.org/r/20250722171528.141083-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Pedro Falcato <pfalcato@suse.de>
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
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-interval_treec-to-memory-mapping-section
+++ a/MAINTAINERS
@@ -16007,6 +16007,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
+F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

