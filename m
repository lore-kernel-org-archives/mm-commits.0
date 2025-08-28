Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D7A2D0606
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756422550; cv=none; b=Eq8LIZ3twlvWu5u5xReWj7/CdN2grCfVtoQOGB/XxOz/p++uQQXwafAJiEVFOtOHHTnwy5FRRk2bPldEt3jgxA8iZ2t9TYChKbgQ4p6I4mUmyYt6Bo0c8uTWZIKfPgFonx09BW0UeJl5uVdR7k2LEF6/yChY7W2yF36KyQRQzbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756422550; c=relaxed/simple;
	bh=0MV2UdzwK1FFZiKJ+PN7WCtRranhhSMKBB4Per/EOSM=;
	h=Date:To:From:Subject:Message-Id; b=LKbYbWNujevQdhk0A3nVx+bl7ouq4bR1/xUWzcG8Ts+Chnb2rra7sNYrfpTPVD/YwenWjvlAwcrC2BJK7so5rJLcwYDrpt3wYnGHYHYWouXrqq28sZj3RKRJw3T5xtoexJjjxoj2+LgQJHLX8piRFtgpNeEBQMBU0+lqMQpzvUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eBM+cMIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eBM+cMIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFE0C4CEEB;
	Thu, 28 Aug 2025 23:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756422550;
	bh=0MV2UdzwK1FFZiKJ+PN7WCtRranhhSMKBB4Per/EOSM=;
	h=Date:To:From:Subject:From;
	b=eBM+cMIoA64Llw8Km4nvwnghZDbHpIcNWyYrdXYOuVZD+E4ym6z+iCKFFaIOs8KSB
	 qOtejHgu+Y5QGc5AQNBHdqvp+uzOYZogP89boZAnmLuupeQ5OnlM5DHKPgYf0l8Cds
	 TY6RXZMRlw3FEG0NrIXsU9D3op9I+z99wuudJZlc=
Date: Thu, 28 Aug 2025 16:09:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,nphamcs@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kasong@tencent.com,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,max.kellermann@ionos.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_mmh-disallow-is_huge_zero_folionull.patch added to mm-new branch
Message-Id: <20250828230910.2EFE0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: huge_mm.h: disallow is_huge_zero_folio(NULL)
has been added to the -mm mm-new branch.  Its filename is
     huge_mmh-disallow-is_huge_zero_folionull.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_mmh-disallow-is_huge_zero_folionull.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Max Kellermann <max.kellermann@ionos.com>
Subject: huge_mm.h: disallow is_huge_zero_folio(NULL)
Date: Thu, 28 Aug 2025 10:48:20 +0200

Calling is_huge_zero_folio(NULL) should not be legal - it makes no sense,
and a different (theoretical) implementation may dereference the pointer. 
But currently, lacking any explicit documentation, this call is possible.

But if somebody really passes NULL, the function should not return true -
this isn't the huge zero folio after all!  However, if the
`huge_zero_folio` hasn't been allocated yet, it's NULL, and
is_huge_zero_folio(NULL) just happens to return true, which is a lie.

This weird side effect prevented me from reproducing a kernel crash that
occurred when the elements of a folio_batch were NULL - since
folios_put_refs() skips huge zero folios, this sometimes causes a crash,
but sometimes does not.  For debugging, it is better to reveal such bugs
reliably and not hide them behind random preconditions like "has the huge
zero folio already been created?"

To improve detection of such bugs, David Hildenbrand suggested adding a
VM_WARN_ON_ONCE().

Link: https://lkml.kernel.org/r/20250828084820.570118-1-max.kellermann@ionos.com
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/huge_mm.h~huge_mmh-disallow-is_huge_zero_folionull
+++ a/include/linux/huge_mm.h
@@ -501,6 +501,8 @@ extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
+	VM_WARN_ON_ONCE(!folio);
+
 	return READ_ONCE(huge_zero_folio) == folio;
 }
 
_

Patches currently in -mm which might be from max.kellermann@ionos.com are

pagevech-add-const-to-pointer-parameters-of-getter-functions.patch
huge_mmh-disallow-is_huge_zero_folionull.patch

