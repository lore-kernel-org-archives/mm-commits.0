Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB6915B0E2
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 10:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678452; cv=none; b=dT2kJirKFLY+mBMqXjWB3MmcfZoPxciiZJizG19RS6T1TWAu0keihD7YAgXrjJ7u9gY+DYMmo1EVTFn/dRabOxPbvE95cIQp3P0OqyJlkiOObL9ng+fu28Sya8ZQ552ANc+2xZhkwW95hubLH5Fj5tgg2CXHmWgjXoekhdAtRZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678452; c=relaxed/simple;
	bh=QSkhivBuvrUy0GpLCK8dDM5dy7q2InVTVMpIhF7nMKA=;
	h=Date:To:From:Subject:Message-Id; b=X27GoSlwYkyGYnhEQ2+qXI3y22rvaa5W5My72zwI+lGI5H3LZ3WlyzJGGsOEdRecn+0kHcEoOX4+3Tx1eIIZugg/CBY9094Osrf89khVMUw75qkk32qH6zMsWr8aDHJse2mtR9jmb+CJKeauau1VpqdVs8AVuSP5UrvtA/5i8vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZEc94w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZEc94w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389A0C4CEC6;
	Wed, 23 Oct 2024 10:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729678452;
	bh=QSkhivBuvrUy0GpLCK8dDM5dy7q2InVTVMpIhF7nMKA=;
	h=Date:To:From:Subject:From;
	b=vZEc94w1ZEfF+JCQTU4qzDvBLPtgQbpSTCB1eHQqrPawHDYAdjnDBvRJnW04lklKu
	 Xue485wN/U3SIWnXTACqy/BX3VRiuaImSoQQqAh1AW/Df5pREkQ9MXiTRfqJJ+jIZh
	 SHC1l9j654AZw3eKV6UtKqG+rCRgzjjD2+4qp2QU=
Date: Wed, 23 Oct 2024 03:14:11 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,surenb@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,anshuman.khandual@arm.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub.patch added to mm-unstable branch
Message-Id: <20241023101412.389A0C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: fix arg in pgalloc_tag_copy alloc_tag_sub
has been added to the -mm mm-unstable branch.  Its filename is
     mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub.patch

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
From: Sourav Panda <souravpanda@google.com>
Subject: mm/codetag: fix arg in pgalloc_tag_copy alloc_tag_sub
Date: Tue, 22 Oct 2024 23:24:40 +0000

alloc_tag_sub() takes bytes as opposed to number of pages as argument.

Currently pgalloc_tag_copy() passes the number of pages.  This fix passes
the correct unit, which is the number of bytes allocated.

Link: https://lkml.kernel.org/r/20241022232440.334820-1-souravpanda@google.com
Fixes: e0a955bf7f61 ("mm/codetag: add pgalloc_tag_copy()")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub
+++ a/include/linux/mm.h
@@ -4206,7 +4206,7 @@ static inline void pgalloc_tag_copy(stru
 	/* Clear the old ref to the original allocation tag. */
 	clear_page_tag_ref(&old->page);
 	/* Decrement the counters of the tag on get_new_folio. */
-	alloc_tag_sub(ref, folio_nr_pages(new));
+	alloc_tag_sub(ref, folio_size(new));
 
 	__alloc_tag_ref_set(ref, tag);
 
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-codetag-fix-arg-in-pgalloc_tag_copy-alloc_tag_sub.patch

