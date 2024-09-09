Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1584318DF76
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925694; cv=none; b=qQ6HxW8bnoCtJMbqi6w3IH6u5jYnCh+08KC7jSCBShx+8DWTkaQo/CFBD6BayLdOXFxsKcXKYYAHaHjLURZi22JVYxSaMBJWLORz1FeIdSXffuItfFCO+7CI/MAkojb+CDiOiX6/K1IYtL3bYkPwPD/NNoh56J8BiC5EIPTcMWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925694; c=relaxed/simple;
	bh=OmtKz5KUCvkiESLoUZ+cgqv5rLSbNR66D6a2W8jX4gA=;
	h=Date:To:From:Subject:Message-Id; b=Kpu7vYvoa//3ujkGScEd5rUeedDBZZ6LAfIPe92RGPoUPc7pEuBd/TBHyuk53ZMTe7ztq2/+pvTxTYUdUEbIGCUzRar8CTh3vRj3isXa04h9uJaltShgPOsxLnf2/3eAeJCvIoYGcYzSQJzeU0IiTypVi9v+YNj3fdCRoGDTWWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FX1RMEqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FX1RMEqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99194C4CECA;
	Mon,  9 Sep 2024 23:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925693;
	bh=OmtKz5KUCvkiESLoUZ+cgqv5rLSbNR66D6a2W8jX4gA=;
	h=Date:To:From:Subject:From;
	b=FX1RMEqSGMLyfQFMOFfeZiInlSIuLrOBiilOGtoj/0vUU7rBhNskbcJ/jWYhp2zY+
	 MCDedVnDc6UeB7yGIhTNi4OGAmMbbKcH3LhTywQWQDel7rrHdNRpspfl2R6t+xeY7C
	 +sOMY9EplhhIJPTI+fU1L31bisaP0XevEZsOxUcI=
Date: Mon, 09 Sep 2024 16:48:13 -0700
To: mm-commits@vger.kernel.org,zhangjiao2@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-mm-rm-thp_swap_allocator_test-when-make-clean.patch removed from -mm tree
Message-Id: <20240909234813.99194C4CECA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: rm thp_swap_allocator_test when make clean
has been removed from the -mm tree.  Its filename was
     tools-mm-rm-thp_swap_allocator_test-when-make-clean.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhangjiao <zhangjiao2@cmss.chinamobile.com>
Subject: tools/mm: rm thp_swap_allocator_test when make clean
Date: Thu, 29 Aug 2024 12:20:08 +0800

rm thp_swap_allocator_test when make clean

Link: https://lkml.kernel.org/r/20240829042008.6937-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: zhangjiao <zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/Makefile~tools-mm-rm-thp_swap_allocator_test-when-make-clean
+++ a/tools/mm/Makefile
@@ -23,7 +23,7 @@ $(LIBS):
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-	$(RM) page-types slabinfo page_owner_sort
+	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
_

Patches currently in -mm which might be from zhangjiao2@cmss.chinamobile.com are


