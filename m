Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672164;
	b=mODeQx/C8LXgxdJikeB8021/U8iZ0R5HhZAc7tWSgf9qjbwnCWBg2pAcDW0ThZkDpgZT
	 tejSX//4NC/rfaWF58wK2EEAi4BpXcxG8zVcFj0J1uZ99Dj7IzZjSvFG9Wen98h37F62F
	 EAtKnxiBlPnuA/eogurirDHPT1U5TrhRQALWyvnI5HpDaFhhLz++p0hT4H8r7oAy8gt56
	 vBLbXf6nUEdUJ2ocd6sbHyJ7efm9+sG3pdTNnpR1p7UErU1NLUoG9c9Cx65dfB7V3TjdV
	 N/5EvZcesgT16pAl7jibjyVWg5pd1EXQSW9K29FEIJdBu0mocGovB0E2jUmENlvkVcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672164;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9uUyVdOpt1Xv3h5L022vylVQ9svFS5f3ZOEBS9qeGTM=;
	b=ePInkND8wnMmF+qP70LuQ0TANmYr9lRDnvIsOnrpcN9Azp82CSOfzqUkcoeJL5XpXPey
	 qa1d/pVuiKUVBdkLIdmjnE3Jx9gwvT3lnbQ6JNf+1TO1qc3oK56wTPvvG6V6F3l5u4cmU
	 URA0+bIDCrR92WSRKRROqhC1xg56uCCiIGmOp8s2DRdGEyHoqkRuGy0Z3emlRTBV6E2u1
	 m6lhz/QNfg7T2dBItHdwiiRJ02jVydB94hJ6dZvHKtkBJJ9PRouhk8quvsjkfrXWvyY/Z
	 giBh2GV34PMB6j3ZGNX4DPs0krvmqayi/YMRTFfcwtmbpz26+WELDwCa9A3V2SRO13Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vf5kS0ST;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8942606A32D
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vf5kS0ST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7261F00A1B;
	Tue,  3 Nov 2026 02:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672163;
	bh=9uUyVdOpt1Xv3h5L022vylVQ9svFS5f3ZOEBS9qeGTM=;
	h=Date:To:From:Subject;
	b=vf5kS0STGFP1vCPtVmPkZXbBizpXOcBVHNaguz2MT9wAxNZHxo2DNhD/VL7fmGjpI
	 dgYhiqMdBXAvNu2N8r6aVsvRUVM0Glpg2nqpNNj+qH/SXe6UeG4gKpuOtJS6sq2jGq
	 WvtHpfE9BNVgq2Xa0+rALEzOqdDwLD9i7cTpRrPY=
Date: Mon, 02 Nov 2026 18:16:03 -0800
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
Subject: [merged mm-hotfixes-stable] maintainers-tmpfs-shmem-filesystem-updates.patch removed from -mm tree
Message-Id: <20261103021603.6B7261F00A1B@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
has been removed from the -mm tree.  Its filename was
     maintainers-tmpfs-shmem-filesystem-updates.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
Date: Fri, 30 Oct 2026 22:34:26 +0100

I am not really the best shmem/tmpfs/memfd expert around, but it should
be good enough to judge when something is ready to be picked up, to then
pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
for the more involved and more controversial bits.

Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
(SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
so people know whom to CC.

Add mm/core.git as the target git tree. Once shmem becomes a high volume
component we can dedicate it a separate tree and have dedicated people
pick it up.

While at it, add some more shmem/tmpfs/memfd related files+directories
we missed so far.

There is also "kernel/pid_sysctl.h", which includes some of the pid
namespaced sysctl vm.memfd_noexec. But that's really more of a proc/
namespace thingy, so it's not a good fit here.

Link: https://lore.kernel.org/20261030-maintainers-v1-2-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
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
Cc: Muchun Song <muchun.song@linux.dev>
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

 MAINTAINERS |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/MAINTAINERS~maintainers-tmpfs-shmem-filesystem-updates
+++ a/MAINTAINERS
@@ -17810,6 +17810,25 @@ S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
 
+MEMORY MANAGEMENT - SHARED MEMORY (SHMEM/TMPFS/MEMFD)
+M:	Hugh Dickins <hughd@google.com>
+M:	David Hildenbrand <david@kernel.org>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
+F:	Documentation/filesystems/tmpfs.rst
+F:	Documentation/mm/shmfs.rst
+F:	Documentation/userspace-api/mfd_noexec.rst
+F:	include/linux/memfd.h
+F:	include/linux/shmem_fs.h
+F:	include/uapi/linux/memfd.h
+F:	mm/memfd.c
+F:	mm/shmem.c
+F:	mm/shmem_quota.c
+F:	tools/testing/selftests/memfd/
+F:	tools/testing/selftests/tmpfs/
+
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Chris Li <chrisl@kernel.org>
@@ -28245,17 +28264,6 @@ S:	Maintained
 F:	Documentation/hwmon/tmp513.rst
 F:	drivers/hwmon/tmp513.c
 
-TMPFS (SHMEM FILESYSTEM)
-M:	Hugh Dickins <hughd@google.com>
-R:	Baolin Wang <baolin.wang@linux.alibaba.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	include/linux/memfd.h
-F:	include/linux/shmem_fs.h
-F:	mm/memfd.c
-F:	mm/shmem.c
-F:	mm/shmem_quota.c
-
 TOMOYO SECURITY MODULE
 M:	Kentaro Takeda <takedakn@nttdata.co.jp>
 M:	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

