Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD49C1925B2
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150126; cv=none; b=Wiusdnry0QHNJ1U236CkmjEenwxiwzRd0urr6HpSsdynToeJdttGW2Y0MzOKkv+HYBaVViOVa7MKoM+znIZ/lAmkLedMKDXe22aEDnxX+Ym9KyO84ycftvnDAeNLtMKn6FhlwTl6Re1LdomjP7Bb5SJPAE3ifPuehzzXzN3N0rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150126; c=relaxed/simple;
	bh=yi+8/Q04x2YYb6BL4wC9Pc0BEh9Yg8FJ8Pc5Y+E8x9E=;
	h=Date:To:From:Subject:Message-Id; b=ZW5RMjWISSy96kFefKOHmknwjpSE5ElMLbJf8hAMFNN8RcyzY/4M4KLcFkApsUrmJTx9j5U1stHXZWh/L9kgkqCVY/0wsDX1R0P7sCJfcwcBWkXoosLIPPAg0QyHpqXXfARv6bLH+1xrBIvVNGLJ84rZK2tyEg7YuiW5/eACu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cjIW9RY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cjIW9RY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A01AC4CEC3;
	Thu, 17 Oct 2024 07:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150126;
	bh=yi+8/Q04x2YYb6BL4wC9Pc0BEh9Yg8FJ8Pc5Y+E8x9E=;
	h=Date:To:From:Subject:From;
	b=cjIW9RY7Rx8qU0EESx4i5vnlc+31+7TzrXc/tCnFC3HUKQc6jFj6hC76+ebCRCCeX
	 btIPPPg3Sr2yYNijLHffeBaSQfnlF+3+5BM0atUJpe7WHxHqpvqdE1Kq7RnkWfhg6/
	 1lHDjKMNfZA8ukwrpR5ZrjvekMcM0nU1RPHF2nIQ=
Date: Thu, 17 Oct 2024 00:28:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-memory-mapping-vma-co-maintainers.patch removed from -mm tree
Message-Id: <20241017072846.7A01AC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add memory mapping/VMA co-maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-add-memory-mapping-vma-co-maintainers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add memory mapping/VMA co-maintainers
Date: Wed, 9 Oct 2024 21:10:32 +0100

Add myself and Liam as co-maintainers of the memory mapping and VMA code
alongside Andrew as we are heavily involved in its implementation and
maintenance.

Link: https://lkml.kernel.org/r/20241009201032.6130-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/MAINTAINERS~maintainers-add-memory-mapping-vma-co-maintainers
+++ a/MAINTAINERS
@@ -14907,9 +14907,9 @@ N:	include/linux/page[-_]*
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
@@ -24737,9 +24737,9 @@ F:	tools/testing/vsock/
 
 VMA
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	https://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maple_tree-correct-tree-corruption-on-spanning-store.patch
maple_tree-add-regression-test-for-spanning-store-bug.patch
fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch

