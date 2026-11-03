Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672165;
	b=VrW0uyVWeeELdMjwnXMGX+hu00zoo+ubdgXLMQTGJrpuPG3ejBoXQuYtsrxSmTo36hHQ
	 t/XcX4ea/UnDNaQLptmyhsP62qF0qF2oD2aBZgBRTxCBFxruv3SLaHdxLMCwUqUYlsMap
	 ggkblUurts2C7YY96VOJTn7k6/LEkS+wEpwwGAQQxD4MyNn4Ktng9CTR+oyJ9YXXwWraK
	 uXl226XBm6Ybxm93ai52PAoQUDNmKw8sPjfWuAZKLUNRXRQR63Wg+78fzJA5gu2QnEaYU
	 0CjTPDHiWjgveyXJ2D3q9Q3UDQf1ZG32DGYrgAAkl3xS+L2bG5JYgv/++BBcp/Ex0rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672165;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0/sUODruymo9tT05tiTaTxFBVWQzd/7QZaVlghO4GNk=;
	b=OiftBp1fyDFE3dPY3cblzpEDn8JZ7nnZ+XQ75/dF1ycEuen20CHDyFKv79n43Pyl98PI
	 6Gd6Wp/5rDRStt7rQDxz75tI82CSF8Pei6iaU0Fb9fMEgIahPmSKxBnCuNx2I6KPYdx8J
	 0gsEmp+l4AzEXiLAIX/Xc0x/6I+hYyM0nxX8GXUEKP3eN0ifR/pGdJPSvI/Xsdj8C6nY1
	 QCX3p55ApSNiyum0XrayGvAIZJJDAdZ2/gCq5QdKwo01r1YFBiMcotTJae5a4B2eTu8J6
	 hI4er1pCv/L+rtITT4xI4A3UH+9203OyABKwPbglMblwF6YDLbCnRa1PfzuVuJf0p0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BELOIquQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8FE606A32E
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BELOIquQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958C81F00A18;
	Tue,  3 Nov 2026 02:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672164;
	bh=0/sUODruymo9tT05tiTaTxFBVWQzd/7QZaVlghO4GNk=;
	h=Date:To:From:Subject;
	b=BELOIquQdzddAdmVkbBuZczSLm052EN2o8izvDZGHBDM46EGrWN2rB11RxSGOuM1x
	 Na7Aw2MddfZBGe+tZaFM+wVuiLNHsp6W7V3kSR3W0kedHF+N8UKd5E5GM9FeRiM4yh
	 m3DSkqetEVSQcWxgsWoqbVtQqFHIPoNWecH7z//c=
Date: Mon, 02 Nov 2026 18:16:04 -0800
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
Subject: [merged mm-hotfixes-stable] maintainers-add-zi-yan-as-co-maintainer-for-memory-management-thp.patch removed from -mm tree
Message-Id: <20261103021604.958C81F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
has been removed from the -mm tree.  Its filename was
     maintainers-add-zi-yan-as-co-maintainer-for-memory-management-thp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
Date: Fri, 30 Oct 2026 22:34:27 +0100

Zi has been contributing to THP consistently and reliably over many
years and is considered one of our most valuable THP experts. As THP is
an especially active area lately, having a single dedicated THP maintainer
is not sustainable.

Fortunately, Zi volunteered to take on more responsibility by stepping
up as a THP co-maintainer. So let's do exactly that.

His placement in the MAINTAINERS entry is very convenient to perform
this change :)

Link: https://lore.kernel.org/20261030-maintainers-v1-3-97278f8a5f54@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Dev Jain <dev.jain@arm.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hao Li <hao.li@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
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

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-zi-yan-as-co-maintainer-for-memory-management-thp
+++ a/MAINTAINERS
@@ -17855,7 +17855,7 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Zi Yan <ziy@nvidia.com>
+M:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Nico Pache <nico.pache@linux.dev>
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

