Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E30017B505
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547814; cv=none; b=pxFWd/cAea0V5zX5GfyCwUwadrbqRyjP59yeI56XKV3YpYi3bp6rwJh3mtOu4YCMo4Bdqs2gscqrlm1uMyjiHA+zbi/SHDQxAGutW8nX6H6GeyILA6gdTSKarbALAIW6AaFkO0JgdtQJfoKOGbCsqfXOuldl026/ghaLHcNCovo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547814; c=relaxed/simple;
	bh=LQc0pUN81kPj/7YD5S58BL2uttWQmr7LEQIWHnKAnEc=;
	h=Date:To:From:Subject:Message-Id; b=S0DZOagteAgUoCZb0Vuy1iMrX8dG10ySjCSrwFEIFqGZ4z9p9Yb5GK11S3cVED9Gu3Ys0DUprv8ImrVizQosfn1qbkdsVc87zsg4mG3Lu0UewPkvDk2TQYMLMb1tqGcDueUciD8RhVxSOF0dxA4TFOmz+pkhOoUEw4krm89xVFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z+0b89+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z+0b89+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7467C4CEF7;
	Fri, 20 Feb 2026 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547813;
	bh=LQc0pUN81kPj/7YD5S58BL2uttWQmr7LEQIWHnKAnEc=;
	h=Date:To:From:Subject:From;
	b=Z+0b89+9IPZOpICVTiUVP8xW0TRuH9o0RsYNwan+rZNYKG1PrgZPsa+ojzxTN4/hi
	 zMlpvsYhaGskp/hSi4tRcO2b5GzWBCsXglL4zsG8f7Iz4lHY6EJHCdZAFryCVxuerq
	 5w28y2fh8+HNGGVdZCak2co9ftWSvooWokLmxirw=
Date: Thu, 19 Feb 2026 16:36:53 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-the-swap-table-to-track-the-swap-count-fix.patch added to mm-new branch
Message-Id: <20260220003653.C7467C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-use-the-swap-table-to-track-the-swap-count-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-use-the-swap-table-to-track-the-swap-count-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-the-swap-table-to-track-the-swap-count-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-use-the-swap-table-to-track-the-swap-count-fix
Date: Wed, 18 Feb 2026 20:22:54 +0800

fix build

Link: https://lkml.kernel.org/r/aZWuLZi-vYi3vAWe@KASONG-MC4
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602181835.58TEynxc-lkp@intel.com/
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-the-swap-table-to-track-the-swap-count-fix
+++ a/mm/swapfile.c
@@ -1624,7 +1624,7 @@ static int __swap_cluster_dup_entry(stru
 		}
 	} else if (count == SWP_TB_COUNT_MAX) {
 		VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
-				(BIT(BITS_PER_TYPE(ci->extend_table[0]))) - 1);
+                               type_max(typeof(ci->extend_table[0])));
 		++ci->extend_table[ci_off];
 	} else {
 		/* Never happens unless counting went wrong */
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-use-the-swap-table-to-track-the-swap-count-fix.patch

