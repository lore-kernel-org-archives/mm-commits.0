Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F2315D36
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025776; cv=none; b=PU6fRVz0Hk+WBEzXcUH25DjOCP+f3XXpnTmcEDE3tjdDtv8e/WGJLMOALfq1BTNnKpIDsjVZwJF+XswqYKdG71h8Ivi7Sz/a+3XvhO8982EZzy5PFtLBQ61Vq+iRmcVN1ZkBRpVGzIcaUflgt9EDuF0DodIrE8j5fJ2a9fOupO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025776; c=relaxed/simple;
	bh=FLqzazmUJj7zRO2kt05F8qJIUd6oGqmLlfCZEYR7jTY=;
	h=Date:To:From:Subject:Message-Id; b=Cq2Xaarl1HKUZNgMK5Qnz4n8Ks3YyAoYfYqiTVZ6EaWiFIFph0PvklQ8FmHRTMex8a5IN3tRc4ceBFeUcdoiyJKiQJdT/9lke2boILKANgZ6DZDzYKzfUjtFXjylBrMRAcF3E+d1tiuS4Z5aBQtZ4Ah3LyIPD3dRH3m/HzibGPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VWRlEBZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VWRlEBZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0220C4CEF1;
	Mon, 24 Nov 2025 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025775;
	bh=FLqzazmUJj7zRO2kt05F8qJIUd6oGqmLlfCZEYR7jTY=;
	h=Date:To:From:Subject:From;
	b=VWRlEBZDRQkU79m511+/h3IUcJP74giZRom/8t0HkYwxGeGlLBLXeyJtxav5xSh49
	 CHOpSxsOPNVuUcslwyghmDGeRcaeU854hd1fOlN2KqmsN7KeBGYuv1iAuLcd2Q6V1X
	 vj/laXFR5X8T8uZ2idCTIhQFN+7pPQr6nFl6NIuA=
Date: Mon, 24 Nov 2025 15:09:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,agordeev@linux.ibm.com,imbrenda@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kvm-s390-fix-missing-present-bit-for-gmap-puds.patch removed from -mm tree
Message-Id: <20251124230935.C0220C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: s390: fix missing present bit for gmap puds
has been removed from the -mm tree.  Its filename was
     kvm-s390-fix-missing-present-bit-for-gmap-puds.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: KVM: s390: fix missing present bit for gmap puds
Date: Tue, 28 Oct 2025 14:01:50 +0100

For hugetlbs, gmap puds have the present bit set.  For normal puds (which
point to ptes), the bit is not set.  This is in contrast to the normal
userspace puds, which always have the bit set for present pmds.

This causes issues when ___pte_offset_map() is modified to only check for
the present bit.

The solution to the problem is simply to always set the present bit for
present gmap pmds.

Link: https://lkml.kernel.org/r/20251028130150.57379-2-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/lkml/20251017144924.10034-1-borntraeger@linux.ibm.com/
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/gmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/gmap.c~kvm-s390-fix-missing-present-bit-for-gmap-puds
+++ a/arch/s390/mm/gmap.c
@@ -599,8 +599,9 @@ int __gmap_link(struct gmap *gmap, unsig
 					| _SEGMENT_ENTRY_GMAP_UC
 					| _SEGMENT_ENTRY;
 			} else
-				*table = pmd_val(*pmd) &
-					_SEGMENT_ENTRY_HARDWARE_BITS;
+				*table = (pmd_val(*pmd) &
+					_SEGMENT_ENTRY_HARDWARE_BITS)
+					| _SEGMENT_ENTRY;
 		}
 	} else if (*table & _SEGMENT_ENTRY_PROTECT &&
 		   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {
_

Patches currently in -mm which might be from imbrenda@linux.ibm.com are


