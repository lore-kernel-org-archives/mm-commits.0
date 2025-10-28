Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CDA28D8E8
	for <mm-commits@vger.kernel.org>; Tue, 28 Oct 2025 22:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761691989; cv=none; b=EzpbsVDYf0jKlyssO9lUk1MdxfVDFABc8SxoDKxH6/l2T83WH9xfrl+d9Jg1mNr0zCpB94xUZGhWGfvD3BPSTTzbrNS8OG8bUVARgXaMyBqN8OO+hwMVGyzLzqdVLH+0QW8OK5WjwdnBU9f76rsmsqXMbbv62TBZ2ew6KFWbGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761691989; c=relaxed/simple;
	bh=Ar3bZRxrrFTkXGa+i47pHLLeiXhYLaJjMAzM43drW6Q=;
	h=Date:To:From:Subject:Message-Id; b=Qec9TElA99MG2j7zyiLQ/5c+8czONSRjPwtnpmBN9ZYDUQ40SqE6kB4Hu6mOqF6VHNcR1WgrtSpBe8WxlNmWjHH0i66T+u6PIvkrHP3b41sBMna9gbcV+pB/FhqTbQvuinzdpea0ZpNG7r6WANrihJpDSxIdGSmiLZisNs2uUq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=svXhLx2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="svXhLx2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755E8C4CEE7;
	Tue, 28 Oct 2025 22:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761691988;
	bh=Ar3bZRxrrFTkXGa+i47pHLLeiXhYLaJjMAzM43drW6Q=;
	h=Date:To:From:Subject:From;
	b=svXhLx2BPjz3ooVselwOgHClaJWM79YXedSBf7jfafI9Jr9+odE5++coxx90uBo/l
	 fU4ULiuon5SjcCpkpc85sWzq3pnHbrcoj+pVwW9TZiFtRQDXUQdQ4twlWANmk3oVZj
	 aw60lwxLnMWywrQZ0j7aF3WUOp7qp+3MEl1MdOAI=
Date: Tue, 28 Oct 2025 15:53:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,agordeev@linux.ibm.com,imbrenda@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-s390-fix-missing-present-bit-for-gmap-puds.patch added to mm-unstable branch
Message-Id: <20251028225308.755E8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: s390: fix missing present bit for gmap puds
has been added to the -mm mm-unstable branch.  Its filename is
     kvm-s390-fix-missing-present-bit-for-gmap-puds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-s390-fix-missing-present-bit-for-gmap-puds.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

kvm-s390-fix-missing-present-bit-for-gmap-puds.patch

