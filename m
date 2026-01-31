Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1166E385ED3
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898382; cv=none; b=j8ieCIGuCinnwNLpq/ZX1tYWbjb69sQN/6Pf1VQ7p5Ibj2WESZk622mKOP59q9x/2GGlVdxxBCyhEBNsGuzYvybR5JcNtLluKD5Zj5DcR3JejkSUq3X11Z8P64N1UkxQnPhegcUICPlN1+rR3LCm/chZNy+K0P5XjiGFvL57igE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898382; c=relaxed/simple;
	bh=EAyJj4BE/Uj+1osqDA5w1Qf8ef5LjLmbG2a9XmsCvRk=;
	h=Date:To:From:Subject:Message-Id; b=bDbB+Bm/J9mf9+4+FNvKLseBY3kY3VcNRDxqvvKy4qKGJQtmQU3TVp+AecJ1GKRKD4by1H2gjqtrt0R+NI1EmjbtUSjFQxl1CQ2VdRXy9OPHl32/Y/BzsXvg0ymdYm+o0D1//Ms9EGUlPLqYxYS7aVLDdq1ych8UmexdOKbjGI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PukRb6Tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PukRb6Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC271C4CEF1;
	Sat, 31 Jan 2026 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898381;
	bh=EAyJj4BE/Uj+1osqDA5w1Qf8ef5LjLmbG2a9XmsCvRk=;
	h=Date:To:From:Subject:From;
	b=PukRb6TcgJ+/+sYWKcq8sV5vYaJa5IFABittZ0Fls04Dkbua0LAi+H/pHzWMGhp6j
	 nzR6FEdeUyLeq9H6uC0bBn71O0CPn1foZ7QyMmp3byO12Tmf47vxGLBzh6bc/FKna6
	 UE1qW9css07E4HMPr1dCpEUNXdyWx8pu6V9hdtCg=
Date: Sat, 31 Jan 2026 14:26:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-use-min-to-simplify-the-code.patch removed from -mm tree
Message-Id: <20260131222621.DC271C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagewalk: use min() to simplify the code
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-use-min-to-simplify-the-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zenghongling <zenghongling@kylinos.cn>
Subject: mm/pagewalk: use min() to simplify the code
Date: Tue, 20 Jan 2026 17:49:32 +0800

Use the min() macro to simplify the function and improve its readability.

[akpm@linux-foundation.org: add newline, per Lorenzo]
Link: https://lkml.kernel.org/r/20260120094932.183697-1-zenghongling@kylinos.cn
Signed-off-by: zenghongling <zenghongling@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/pagewalk.c~mm-pagewalk-use-min-to-simplify-the-code
+++ a/mm/pagewalk.c
@@ -313,7 +313,8 @@ static unsigned long hugetlb_entry_end(s
 				       unsigned long end)
 {
 	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+
+	return min(boundary, end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from zenghongling@kylinos.cn are


