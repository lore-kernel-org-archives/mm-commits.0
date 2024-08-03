Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9074E2374C
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 19:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722712115; cv=none; b=ohhlWv6NYZqv1EcwPAsC8SJOYx7GWncCJ7X9zKaWKL1x68Dg8yd4DiaeX8w4aUfPZigB47qAq+NTHGrIXZU6U+gXBnPbYntaIA2Py1duEHsToN7WepL3vbo9Kl2e9X3zfu/nb02HXfn2/bUJbbgp+yoxML2IoogAwI8yqXk6rXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722712115; c=relaxed/simple;
	bh=q1Ix+U9F12ceKCE5qO0KWCyI5uJGT8IlH3VvKSlVf68=;
	h=Date:To:From:Subject:Message-Id; b=qKtem2nMpE1Ht89xQYHk49FjF8Tg1CRB0gAha0DMsYzBo4/BdejN5FA51Z7rPp/51G4sJP7mT3emDHyHSNuzC+yE95EGyToFTNLjWcXYPoqJfuHizzh8TH4makCrkzeq1HRA5mw7h3gV6cWr6fD96VTEkRG5fTN+UzI9DtESi9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F2C3qScR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F2C3qScR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1411DC116B1;
	Sat,  3 Aug 2024 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722712115;
	bh=q1Ix+U9F12ceKCE5qO0KWCyI5uJGT8IlH3VvKSlVf68=;
	h=Date:To:From:Subject:From;
	b=F2C3qScR2AmiKhucfzuk/cINd3ZKsJratzFDhRvkg5rsBCWFcDAOaKRy8ol6sAMFr
	 8nCZHXBusgEAcLOyB2tYJbu8Z0sSbAo1dSl3YmKjXJxjjD13uvms6EUOeFMFeUqiPt
	 1dUtVkVNOiDOUBIGpQQhAye9lgdjSHzfl76QZX+k=
Date: Sat, 03 Aug 2024 12:08:34 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch added to mm-unstable branch
Message-Id: <20240803190835.1411DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-support-large-folios-swap-in-for-zram-like-devices-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-support-large-folios-swap-in-for-zram-like-devices-fix
Date: Sat Aug  3 11:59:00 AM PDT 2024

fix unused var warning

mm/memory.c: In function 'alloc_swap_folio':
mm/memory.c:4062:32: warning: unused variable 'vma' [-Wunused-variable]
 4062 |         struct vm_area_struct *vma = vmf->vma;
      |                                ^~~

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-support-large-folios-swap-in-for-zram-like-devices-fix
+++ a/mm/memory.c
@@ -4059,8 +4059,8 @@ static inline bool can_swapin_thp(struct
 
 static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 {
-	struct vm_area_struct *vma = vmf->vma;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct vm_area_struct *vma = vmf->vma;
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
@@ -4128,7 +4128,8 @@ static struct folio *alloc_swap_folio(st
 
 fallback:
 #endif
-	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->address, false);
+	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vmf->vma,
+			       vmf->address, false);
 }
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch
mm-drop-config_have_arch_nodedata_extension-fix.patch
mm-drop-config_have_arch_nodedata_extension-fix-fix.patch

