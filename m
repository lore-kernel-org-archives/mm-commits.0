Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775974C81
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749333054; cv=none; b=YiDOkN9AXOi0Wg0T08UBPpwJolyLGLlWEzEsnv8ZUfk92+zW4tmA0t3LmqwXNhEjsWspeyU2uoH0H03PxdqQv7HV4c+iIhpiT5nJCKJPRwI40ja6g3E6ji4s4t1z8gs6co+mR1RmjW+zFh+ebuXFFqxlQKedPsmyj7jWJU3+gb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749333054; c=relaxed/simple;
	bh=x5w67siUVBylYOIkXlORex1CAldpj2uBG9TuoR+Ep38=;
	h=Date:To:From:Subject:Message-Id; b=DGNuBx4kmSgOxHYyQeTThuqB2ZoyaKlgDCiALUrtl8n4cZEWzzMZd1/Im/6MthhA7BhTFbZl6o8+Etg78CJNgzWvAN4Ki0vDPbgDRiIdXm6OdgA3fXgEwUxfmBgNAVqC1IuM7o7VW8GFUl9y0OyzXnLiLoUdHj4y3RbD/AiF0hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JL7604Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JL7604Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CF5C4CEE4;
	Sat,  7 Jun 2025 21:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749333054;
	bh=x5w67siUVBylYOIkXlORex1CAldpj2uBG9TuoR+Ep38=;
	h=Date:To:From:Subject:From;
	b=JL7604VtWIBLttGn/I7uvaIc4TymTkJ9RY5oA+v/VF0g/KsQ8NfLYR516MDM5N4nH
	 F9u7u0n/620nhVhECM6yksOYn4r4aEWf2GDcpE1uMxThb885r/7mvkaOVUjgkoVv+s
	 +o4EvPqKUaRl0xVLSfxkNP9gcSEGLDlT9zvBrKDs=
Date: Sat, 07 Jun 2025 14:50:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-disallow-hugepages-if-the-system-wide-thp-sysfs-settings-are-disabled.patch removed from -mm tree
Message-Id: <20250607215053.E5CF5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: disallow hugepages if the system-wide THP sysfs settings are disabled
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-disallow-hugepages-if-the-system-wide-thp-sysfs-settings-are-disabled.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: disallow hugepages if the system-wide THP sysfs settings are disabled
Date: Thu, 5 Jun 2025 16:00:58 +0800

Patch series "fix MADV_COLLAPSE issue if THP settings are disabled", v2.

As we discussed in the previous thread [1], the MADV_COLLAPSE will ignore
the system-wide anon/shmem THP sysfs settings, which means that even
though we have disabled the anon/shmem THP configuration, MADV_COLLAPSE
will still attempt to collapse into a anon/shmem THP.  This violates the
rule we have agreed upon: never means never.  This patch set will address
this issue.


This patch (of 2):

MADV_COLLAPSE will ignore the system-wide Anon THP sysfs settings, which
means that even though we have disabled the Anon THP configuration,
MADV_COLLAPSE will still attempt to collapse into a Anon THP.  This
violates the rule we have agreed upon: never means never.

Another rule for madvise, referring to David's suggestion: “allowing for
collapsing in a VM without VM_HUGEPAGE in the "madvise" mode would be
fine".

To address this issue, should check whether the Anon THP configuration is
disabled in thp_vma_allowable_orders(), even when the TVA_ENFORCE_SYSFS
flag is set.

In summary, the current strategy is:

1. If always & orders == 0, and madvise & orders == 0, and
   hugepage_global_enabled() == false (global THP settings are not
   enabled), it means mTHP of that orders are prohibited from being used,
   then madvise_collapse() is forbidden for that orders.

2. If always & orders == 0, and madvise & orders == 0, and
   hugepage_global_enabled() == true (global THP settings are enabled),
   and inherit & orders == 0, it means mTHP of that orders are still
   prohibited from being used, thus madvise_collapse() is not allowed for
   that orders.

Link: https://lkml.kernel.org/r/8eefb0809c598fadaa4a022634fba5689a4f3257.1749109709.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/all/1f00fdc3-a3a3-464b-8565-4c1b23d34f8d@linux.alibaba.com/ [1]
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-disallow-hugepages-if-the-system-wide-thp-sysfs-settings-are-disabled
+++ a/include/linux/huge_mm.h
@@ -287,20 +287,35 @@ unsigned long thp_vma_allowable_orders(s
 				       unsigned long orders)
 {
 	/* Optimization to check if required orders are enabled early. */
-	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
-		unsigned long mask = READ_ONCE(huge_anon_orders_always);
+	if (vma_is_anonymous(vma)) {
+		unsigned long always = READ_ONCE(huge_anon_orders_always);
+		unsigned long madvise = READ_ONCE(huge_anon_orders_madvise);
+		unsigned long inherit = READ_ONCE(huge_anon_orders_inherit);
+		unsigned long mask = always | madvise;
 
+		/*
+		 * If the system-wide THP/mTHP sysfs settings are disabled,
+		 * then we should never allow hugepages.
+		 */
+		if (!(mask & orders) && !(hugepage_global_enabled() && (inherit & orders)))
+			return 0;
+
+		if (!(tva_flags & TVA_ENFORCE_SYSFS))
+			goto skip;
+
+		mask = always;
 		if (vm_flags & VM_HUGEPAGE)
-			mask |= READ_ONCE(huge_anon_orders_madvise);
+			mask |= madvise;
 		if (hugepage_global_always() ||
 		    ((vm_flags & VM_HUGEPAGE) && hugepage_global_enabled()))
-			mask |= READ_ONCE(huge_anon_orders_inherit);
+			mask |= inherit;
 
 		orders &= mask;
 		if (!orders)
 			return 0;
 	}
 
+skip:
 	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch
mm-shmem-disallow-hugepages-if-the-system-wide-shmem-thp-sysfs-settings-are-disabled.patch

