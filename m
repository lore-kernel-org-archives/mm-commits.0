Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F011B3F0A;
	Thu,  5 Sep 2024 23:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577632; cv=none; b=aSi5FqrrzFdpo2X1f8VRV2+3d012M5wCRGhSbdU7laXUeFgAxdJAWQDnXgxGMNuuisqAph46xG9rxhFyKvK+OZgKbz9eYHplgqWhjV2ezA6isTkTCpcDrIZvW7N0hl5IKhLJxrIPeEB3kDOYC1cDqIuX7Ld30TsOnN+CqpJd3vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577632; c=relaxed/simple;
	bh=MUYznFoEGA9TE00TjZc+evRqwQoXMQXTcZNqWIgeH4k=;
	h=Date:To:From:Subject:Message-Id; b=FNrD8U/7+HqyD0wKxrateLuonrnkepOnvny7REavhLdUKE3TnOsjahpyhHlG5frERAl3D+PMKPBmxbS5YDnpcf0m7SDXg/6fLUjIpBXEjgx6141ejxo1pWrbwWjIDLtx0s8oqqVjnqNRKlicQRdGrJa4kGe53qi9plgxiD/JYhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dl0znFf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dl0znFf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF35C4CEC3;
	Thu,  5 Sep 2024 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725577631;
	bh=MUYznFoEGA9TE00TjZc+evRqwQoXMQXTcZNqWIgeH4k=;
	h=Date:To:From:Subject:From;
	b=Dl0znFf2ZYNo3azgyJOfOCldYAJwibWv7eObFXqjTVIJfqLDMosf060tITBtmpv1e
	 vmcVFB5KGj4ZT/YKNP+6A7FuM6DeNJjfGmK2pnNNoFDYWJDg8ERZ/e3qrkUAzX0lH1
	 VIJrIZeut7BBJ3GKNzPqNmUn80aMroLTiFaciYfE=
Date: Thu, 05 Sep 2024 16:07:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,sj@kernel.org,linux@roeck-us.net,david@redhat.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20240905230711.DAF35C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch

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

mm-damon-vaddr-protect-vma-traversal-in-__damon_va_thre_regions-with-rcu-read-lock.patch

