Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A10267F45
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945885; cv=none; b=B11j77p3/ZNY9xErCzYm8gFG3Uv+MKD1pdHI82RLgoKQ44ylbSgZ3tQ4iC98KqNNBl3xON7XXytmMxONFTHkWW9XnsxpjoVCvpwvDGZs7vlbk3nojg7N++hxlBnbzLqTNEz3cgok84Nr2oywomPiHvyRlKfJUJo9TkjJXgB+nI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945885; c=relaxed/simple;
	bh=l9bY/dNNlpktTWMZBlSAsVLSj9Kq2+3JlCisX5wxQPg=;
	h=Date:To:From:Subject:Message-Id; b=TRSW1HroH+XLw4Okjr5AMF3eWViz3C78pqC8xuRgHnI0tNDyeYVgn6liBzJXI8CtkCgV3q34aiDAAD1B8Q7nZPsJxS8fkH+rKEAOsnb/4MhnGppLoSrur8aJva0I2KYgAXpROGz788KDpFifX4/8gWjvHZLMv2bNp+RdNRETipA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KlL8qFwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KlL8qFwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5E2C4CEE4;
	Fri, 18 Apr 2025 03:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945885;
	bh=l9bY/dNNlpktTWMZBlSAsVLSj9Kq2+3JlCisX5wxQPg=;
	h=Date:To:From:Subject:From;
	b=KlL8qFwJpEvHrITZ6QPzqZj2wLB3gQuSEZr5U7wlwUqsXyYft1X8R2cAZq9EhXpy4
	 +UzsqESsrBXKm46KJ5VHgMk0NmfGwjJGmcZeMPxYHVhtpFHKdWD/sKohkqOigWO5aZ
	 Ez6kv85o4fgrcam6SGZVYQnTsoEQWgsgHFiBnUpM=
Date: Thu, 17 Apr 2025 20:11:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,paulmck@kernel.org,Liam.Howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-section-for-locking-of-mms-and-vmas.patch removed from -mm tree
Message-Id: <20250418031125.3C5E2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add section for locking of mm's and VMAs
has been removed from the -mm tree.  Its filename was
     maintainers-add-section-for-locking-of-mms-and-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add section for locking of mm's and VMAs
Date: Wed, 16 Apr 2025 11:38:37 +0100

We place this under memory mapping as related to memory mapping
abstractions in the form of mm_struct and vm_area_struct (VMA).  Now we
have separated out mmap/vma locking logic into the mmap_lock.c and
mmap_lock.h files, so this should encapsulate the majority of the mm
locking logic in the kernel.

Suren is best placed to maintain this logic as the core architect of VMA
locking as a whole.

Link: https://lkml.kernel.org/r/e6ed679a184ca444b20dfa77af96913fd8b5efa0.1744799282.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/MAINTAINERS~maintainers-add-section-for-locking-of-mms-and-vmas
+++ a/MAINTAINERS
@@ -15574,6 +15574,22 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
+MEMORY MAPPING - LOCKING
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/mm/process_addrs.rst
+F:	include/linux/mmap_lock.h
+F:	include/trace/events/mmap_lock.h
+F:	mm/mmap_lock.c
+
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

