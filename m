Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118F074E3D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101064; cv=none; b=U3TGoT4Oc9SnnVEArMA+ldVDRNavG8Keb2vg5+VLgB9pk9/X6lq/B36A8cHziTqvj/C4pD0+QEsaweVCfW/5fSg4GjAIhRvjwZGzWTIxgpwhK5zioomuj8rh9xVoDBfmvB+B7Kcla9jtGUsE3FCoTXEtN4M+YsoZMMQCXNzIPnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101064; c=relaxed/simple;
	bh=9qUQ7QVcBYOr/7WIlKnUsdDCct8nsVegcKfyZIzZZT4=;
	h=Date:To:From:Subject:Message-Id; b=syECcMDksHM/Xh59Kal+FWkgWU1Hj9pfxM6jEG1h0sycljxgzq3yUfDLPDZzVuZGu/sj2+/WP903I97Upd8/YTGAcFi1ySqN/jIvre2NYOdqBgRSKSBgWeRFUeLQetuyYLFa4lqg3MeMP+7SkpSRDzsFItpRc3hkuBznLqtJOgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cMAg4uvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cMAg4uvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB4C2BBFC;
	Fri, 26 Apr 2024 03:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101063;
	bh=9qUQ7QVcBYOr/7WIlKnUsdDCct8nsVegcKfyZIzZZT4=;
	h=Date:To:From:Subject:From;
	b=cMAg4uvGLc1VqE5zzworyKkRBVDAMZUlSar+uSOH49Z+k2rVvwGJ/LliHUTeiQLgd
	 oa5fSB+bxDO4BGamC1Gf7Nc6bckXY0pv1C0OYboqgfwWlJ2l+mifL/IUj/nsfZ6NyK
	 1W9czJ7bWPqaIGJaYGgBHPybOQmnl0wWZmfyRQbM=
Date: Thu, 25 Apr 2024 20:11:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sfr@canb.auug.org.au,kent.overstreet@linux.dev,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2.patch removed from -mm tree
Message-Id: <20240426031103.94BB4C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slab: fix kcalloc() kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2.patch

This patch was dropped because it was folded into mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/slab: fix kcalloc() kernel-doc warnings
Date: Tue, 26 Mar 2024 21:46:49 -0700

Fix the parameter names for kcalloc() in slab.h to prevent kernel-doc
warnings:

include/linux/slab.h:730: warning: Function parameter or struct member '_n' not described in 'kcalloc'
include/linux/slab.h:730: warning: Function parameter or struct member '_size' not described in 'kcalloc'
include/linux/slab.h:730: warning: Function parameter or struct member '_flags' not described in 'kcalloc'
include/linux/slab.h:730: warning: Excess function parameter 'n' description in 'kcalloc'
include/linux/slab.h:730: warning: Excess function parameter 'size' description in 'kcalloc'
include/linux/slab.h:730: warning: Excess function parameter 'flags' description in 'kcalloc'

Link: https://lkml.kernel.org/r/20240327044649.9199-1-rdunlap@infradead.org
Fixes: bc7b83f5e4bf ("mm/slab: enable slab allocation tagging for kmalloc and friends")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/linux-next/20240325123603.1bdd6588@canb.auug.org.au/
Tested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h~mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2
+++ a/include/linux/slab.h
@@ -727,7 +727,7 @@ static inline __realloc_size(2, 3) void
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-#define kcalloc(_n, _size, _flags)		kmalloc_array(_n, _size, (_flags) | __GFP_ZERO)
+#define kcalloc(n, size, flags)		kmalloc_array(n, size, (flags) | __GFP_ZERO)
 
 void *kmalloc_node_track_caller_noprof(size_t size, gfp_t flags, int node,
 				  unsigned long caller) __alloc_size(1);
_

Patches currently in -mm which might be from rdunlap@infradead.org are

scripts-kernel-doc-drop-_noprof-on-function-prototypes.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch

