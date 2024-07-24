Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7779208D7
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 05:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721798908; cv=none; b=NrJcz4P1d1CZGthFX5kpWwmVwBuTsVWIL3ouTa5P0/PRTv+qe2dDePbe61/2qXf9yR8vvug13hh5KpHxwXlmRRxsh4F34qeJx+sUg/+Ls//O4JtGzX1k5p4czcEiYlw9jQnBb+hDdbqO5e1qUBemXQUFqeJmAp+FIOuhOZZ8qWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721798908; c=relaxed/simple;
	bh=fFqlZIOJdFDriQCRPSvcIhW8yOydItV+0ttrScUeXe0=;
	h=Date:To:From:Subject:Message-Id; b=gjvN7Bf6fqK1zfsacnTMeCbnHUrsh+kI1/LinzHckXdGbGStBokzM24T9VVg1VkfHzxTpQFuWxOiSNR1xZzUeHV+8jd7PoS2IcOEOLafWilErzH1QVbr+5n5lA74HsxkqGzTANErZb4SdlwRrscsFM0OC2UsDxyrDKykKTAZBhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MlhSnmcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MlhSnmcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421C8C32782;
	Wed, 24 Jul 2024 05:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721798908;
	bh=fFqlZIOJdFDriQCRPSvcIhW8yOydItV+0ttrScUeXe0=;
	h=Date:To:From:Subject:From;
	b=MlhSnmcC7M43tHBlPduo7DUMRr+KxfM2HmctujiLpbv7laFLpjYBHoclQvQc8eUuP
	 i706hjKMqVCormqR+oeop8FRplzKMC6O1CCWRe3IPiaW7M3/ekFzLYEXUdZP5Krd8c
	 R17fFdJ5JzWjDG18Q297FKbEx4esRCGqdhf02a4k=
Date: Tue, 23 Jul 2024 22:28:27 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch added to mm-unstable branch
Message-Id: <20240724052828.421C8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: extend 'usage' parameter so that cluster_swap_free_nr() can be reused
has been added to the -mm mm-unstable branch.  Its filename is
     mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: extend 'usage' parameter so that cluster_swap_free_nr() can be reused
Date: Wed, 24 Jul 2024 14:00:56 +1200

Extend a usage parameter so that cluster_swap_free_nr() can be reused by
both swapcache_clear() and swap_free().  __swap_entry_free() is quite
similar but more tricky as it requires the return value of
__swap_entry_free_locked() which cluster_swap_free_nr() doesn't support.

Link: https://lkml.kernel.org/r/20240724020056.65838-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused
+++ a/mm/swapfile.c
@@ -1344,7 +1344,8 @@ static void swap_entry_free(struct swap_
 }
 
 static void cluster_swap_free_nr(struct swap_info_struct *sis,
-		unsigned long offset, int nr_pages)
+		unsigned long offset, int nr_pages,
+		unsigned char usage)
 {
 	struct swap_cluster_info *ci;
 	DECLARE_BITMAP(to_free, BITS_PER_LONG) = { 0 };
@@ -1354,7 +1355,7 @@ static void cluster_swap_free_nr(struct
 	while (nr_pages) {
 		nr = min(BITS_PER_LONG, nr_pages);
 		for (i = 0; i < nr; i++) {
-			if (!__swap_entry_free_locked(sis, offset + i, 1))
+			if (!__swap_entry_free_locked(sis, offset + i, usage))
 				bitmap_set(to_free, i, 1);
 		}
 		if (!bitmap_empty(to_free, BITS_PER_LONG)) {
@@ -1388,7 +1389,7 @@ void swap_free_nr(swp_entry_t entry, int
 
 	while (nr_pages) {
 		nr = min_t(int, nr_pages, SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
-		cluster_swap_free_nr(sis, offset, nr);
+		cluster_swap_free_nr(sis, offset, nr, 1);
 		offset += nr;
 		nr_pages -= nr;
 	}
@@ -3472,15 +3473,9 @@ int swapcache_prepare(swp_entry_t entry)
 
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry)
 {
-	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
-	unsigned char usage;
 
-	ci = lock_cluster_or_swap_info(si, offset);
-	usage = __swap_entry_free_locked(si, offset, SWAP_HAS_CACHE);
-	unlock_cluster_or_swap_info(si, ci);
-	if (!usage)
-		free_swap_slot(entry);
+	cluster_swap_free_nr(si, offset, 1, SWAP_HAS_CACHE);
 }
 
 struct swap_info_struct *swp_swap_info(swp_entry_t entry)
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch

