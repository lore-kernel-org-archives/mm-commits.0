Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6C79D1
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 22:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724278379; cv=none; b=WkPGVdktq7hDP6rzUfKZOnCTeO7qQGwCSdbdMsPpg9yuG4y4pXmRFWsLuAjLBSn1lgoczHAnsslpdIUlh+C5Ejy5S8rpxGjCEy+xHQL6NtzncbDvNrCgLb4b+PtjRAAy0CwT/15ckqS8cvAP4HvQ2jIaiJItXfd4BOywiLER0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724278379; c=relaxed/simple;
	bh=+BGBheiuHFOKfD8jU/2PecvWwYAEeNrXS50OO7DpVyM=;
	h=Date:To:From:Subject:Message-Id; b=aV6uKfIjL+oJamTnu8lpHt1CMIm8+GV7nb9B1fwF+gAZw4YTJBYjXcGU+3MBxDOQbPnE+hZdD5yT+JqkTbwjaRg0+DXeGswUS/ZJWl3JQ62UFehUQk5SzR1x9ol4b6Dnilz3A+5Mz2taicoRHG1rU0NUkHvq672m15je0GNAwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R0J/j7lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R0J/j7lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60622C32781;
	Wed, 21 Aug 2024 22:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724278378;
	bh=+BGBheiuHFOKfD8jU/2PecvWwYAEeNrXS50OO7DpVyM=;
	h=Date:To:From:Subject:From;
	b=R0J/j7lzTcBp8+gzUpvFsIWA+SyqSZNDS4XuBIVsiZlMyYBLsdqg4HaCbtwFNIpJp
	 JC376MBxjzCCP+4hLvwj8op7O0ffjSgQK5cUB3EJofbSD+D6PSswgouCbJ0n9zKWa4
	 yzIz+uaJCGc7Mk2TccC04C/5O/2gLLvD2BHjsNMM=
Date: Wed, 21 Aug 2024 15:12:57 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,liyuesong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-use-folio_next_index-helper-in-writeback_iter.patch added to mm-unstable branch
Message-Id: <20240821221258.60622C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm:page-writeback: use folio_next_index() helper in writeback_iter()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-writeback-use-folio_next_index-helper-in-writeback_iter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-use-folio_next_index-helper-in-writeback_iter.patch

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
From: Yuesong Li <liyuesong@vivo.com>
Subject: mm:page-writeback: use folio_next_index() helper in writeback_iter()
Date: Wed, 21 Aug 2024 14:31:12 +0800

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index().

Link: https://lkml.kernel.org/r/20240821063112.4053157-1-liyuesong@vivo.com
Signed-off-by: Yuesong Li <liyuesong@vivo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-page-writeback-use-folio_next_index-helper-in-writeback_iter
+++ a/mm/page-writeback.c
@@ -2612,7 +2612,7 @@ struct folio *writeback_iter(struct addr
 
 done:
 	if (wbc->range_cyclic)
-		mapping->writeback_index = folio->index + folio_nr_pages(folio);
+		mapping->writeback_index = folio_next_index(folio);
 	folio_batch_release(&wbc->fbatch);
 	return NULL;
 }
_

Patches currently in -mm which might be from liyuesong@vivo.com are

mm-page-writeback-use-folio_next_index-helper-in-writeback_iter.patch

