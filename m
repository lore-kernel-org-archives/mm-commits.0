Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF96C8FF;
	Thu, 28 Nov 2024 00:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755187; cv=none; b=uTK+U1Dg47tr/V8n0MgPt6SQlAFUk0S78+NJK35Hh2e0NeOo6zgCVwKRKGpLUZzM59q7UTUQ7F2iVveN56afpY4g2I+Y77k2h4FJK4y7C9kD0BAamT7ij8/RQsFZV9ZsYMSv3/c5sqIJDvps+g9YQpJxrbvyUs3KHVjdqewgLfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755187; c=relaxed/simple;
	bh=V2RsBHcEU7CslrL/5c8HtorfiHjIkQvleqgPhTHH9oI=;
	h=Date:To:From:Subject:Message-Id; b=u395tw/DHgD44iZO6eJmdmg8MbE+Y19JD+yix9St378+DNAKAmNt3AMOle+qcs38Kcx9/bOZ7STbZXmI2gjcNwrYCMs2oGZufKGQlJ8o/gV6wP5KIzep2Ecdp8bLtS3ks3TcKFtyoL7CdlPzG+vkMZjDN8Nv8sGJuLz5teIsD+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b19684MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b19684MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA38C4CECC;
	Thu, 28 Nov 2024 00:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755187;
	bh=V2RsBHcEU7CslrL/5c8HtorfiHjIkQvleqgPhTHH9oI=;
	h=Date:To:From:Subject:From;
	b=b19684MHE554LazrsVeEy3SYPW4AuJXP+AmE0TU7+hKT8PXFdT9uRqN9JgT+V3lds
	 lhMyNnw2RooyXV34GO+ITiTi0p/9SsaxsHYR6CUTF+B7cQTuGSS6h2lLl8lHhYEpa0
	 bMowRCZStSv21kBB2igMcuiWZkwqHe5WroVMbLQE=
Date: Wed, 27 Nov 2024 16:53:06 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,phil@fifi.org,anders.blomdell@gmail.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128005306.DFA38C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "readahead: properly shorten readahead when falling back to do_page_cache_ra()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jan Kara <jack@suse.cz>
Subject: Revert "readahead: properly shorten readahead when falling back to do_page_cache_ra()"
Date: Tue, 26 Nov 2024 15:52:08 +0100

This reverts commit 7c877586da3178974a8a94577b6045a48377ff25.

Anders and Philippe have reported that recent kernels occasionally hang
when used with NFS in readahead code.  The problem has been bisected to
7c877586da3 ("readahead: properly shorten readahead when falling back to
do_page_cache_ra()").  The cause of the problem is that ra->size can be
shrunk by read_pages() call and subsequently we end up calling
do_page_cache_ra() with negative (read huge positive) number of pages. 
Let's revert 7c877586da3 for now until we can find a proper way how the
logic in read_pages() and page_cache_ra_order() can coexist.  This can
lead to reduced readahead throughput due to readahead window confusion but
that's better than outright hangs.

Link: https://lkml.kernel.org/r/20241126145208.985-1-jack@suse.cz
Fixes: 7c877586da31 ("readahead: properly shorten readahead when falling back to do_page_cache_ra()")
Reported-by: Anders Blomdell <anders.blomdell@gmail.com>
Reported-by: Philippe Troin <phil@fifi.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Philippe Troin <phil@fifi.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra
+++ a/mm/readahead.c
@@ -460,8 +460,7 @@ void page_cache_ra_order(struct readahea
 		struct file_ra_state *ra, unsigned int new_order)
 {
 	struct address_space *mapping = ractl->mapping;
-	pgoff_t start = readahead_index(ractl);
-	pgoff_t index = start;
+	pgoff_t index = readahead_index(ractl);
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
@@ -524,7 +523,7 @@ void page_cache_ra_order(struct readahea
 	if (!err)
 		return;
 fallback:
-	do_page_cache_ra(ractl, ra->size - (index - start), ra->async_size);
+	do_page_cache_ra(ractl, ra->size, ra->async_size);
 }
 
 static unsigned long ractl_max_pages(struct readahead_control *ractl,
_

Patches currently in -mm which might be from jack@suse.cz are

revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

