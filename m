Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1B1EA90;
	Thu, 19 Dec 2024 03:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577543; cv=none; b=KdQDDRl2v4JyVfm5hJPblKETSVCl1Ip6WXAG1mLXoFrxNAvmsx0GQ2LYVTFraxY6Ocd2/y2Ua2YfAnCGABwOy8eCtmsTu5Yr6H0vLWjNtGwPZWOql47s0fJDrvtuW1ij+m1em9BkBk6WzIv/S5OaEPM3KfITlj+msJTVWtzzsr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577543; c=relaxed/simple;
	bh=IYvYJdIV3zA2aagSpjf6aKU2hPQd0GgJ5EOVMwYybew=;
	h=Date:To:From:Subject:Message-Id; b=jFjbToy7HpGrksD1+NlDuWs0Sx1pVmMG1EICu3ypYUsAGCbe+kgNwnCdG+B43aenCc9dy77DRRkgLlLLdssTB9KjhPiC2vQEu2BuF71WXJVjJgYtEtmqunX2pdMMe85Ee2aICeYHQwKaNjkUoTjASWcMJV+NrPJYVFOZsigVAnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D18jRFMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D18jRFMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F1BC4CECD;
	Thu, 19 Dec 2024 03:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577543;
	bh=IYvYJdIV3zA2aagSpjf6aKU2hPQd0GgJ5EOVMwYybew=;
	h=Date:To:From:Subject:From;
	b=D18jRFMo2Psugz7hvrTFTStBTaJSEGtd8NAOfO0G/JDa5yHz+GshIW1FFBNz7lU8q
	 NIMJDTZmiBDDU88pJXDlCdVINWvuMj+FwOKsGx7tF2EYAy9tRL1J6JPJgxFOGMHl9m
	 tu0dMsM5Mp1+zxeWaJuPflEc+Pl0+zEb/jl+6628=
Date: Wed, 18 Dec 2024 19:05:42 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,souravpanda@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch removed from -mm tree
Message-Id: <20241219030543.48F1BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_DEBUG
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: fix set_codetag_empty() when !CONFIG_MEM_ALLOC_PROFILING_DEBUG
Date: Fri, 29 Nov 2024 16:14:23 -0800

It was recently noticed that set_codetag_empty() might be used not only to
mark NULL alloctag references as empty to avoid warnings but also to reset
valid tags (in clear_page_tag_ref()).  Since set_codetag_empty() is
defined as NOOP for CONFIG_MEM_ALLOC_PROFILING_DEBUG=n, such use of
set_codetag_empty() leads to subtle bugs.  Fix set_codetag_empty() for
CONFIG_MEM_ALLOC_PROFILING_DEBUG=n to reset the tag reference.

Link: https://lkml.kernel.org/r/20241130001423.1114965-2-surenb@google.com
Fixes: a8fc28dad6d5 ("alloc_tag: introduce clear_page_tag_ref() helper function")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/lkml/20241124074318.399027-1-00107082@163.com/
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug
+++ a/include/linux/alloc_tag.h
@@ -63,7 +63,12 @@ static inline void set_codetag_empty(uni
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
 static inline bool is_codetag_empty(union codetag_ref *ref) { return false; }
-static inline void set_codetag_empty(union codetag_ref *ref) {}
+
+static inline void set_codetag_empty(union codetag_ref *ref)
+{
+	if (ref)
+		ref->ct = NULL;
+}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch

