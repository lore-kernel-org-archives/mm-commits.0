Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D779E20CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898239; cv=none; b=PgDExfVQ9nrbXp9YRbRuYwGNqHhrdgy8VRt/E1vCKgoPupY/yUplIdSHaC6llLQAWuM72pQUG1vnlC6cai/vEm9te0aFK+RXWuHdAktOKoOpMYg207eAgkT20zeC1oFaOv48HXFMUmbvMd9yBBwqXCWmnQSljWJhNpWpvvGT6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898239; c=relaxed/simple;
	bh=RG3Ar++oNW0PhgsDunpvR9f9S64bj9oOq+HaX9c3DL8=;
	h=Date:To:From:Subject:Message-Id; b=bBsYcrXcNIjeG/N48yfqL4LsvLqt86OIpScjIbn1sfMTFkDxOpkQPi0Q+4241ARUYvzH6Vt48t93SHAuRnA4MNpbjyjG119xLBxHEInJGgsJQf/1XbFy4wMdxNaR18cXcY8TdVftCArEjGWwQ55q1KY+c2Pfd+CPzZxZYCg5hG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q4QOzheC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q4QOzheC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C87C4CEF1;
	Sat, 31 Jan 2026 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898239;
	bh=RG3Ar++oNW0PhgsDunpvR9f9S64bj9oOq+HaX9c3DL8=;
	h=Date:To:From:Subject:From;
	b=Q4QOzheCLiCRD8k/NJ8ftMb9fn5EU9zJ115TXW2Zjc6Fq+ccTmW0QjJCNmT4s61Ov
	 V11+pWWGDIj+qWtgne9hI2hZW+uGN5ZfbN2ekYeWNiuId2TUSXSmXxeDO4D5N9SXiY
	 HZVaxOLvhdoRvrFnBwUesp7AEGGQEmJp9nQnR9t0=
Date: Sat, 31 Jan 2026 14:23:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-make-khugepaged_collapse_control-static.patch removed from -mm tree
Message-Id: <20260131222359.97C87C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: make khugepaged_collapse_control static
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-make-khugepaged_collapse_control-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control static
Date: Sun, 18 Jan 2026 19:23:01 +0000

The global variable 'khugepaged_collapse_control' is not used outside of
mm/khugepaged.c.  Make it static to limit its scope.

Link: https://lkml.kernel.org/r/20260118192253.9263-14-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-static
+++ a/mm/khugepaged.c
@@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
_

Patches currently in -mm which might be from shivankg@amd.com are


