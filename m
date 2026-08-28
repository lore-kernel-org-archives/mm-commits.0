Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D63359A68
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787938687; cv=none; b=FCOPoETlKnjMp1Q81C66S3KHoN/OcRPZ6cWwbyIeE1fgaHiGxoyRDIpHKu6/bnuaVVNJakiIPI5C/AF6yfKrSEt1LwhIZ5wbCfGnF3xiE7V3qZWuF/Lq2V7l5t9syNokldr7/oVdOy4g/AVJNr14V+/kofvDGbnvxqFrEtTzfj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787938687; c=relaxed/simple;
	bh=qrW+lvkb20xy9is/YkgbEOTjeV4Whp2Hs1jGxpT5oCc=;
	h=Date:To:From:Subject:Message-Id; b=OhCubxrStkUQacwnc+tJj5b4IXbK/BZdDsZKuGiKQe28YIJqDSjEk6kU2Ym2P821jmE+xPUvwI9TDLpz5q2Zkl9TsUS0W/Egyg/WrVK1V/3E2uAPazbSwIlcCrd/JyeZ4MF0LHlSl/w0eALZWdycxNEvDswZeQnsktxKSgxagWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IPhKEi9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IPhKEi9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDF11F000E9;
	Fri, 28 Aug 2026 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787938685;
	bh=7ZW5Ai3TFtgUpXm795dD5xiSKdp6mt8DWBER1orfkCc=;
	h=Date:To:From:Subject;
	b=IPhKEi9rJ6QNSrxTSiBpvqAFVxGBmnxECMLRyA0wQwV5oxnL4u0DXCs5ouX06Ycsz
	 FndhHaWL/WvfJj7D68AKHCqE73qjzVrORx9w4gwlRhULw4/C9ivpjjIxDTmFqn4vnw
	 qVS5PAgiJ0Ja4fC6UlPEeDXxCwlN7FgE1noxLB0Q=
Date: Fri, 28 Aug 2026 10:38:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,saravanand@crusoe.ai,ryan.roberts@arm.com,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,clg@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260828173805.4CDF11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
Date: Fri Aug 28 10:35:55 AM PDT 2026

s/vma_check_thp_tuneables_file/vma_file_check_thp_tuneables/, per Zi Yan

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Cedric Le Goater <clg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Saravanan D <saravanand@crusoe.ai>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
+++ a/mm/huge_memory.c
@@ -143,7 +143,7 @@ static bool vma_thp_tuneables_allow_file
 	return false;
 }
 
-static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type type)
 {
 	return vma_bypass_thp_tuneables_file(vma, type) ||
@@ -159,7 +159,7 @@ static bool vma_can_map_huge_file(const
 	 * Enforce THP collapse requirements as necessary. Anonymous vmas
 	 * were already handled in thp_vma_allowable_orders().
 	 */
-	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
 		return false;
 
 	switch (type) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

