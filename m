Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C68541757
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 19:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711654789; cv=none; b=FaK3ykrPF88X3ZhY7EEcTSxQarqLfu9VHoNl710JsKx96sbSMwGZNDSV5rNwGusSNGoZoqQlHZOKLqK187wahqAJdy5X4Ah6/GOtLFN3ujQxU2nf66uFck1voQlGiPkAzjMBQW4GTLsLProqyElnG4IXmCjGDlgGmxnMKXQuVDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711654789; c=relaxed/simple;
	bh=cy6wjxhU+g3J0XtvfFaWTwAMwhEflwR1jHjHMbcjrdg=;
	h=Date:To:From:Subject:Message-Id; b=foGb5Te6e0ioXpVH7ue9PIfbd8S59xCtFrOOPRvHLMJ8gohEypUmIGBePFJ6BMRWvyfL4yLnI1zEycY8+CBGLvhWrBxPlSm42BxKQYGVTFcM6zRNXdCoBBbb5GDH60UvWvR4ZEVrTB1Gr6LrL3tzq5jrsx6Uu3WwUqRWLJnqiXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TdD2G0Lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TdD2G0Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6E0C43390;
	Thu, 28 Mar 2024 19:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711654788;
	bh=cy6wjxhU+g3J0XtvfFaWTwAMwhEflwR1jHjHMbcjrdg=;
	h=Date:To:From:Subject:From;
	b=TdD2G0LxLz0TQpljEevanPtUqNVQhOnykNPQS9XfgLbPKG1Q3UaD4Xn2hvGI2eFgk
	 G9pSAqWeiAbWAU0riIiW+/vzVDGpLg4fquKmmW7lFYl5djNlesfl24TA/YSRzzTq6w
	 oRDU5+MWaslYliCusq2FYL3nBNMU9Q3p9g5X5NNQ=
Date: Thu, 28 Mar 2024 12:39:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sfr@canb.auug.org.au,kent.overstreet@linux.dev,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2.patch added to mm-unstable branch
Message-Id: <20240328193948.9F6E0C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/slab: fix kcalloc() kernel-doc warnings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2.patch

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
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix-2.patch

