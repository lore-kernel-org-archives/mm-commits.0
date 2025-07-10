Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E4E28467B;
	Thu, 10 Jul 2025 05:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126230; cv=none; b=J2xphBFLpjNue4z1UgwJxojDa9tBmmlwYnVgfRBmywKedvJFnTLYzbiwDS6s06r61nPjbGPlj5ncFbD34i5qX7oCxuPRXn8auquf6rQ8jHM6YVqghDVJd19cXolBC98hXsUXPfmpCWqgIWgG/QGyWh/Ob1yVhqpWjlouWV1OW+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126230; c=relaxed/simple;
	bh=EdSFCn1zjmyJlce2sPpqOqCUqeuTT2D3BJb4YlwgN9Q=;
	h=Date:To:From:Subject:Message-Id; b=kAgn3dWwTswMapu7waWtkDq6AEUjb6xMPJ67QRF3QJLrD8OKpCZztmN04URVZiRy0ookpPB6t2FJqMDcx9WphxZJW0qNxHKqhtuDpeLz/adm8AJ9p+XNExsW4d29E6JljCKjV7YmdKM5ElUs5HFji638P0MCqugG0pc3UGqCnCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pk0k+6Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pk0k+6Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F74C4CEE3;
	Thu, 10 Jul 2025 05:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126230;
	bh=EdSFCn1zjmyJlce2sPpqOqCUqeuTT2D3BJb4YlwgN9Q=;
	h=Date:To:From:Subject:From;
	b=pk0k+6UlDw+d/nNeXMox0HthNifk00aOZOqlhDUe52hopZRvwt1xpEZCQPnNyhIKG
	 SPvihvqMHxE1qNaZ6Jos5E+HoAGEMHBF60JDRjMG1ZkL3HXcjNChpFeJ0r4vhvczVw
	 hLsrXlDaWh7ULDTyAHUdqNGNYFubYrtd18KyyAOk=
Date: Wed, 09 Jul 2025 22:43:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,josef@toxicpanda.com,jack@suse.cz,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found.patch removed from -mm tree
Message-Id: <20250710054349.F3F74C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: fix return value of page_cache_next_miss() when no hole is found
has been removed from the -mm tree.  Its filename was
     readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: readahead: fix return value of page_cache_next_miss() when no hole is found
Date: Thu, 5 Jun 2025 13:49:35 +0800

max_scan in page_cache_next_miss always decreases to zero when no hole is
found, causing the return value to be index + 0.

Fix this by preserving the max_scan value throughout the loop.

Jan said "From what I know and have seen in the past, wrong responses
from page_cache_next_miss() can lead to readahead window reduction and
thus reduced read speeds."

Link: https://lkml.kernel.org/r/20250605054935.2323451-1-chizhiling@163.com
Fixes: 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no hole found")
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~readahead-fix-return-value-of-page_cache_next_miss-when-no-hole-is-found
+++ a/mm/filemap.c
@@ -1778,8 +1778,9 @@ pgoff_t page_cache_next_miss(struct addr
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned long nr = max_scan;
 
-	while (max_scan--) {
+	while (nr--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are


