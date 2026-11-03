Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672168;
	b=uneMaFVoY/cgAqg9dXodnOmpnbNbuEAy8w8RF97o37ir3Fd9VdwhG6R9+NJjcAqqmxbu
	 R5hEZU3YCAK5C39nTe44m7S1+TXL0c6bYsmgUJJwFdltuF6lSGQJnjs9WAJGFQkksgiSv
	 5sI2/YjewA4e/Mg396x5u93h9JoA2J2Uq9QxMKTS07q71COJL1saafPGYUXclTsiKnHe1
	 XGEi6LpXXa8k/0ofdx6A30rshr/eQd9Tqy7HEIazx3UIvvkrMAdcjwCe2A9ewoXbXoSk5
	 F82a/lZFWyTAN6GodkgubjQPUHacc6n4FY0a45+ikwdowEnqEoYo9VyVlMlMwSvJ/5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672168;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ymBWhViXmd542zAj7gPkC5LIFtv9YrMGyhScF/T62wo=;
	b=umFeRxJWGYWhp9vYNaCPLbgFcHlY/MuOfb4WPExHHPt6c9lIu2BzGo5dVL/WOBz6aQcj
	 Glc/C6oWVwrLQonpjQLwdJObECT/3qTPBZoNGka9HFe+u6G4iZkf2FKnWqcRA/jqo1o+k
	 qDvEZouFjpovQ+iZl7kv8XU1/F9XzWTt7rKDe+JlavQ8o8W+BVhdRBLWlC9/Khg9KE7X3
	 94mxFkVevgJB+bToAHfsHxE78R5TIwuk28KFNvO+Qcpk525hWVJEq6XzDSW2owSvt+kx7
	 WamAwK8l/FpNByjffmYcMjvb4hpekSDp/E4CT1LFWtbTQAL7hdEJ2KL70cigI8D7lMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lONxdWHY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84037606A32D
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lONxdWHY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0969C1F000C1;
	Tue,  3 Nov 2026 02:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672168;
	bh=ymBWhViXmd542zAj7gPkC5LIFtv9YrMGyhScF/T62wo=;
	h=Date:To:From:Subject;
	b=lONxdWHYiGHP+V4RQSiS3zU1RhSpDjRtcdhktKuxWkVfOV/Yh2ZKJ3JOKZRSLLMsB
	 u8ojcrtCtJ9u2b97gylz56NfqTyMbY4ymX7mQKpPBcHwTSDGF/8eRf317Nfd34Yi5Y
	 TVSmDGTlZTcP1IFyfXjCYxbz6qvjWkaI3mTZGL+s=
Date: Mon, 02 Nov 2026 18:16:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,
	ying.huang@linux.alibaba.com,xu.xin@linux.dev,will@kernel.org,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tj@kernel.org,
	surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,
	shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,
	roman.gushchin@linux.dev,rientjes@google.com,riel@surriel.com,
	rakie.kim@sk.com,qi.zheng@linux.dev,pfalcato@suse.de,peterz@infradead.org,
	peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nphamcs@gmail.com,
	nico.pache@linux.dev,nao.horiguchi@gmail.com,muchun.song@linux.dev,
	mhocko@kernel.org,matthew.brost@intel.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,
	kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,hughd@google.com,
	harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,gourry@gourry.net,
	dev.jain@arm.com,dennis@kernel.org,david@fromorbit.com,cl@gentwo.org,
	chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,
	brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,apopple@nvidia.com,aneesh.kumar@kernel.org,
	david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-rename-and-move-memory-hotunplug.patch removed from -mm tree
Message-Id: <20261103021608.0969C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
has been removed from the -mm tree.  Its filename was
     maintainers-rename-and-move-memory-hotunplug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
Date: Fri, 30 Oct 2026 22:34:30 +0100

Prefix "MEMORY HOT(UN)PLUG" with "MEMORY MANAGEMENT" and put it into the
right spot in the MM component section list.

Link: https://lore.kernel.org/20261030-maintainers-v1-6-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
---

 MAINTAINERS |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/MAINTAINERS~maintainers-rename-and-move-memory-hotunplug
+++ a/MAINTAINERS
@@ -17461,22 +17461,6 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/linux.git
 F:	drivers/devfreq/tegra30-devfreq.c
 
-MEMORY HOT(UN)PLUG
-M:	David Hildenbrand <david@kernel.org>
-M:	Oscar Salvador <osalvador@suse.de>
-L:	linux-mm@kvack.org
-L:	linux-cxl@vger.kernel.org
-S:	Maintained
-F:	Documentation/ABI/testing/sysfs-devices-memory
-F:	Documentation/admin-guide/mm/memory-hotplug.rst
-F:	Documentation/core-api/memory-hotplug.rst
-F:	drivers/base/memory.c
-F:	include/linux/memory_hotplug.h
-F:	include/linux/memremap.h
-F:	mm/memory_hotplug.c
-F:	mm/memremap.c
-F:	tools/testing/selftests/memory-hotplug/
-
 MEMORY MANAGEMENT
 M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
@@ -17614,6 +17598,22 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
+MEMORY MANAGEMENT - MEMORY HOT(UN)PLUG
+M:	David Hildenbrand <david@kernel.org>
+M:	Oscar Salvador <osalvador@suse.de>
+L:	linux-mm@kvack.org
+L:	linux-cxl@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-devices-memory
+F:	Documentation/admin-guide/mm/memory-hotplug.rst
+F:	Documentation/core-api/memory-hotplug.rst
+F:	drivers/base/memory.c
+F:	include/linux/memory_hotplug.h
+F:	include/linux/memremap.h
+F:	mm/memory_hotplug.c
+F:	mm/memremap.c
+F:	tools/testing/selftests/memory-hotplug/
+
 MEMORY MANAGEMENT - MEMORY MAP
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

