Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A448370AFD
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027701; cv=none; b=SwG3RsUexJ9jrdp8xzwzmN66/IFxIyyiUnD+kmZ+1wpAtCFMo14KhEAQVC2pZ7rsQeeWqaczrjT5Y+4mNqyg2CVKGu+MtHKe6xqsxk+3T953U44sMgzxFtnsNMO3VP6EmdN4opu/115inEDkAxxIa2Ryapu73tg95Jv+WxV4Mec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027701; c=relaxed/simple;
	bh=c/aVHsLVhlkDoRL2dGTvluu2l+MVclhcR8BbRHXFOfA=;
	h=Date:To:From:Subject:Message-Id; b=O2l683NT/0bbbnCyHB8/ILc3mvpML+CzB+IoHzW2d5+o6G4DlYPLto/Pq9pp7XrE893VFB7u2+eDjgyMDBXLuMXJ3jdOccAjuS9NQQThL3jhI6ejrYotFAC9NhWzvpGctmAkBlCu/3CE9qzOtpPdlvjA2cqCRQv/jZ6fc1rIMsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pJ3N7Twq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pJ3N7Twq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A653B1F00898;
	Fri, 29 May 2026 04:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027699;
	bh=oTND5fEP2iIBEDj66UHccpC3gftce4i7XNLndcOqE7I=;
	h=Date:To:From:Subject;
	b=pJ3N7TwqCxKqwCIQrg7dxF60QgbFfz1CVq5Zy/bWPImnmxFZSMCm5OFoq7J1aZfD7
	 ys6EbMoE2KLpZWqkA3qnMXmAbkAAuWKC7grwhXu1qeJhXuviAOiWJF4XUCplBmhgr2
	 yDutJJoC9ECkg6/sND6MAIJCJ4wn3bUDzJRwbCHc=
Date: Thu, 28 May 2026 21:08:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,roman.gushchin@linux.dev,jack@suse.cz,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch removed from -mm tree
Message-Id: <20260529040819.A653B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
has been removed from the -mm tree.  Its filename was
     mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: fujunjie <fujunjie1@qq.com>
Subject: mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits
Date: Tue, 28 Apr 2026 01:59:44 +0000

A fault that starts synchronous mmap readahead can return VM_FAULT_RETRY
after dropping mmap_lock.  The retry may then map the folio brought in by
that same miss.

Do not let this retry decrement mmap_miss.  The retry still maps the folio
from the page cache; it just does not count as a useful mmap readahead
hit.

Link: https://lore.kernel.org/tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com
Signed-off-by: fujunjie <fujunjie1@qq.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/filemap.c~mm-filemap-do-not-count-fault_flag_tried-retries-as-mmap-hits
+++ a/mm/filemap.c
@@ -3937,6 +3937,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 		 * we can stop read-ahead.
 		 */
 		if ((map_ret & VM_FAULT_NOPAGE) &&
+		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio)) {
 			unsigned short mmap_miss;
 
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-compaction-respect-cpusets-when-checking-retry-suitability.patch
mm-page_alloc-fix-deferred-compaction-accounting.patch

