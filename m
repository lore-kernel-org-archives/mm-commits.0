Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794336775;
	b=vhPc3GbakeajU1t3lyqNRIxK4bknQ1KGCw3B12PAERLuLoP7tycOd5CXLGcp+GJ0ihsc
	 vUN2y8rxDO9tHwJU7pSJlzoYscF92GLY/i41UvcXNyFJzjGskhIzdMwIXt5F3zb4GYuzR
	 uX+QCgrngd5TTMRcfBCJopIzHotj8igxXyP9UM4hILL//BsaVBZdAjqbwyo+dHlWbZTDB
	 1OAeYNhdj3FyR5kXdmp23jTRIVrJEomOswBOhSL5RBL7sPyRoDDSc/9uERExiCtws/y+8
	 wnd9qaaNo3QMM3106C0r3GNMa6TqQeA5JoXOoZIsCM62c2ZSQjbufudj9epuReojb1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336775;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FyYRKqyjit6kqOpgo3Sg4tVEg2xgxbh46RYiHPpWbkY=;
	b=Eyz3xsnBwD+J0Gv0aWqOZmeqMGtEMHLBVZpUNeOnyt3fiThjVhiLvS/yEtcGn1wzEkgl
	 SB7n318ndzBETqfdfxvWYOAcPDvKFbfgVTlUU07JKf35KX5wDRXEjt7YsJFNhGMssci9Y
	 gYK8cCimL54m2EgPKlcLb6OlsarfZdPeOpDcB1wWS6Z8HD41hQInbnAaGo7QV/VhUYCAL
	 ZBqSkhZ5QkBoVRoxr3zL7aFQGU5KZARNMcPh32p2YPs3tlxIl69DnEPcgf4qYVry+iBlI
	 oaIrfEgAQKAB5Zx+G0eFHB2V9NCBICr97JTY3AT4478aGOoiEA7JTndUj9h13nTXj4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=awJ7QRIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C31606A326
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=awJ7QRIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9FA1F0089F;
	Tue, 10 Nov 2026 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794336774;
	bh=FyYRKqyjit6kqOpgo3Sg4tVEg2xgxbh46RYiHPpWbkY=;
	h=Date:To:From:Subject;
	b=awJ7QRILQJV2iyvcUK0357z3eWDBWKqMpNVtAtJsOHpjOEA7SCAx6V/q1R3rYhpaD
	 G1L8E8FclyzVdbHCUr2BMI3eccIHQuioCKdkmrIYb1MdJDng24J5/0+iu6NldavBu8
	 AaagCoovapzSKeQkhEEcVkmTIXj4be2LeJu1ybSc=
Date: Tue, 10 Nov 2026 10:52:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,work@onurozkan.dev,
	vbabka@kernel.org,usama.arif@linux.dev,urezki@gmail.com,tmgross@umich.edu,
	tamird@kernel.org,surenb@google.com,shakeel.butt@linux.dev,
	ryan.roberts@arm.com,rppt@kernel.org,qi.zheng@linux.dev,ojeda@kernel.org,
	nico.pache@linux.dev,mhocko@suse.com,lossin@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,hannes@cmpxchg.org,gary@garyguo.net,
	dev.jain@arm.com,david@kernel.org,daniel.almeida@collabora.com,
	dakr@kernel.org,boqun@kernel.org,bjorn3_gh@protonmail.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,aliceryhl@google.com,
	a.hindborg@kernel.org,acourbot@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch added to mm-hotfixes-unstable branch
Message-Id: <20261110185254.7E9FA1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: remove myself from MM misc, reclaim reviewership
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: remove myself from MM misc, reclaim reviewership
Date: Tue, 10 Nov 2026 12:03:08 +0000

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

Therefore, remove myself as a reviewer.

Link: https://lore.kernel.org/20261110-drop-reviewerships-v1-2-07c2f06e8dfa@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Benno Lossin <lossin@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Tamir Duberstein <tamird@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Onur Özkan <work@onurozkan.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-mm-misc-reclaim-reviewership
+++ a/MAINTAINERS
@@ -17674,7 +17674,6 @@ F:	mm/migrate_device.c
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -17810,7 +17809,6 @@ R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/trace/events/vmscan.h
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-from-mm-core-reviewership.patch
maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch
maintainers-remove-myself-from-mm-rust-reviewerships.patch
credits-add-entry-for-thp-maintenance.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
revert-mm-khugepaged-remove-definition-of-struct-khugepaged_mm_slot.patch
mm-khugepaged-scan-mms-more-efficiently-under-mmap_lock-contention.patch
mm-khugepaged-release-contended-mmap-read-lock-after-scanning-enough-vmas.patch

