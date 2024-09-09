Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5F118C02A;
	Mon,  9 Sep 2024 22:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920197; cv=none; b=dj/I4Fo/mkPYpZgDrXWe68HpSRMC+163+Ej/MIL7GCkipe1wQGWVtFAVBSI+ze+7Bv6i5iqiq4CDqEPERdfsPNjb9vV5W+54nbwiyU2tez0sVyiNZw1to0pCxOhAqrS2z9jiS7kohg3w/mniPYV+RWHSZyuqVjcQkQuv3cRc+Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920197; c=relaxed/simple;
	bh=vCqGNHESZNZjXTAC1cttMwThZyJazwIykjd2ClBg9GQ=;
	h=Date:To:From:Subject:Message-Id; b=pjljYPgxGMNvhJKQ5pkPYLfloDJ8fYOZ5dKHJz3KVwb4eeHJKaa3olM4465fghroMJF9JMj7V4aO3r+71gKsw02ZnHrBr5a9SpExLWGEwq/cvLqT56oHF9g9N7qhsk7a2Z/qziQbhZzGtXHGSOwlEMpEW3AdGGwwxwLeXYRH8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ONP+l99f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ONP+l99f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7193C4CEC5;
	Mon,  9 Sep 2024 22:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920196;
	bh=vCqGNHESZNZjXTAC1cttMwThZyJazwIykjd2ClBg9GQ=;
	h=Date:To:From:Subject:From;
	b=ONP+l99f/E1sk0wgXBM86oa9tm898nfRyLLwKORQO+lQBK2HV9IIAnvHWjWbCz/qI
	 O5vbagh5IqNq9Q0zQRQ15zef1xoRUVsdGX5azTENBYwleu2qXYWMmG/Te0y1GXcS5H
	 I22KghZwCGtHMqhjv5aINUzYw2zvjDGSeHOZE/+c=
Date: Mon, 09 Sep 2024 15:16:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,sj@kernel.org,linux@roeck-us.net,david@redhat.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch removed from -mm tree
Message-Id: <20240909221636.D7193C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock
Date: Wed, 4 Sep 2024 17:12:04 -0700

Traversing VMAs of a given maple tree should be protected by rcu read
lock.  However, __damon_va_three_regions() is not doing the protection. 
Hold the lock.

Link: https://lkml.kernel.org/r/20240905001204.1481-1-sj@kernel.org
Fixes: d0cf3dd47f0d ("damon: convert __damon_va_three_regions to use the VMA iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/b83651a0-5b24-4206-b860-cb54ffdf209b@roeck-us.net
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock
+++ a/mm/damon/vaddr.c
@@ -126,6 +126,7 @@ static int __damon_va_three_regions(stru
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
+	rcu_read_lock();
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
@@ -146,6 +147,7 @@ static int __damon_va_three_regions(stru
 next:
 		prev = vma;
 	}
+	rcu_read_unlock();
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
 		return -EINVAL;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-mark-three-functions-as-__maybe_unused.patch

