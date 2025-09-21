Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366B21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489988; cv=none; b=MLRRRtZnq8YfunFJf/oT1R0fklhMTZ/MJbxQeDHyqrYvjFQFaq24zzXwhkEfkyAK7nMvqVlJ4hAQuTV9BRlE2bWreXbmQibdecoMvgsjYopZbr4MtRaOZQv2a1vrF8tmKDf7jBoe4+0RmrNQ6yokTxBNduDJPfEV/nyV7ZaZnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489988; c=relaxed/simple;
	bh=DUZPqtWKtFStRa7T+Gy6zDsr8QG6wAPBhysEIJjFDl8=;
	h=Date:To:From:Subject:Message-Id; b=f/IOCYEdRQpfhezOS7/kL96mxQaK+Bic1S3RUm20aphNiqEERnzpYoPcoQVUcZe9OlyxqsBzECHJeyf6PJP1Z7bUH4wHFUVjQUCuzICRuDVjcR7WvUf2fE7dgQUDwPUCn6fx0fdcFNBlml6Z6UkBCPNdOxNrz8I+7frgM1qjnjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dQtLH8mS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dQtLH8mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB026C4CEE7;
	Sun, 21 Sep 2025 21:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489988;
	bh=DUZPqtWKtFStRa7T+Gy6zDsr8QG6wAPBhysEIJjFDl8=;
	h=Date:To:From:Subject:From;
	b=dQtLH8mSj3RU7LUQedxA8himSW6VGYtZAmm43hZdK9kvgSt/xCKeEmfomL1SVi1mI
	 YCxctiANVu1ees4GdaQSnDx7MUJLpougDse5pxkFSBiVcTS4bn2XQSFAFg7SkUVuwT
	 /wAso5n3Dp9rSI/9ZoEA2fl+jplF2WMxVswQcyLY=
Date: Sun, 21 Sep 2025 14:26:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,zokeefe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-prot_exec-req-from-file-collapse-tests.patch removed from -mm tree
Message-Id: <20250921212627.EB026C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove PROT_EXEC req from file-collapse tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-prot_exec-req-from-file-collapse-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/mm: remove PROT_EXEC req from file-collapse tests
Date: Tue, 9 Sep 2025 12:05:34 -0700

As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP
eligibility") thp collapse no longer requires file-backed mappings be
created with PROT_EXEC.

Remove the overly-strict dependency from thp collapse tests so we test the
least-strict requirement for success.

Link: https://lkml.kernel.org/r/20250909190534.512801-1-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-remove-prot_exec-req-from-file-collapse-tests
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -394,7 +394,7 @@ static void *file_setup_area(int nr_hpag
 		perror("open()");
 		exit(EXIT_FAILURE);
 	}
-	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
+	p = mmap(BASE_ADDR, size, PROT_READ,
 		 MAP_PRIVATE, finfo.fd, 0);
 	if (p == MAP_FAILED || p != BASE_ADDR) {
 		perror("mmap()");
_

Patches currently in -mm which might be from zokeefe@google.com are


