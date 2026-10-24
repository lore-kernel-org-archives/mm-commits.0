Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832348;
	b=qcIO4LW87LENZHOaleDoVwmGl4/FZCpsgqGUCbGtrFp+R8nPvm2ZTY5Invos0S9Z9Egt
	 EfJXUnQJuOtpCSQXiRX47ESFONw66sMlJllitYRo0dvyDrpGXT8AbPQwDDKwVAnuUEeJB
	 ivb1s0AAWBTkKLVkFw0r8+3myI/5UP9VpOvJVqJmnNiqoK1poTHRiVkOMkwWW6Y1QNl95
	 p4UP9x5DJJKasuevG3Fiw8IK7DN/bSDVm/miLvarpY+1kD4l9+OmNEfXVY5hr/mJBpA8p
	 w694qlXQd/yLV1jeHdno0HFwuKRNK+Zf6h8C3mymOGYH30o4rYeiIteBIFWhSN11sVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832348;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pNNbwIfuqprDawX9E1FmH8otNsQImZL3gQhwxFDA/8U=;
	b=c0H7m7hmIRCsWvH1OWxDqcerDobG4FQci8OzECDc5z/E8VJOe81oDhOAiNnGk9dJ+iY3
	 aqr3ysbQAQQ0IAenypnOwHIBOuQriQk3Pe4hQyAu98r21LsJ71YpJPfvx+gI2ojXeiK+q
	 pB+nDXPmDn1HOwjkgo4ccEPGjjtWMwRcbw5TVe0V3f4HaY/ACorGT1YD+68lw1Zb4LN7p
	 V4oOYf4KpO7Y535EoxTCHmnYdhf6WomOug0cG0ekPS40nUxzKuc5D8xY0hclBpWAcl/t0
	 5G6IPci5xtzCg6LOFA9LkwqkcYAjzyLNVgGpC4svz1FDd37nDTCnN35NiLI9+4AnwDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="NLyx/roa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2B606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NLyx/roa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C081F01828;
	Sat, 24 Oct 2026 08:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832347;
	bh=pNNbwIfuqprDawX9E1FmH8otNsQImZL3gQhwxFDA/8U=;
	h=Date:To:From:Subject;
	b=NLyx/roayZup5mVBhsIp9kjPJQ6VWUgx3KwvDk+Sd46eoLkYA3/G/wESedy2SFZBr
	 p60hmJLNheMtt+f8FBZ7poW9xSkpQz/7T/EKIKWTkUS/Fx60pX4084EqTJq70pULa5
	 jQQptZZM37b/PORMwE67OZcgLkAs7NJ2UNA3Xz9Y=
Date: Sat, 24 Oct 2026 01:59:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch removed from -mm tree
Message-Id: <20261024085907.A8C081F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_to_online_page()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_to_online_page()
Date: Mon, 21 Sep 2026 21:59:05 +0200

Drop CONFIG_HAVE_ARCH_PFN_VALID handling, as CONFIG_HAVE_ARCH_PFN_VALID is
never used with CONFIG_MEMORY_HOTPLUG, as the latter depends on
CONFIG_SPARSEMEM_VMEMMAP.  Make sure it stays that way.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-13-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/memory_hotplug.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page
+++ a/mm/memory_hotplug.c
@@ -345,6 +345,8 @@ struct page *pfn_to_online_page(unsigned
 	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
 
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));
+
 	if (nr >= NR_MEM_SECTIONS)
 		return NULL;
 
@@ -352,13 +354,6 @@ struct page *pfn_to_online_page(unsigned
 	if (!online_section(ms))
 		return NULL;
 
-	/*
-	 * Save some code text when online_section() +
-	 * pfn_section_valid() are sufficient.
-	 */
-	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
-		return NULL;
-
 	if (!pfn_section_valid(ms, pfn))
 		return NULL;
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

