Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA6320FAA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188559; cv=none; b=IpLiXcdwvcLT3qgzZzWBURGNeeWLb+jTq7RJpmZn/Nz/iqgP/2uX20kJzzegPMoXGKLiGGGmbMOgHIl92+n/KtBe3e5q09Af0mWNciXEa2zJ2UhVXS+Jk4DnxWooY2Iv8lfV2Eej8K/FSeBCV4ti1BhzRe+j+Pu8plPkp+swBzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188559; c=relaxed/simple;
	bh=Tt1P8nupcZ6Wr0H5RmAWOKU0r1Ve35vyQZbWOf8/czs=;
	h=Date:To:From:Subject:Message-Id; b=OwalUWiBzOJE30qtfmyKAIF9q3/L6A65d8GK4XdnGQlMhbOVkaFFfooWAGkleU4Q/HLf9BaSTOkVWWbsrjUHQEfYyJdyEBRPCC6FHA2ZD7TZlX6t9wI4tBUr6+4tqjsHBV1RpA8oIBxOazOxiezS0ioW2NO4JDvm5EufC4F6ZOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Heyrepfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Heyrepfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A32C4CEEC;
	Mon, 17 Mar 2025 05:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188559;
	bh=Tt1P8nupcZ6Wr0H5RmAWOKU0r1Ve35vyQZbWOf8/czs=;
	h=Date:To:From:Subject:From;
	b=Heyrepfstf2YKRmj3s8dPlR/6efxhRCGs/R+lHSgynnOeDxxXE4O0S3f7qUkR1l3w
	 +Jfe2krBeJ3A7xRQu7xGL7RT+fKBTFD+7uS+2odnYfVuTv11j89kLdh9rODY66hvl4
	 EGMQHQirOvArqfdRyjAUP4YZerR+Lwxxp8ak7C+I=
Date: Sun, 16 Mar 2025 22:15:58 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-duplicate-error-validation.patch removed from -mm tree
Message-Id: <20250317051559.10A32C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: remove duplicate error validation
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-duplicate-error-validation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: remove duplicate error validation
Date: Fri, 7 Feb 2025 17:44:19 +0800

Remove duplicate error code checks for 'start' and 'end', as the
get_order_from_str() will only return -EINVAL if the cmdline string is
configured incorrectly.

Link: https://lkml.kernel.org/r/dfadaba4c8b24c5ae1467fe8b6744b654c65ec91.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-duplicate-error-validation
+++ a/mm/shmem.c
@@ -5664,19 +5664,19 @@ static int __init setup_thp_shmem(char *
 								 THP_ORDERS_ALL_FILE_DEFAULT);
 			}
 
-			if (start == -EINVAL) {
+			if (start < 0) {
 				pr_err("invalid size %s in thp_shmem boot parameter\n",
 				       start_size);
 				goto err;
 			}
 
-			if (end == -EINVAL) {
+			if (end < 0) {
 				pr_err("invalid size %s in thp_shmem boot parameter\n",
 				       end_size);
 				goto err;
 			}
 
-			if (start < 0 || end < 0 || start > end)
+			if (start > end)
 				goto err;
 
 			nr = end - start + 1;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


