Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B31C2C9
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 00:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616034; cv=none; b=SRJaLn8Ccxk9fdBP2fEjcqI1Bwya4E7Pt6a80oAiXxnpkySglnZbPHetheBOQ5YzTIFEBBwwGiqStWBGyRlFowkCLfh1zL84DCQjdhnKWfHCNDLDGGd3Jts+fQJcrqrBqsmkVchvIokaDtbnGz9zI9Uk1C0ou3ZWrgxIxljvfYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616034; c=relaxed/simple;
	bh=YB6bXn8YK1uyNe/d3Vj2fFK4jeOsjYTVVo5oqcN2aEg=;
	h=Date:To:From:Subject:Message-Id; b=sFBFcH8sY942hBLif5Tyexbd9MveXp0kIXySX0sMRAdccXT+P1D3XQmPouo8SMrHHuURlD4uecWZLyusS8LajC6nq75v2VGixQOpQLRRlQWCDjkwzN/sz1BGX7BZFe99MpONIG0eC1p6z+AtF7DD0kaImkSiaZQIq3koNatojuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hec9kji/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hec9kji/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C14C4CED6;
	Thu, 27 Feb 2025 00:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740616033;
	bh=YB6bXn8YK1uyNe/d3Vj2fFK4jeOsjYTVVo5oqcN2aEg=;
	h=Date:To:From:Subject:From;
	b=hec9kji/AILtSHDOdfULCMdRIr9rG5tx/RKagfFtmweqeS8B5EAxiLxS0ihVCikBh
	 QjobFdWdGzlPAdPp/OeI27ACdybNhyL6EojZKvxnbrszXq+Wt4aNT2eOr314WoIwY+
	 +l1pGGtx6u4RcZrZB4mhC4I6+PlXZ0D2/B1pvyms=
Date: Wed, 26 Feb 2025 16:27:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch added to mm-unstable branch
Message-Id: <20250227002713.B0C14C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray-add-xas_try_split-to-split-a-multi-index-entry-fix
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch

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
Subject: xarray-add-xas_try_split-to-split-a-multi-index-entry-fix
Date: Wed Feb 26 04:11:24 PM PST 2025

export xas_destroy to modules for lib/test_xarray.c

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/xarray.c~xarray-add-xas_try_split-to-split-a-multi-index-entry-fix
+++ a/lib/xarray.c
@@ -278,6 +278,7 @@ void xas_destroy(struct xa_state *xas)
 		xas->xa_alloc = node = next;
 	}
 }
+EXPORT_SYMBOL_GPL(xas_destroy);
 
 /**
  * xas_nomem() - Allocate memory if needed.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch

