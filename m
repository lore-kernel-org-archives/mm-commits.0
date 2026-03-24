Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F70372B37
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388650; cv=none; b=IMsVw0PLvBQqWlmsfmw1fZG9EAgVzu3XdsIsLxBB4t0nh7Vq99T+lNGAjGGYwC1w977vRIf1KtHyIjizRmKdFtyY3KIYvexAQjR6IIkf7N7ehlPysp0HhEACjDzqGZoYccEzT1JUQLCeReM+MM5RseM8OtWQaAl0RxJOAFG0Tg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388650; c=relaxed/simple;
	bh=kTUxhlLxxYnCNtRwtqvpW8hw2hni1xLSf/sErk6vCdk=;
	h=Date:To:From:Subject:Message-Id; b=alI1QllCPuSZbeXIzmzGwqU8o5WsbsaU4DKDyKtT3NmEDc8ICjY1nYagjuiASh4JolGb1YHfk7QS7q5wQk4dZFzPheBZbj//Kbjt4Z7APibtlI8xAycX7+fBI9uMAdDg8T0K3T29WFqxqz30Eefes74yEC88yyJqU4SUAp+++p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xCXrn1Lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xCXrn1Lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B97C19424;
	Tue, 24 Mar 2026 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388650;
	bh=kTUxhlLxxYnCNtRwtqvpW8hw2hni1xLSf/sErk6vCdk=;
	h=Date:To:From:Subject:From;
	b=xCXrn1LrhSnxP+5jhk6VKYwrCapx3YidlulEkDaQZGdsV1RFzcs/jcYSiTMlT+TQg
	 STW8yKnSzgj16L3RC432+RiJz8nvO8SxsKWQCthYqC57N95JE1Kw0rjR3P6zAHNjnz
	 2OWGuV2nh/JyDCJlnE4om/mYOpFH44LEUq/BzeaU=
Date: Tue, 24 Mar 2026 14:44:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-branch-from-compound_head.patch removed from -mm tree
Message-Id: <20260324214410.69B97C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove the branch from compound_head()
has been removed from the -mm tree.  Its filename was
     mm-remove-the-branch-from-compound_head.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm: remove the branch from compound_head()
Date: Fri, 27 Feb 2026 19:42:54 +0000

The compound_head() function is a hot path.  For example, the zap path
calls it for every leaf page table entry.

Rewrite the helper function in a branchless manner to eliminate the risk
of CPU branch misprediction.

Link: https://lkml.kernel.org/r/20260227194302.274384-17-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-the-branch-from-compound_head
+++ a/include/linux/page-flags.h
@@ -224,25 +224,32 @@ static __always_inline bool compound_inf
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
+	unsigned long mask;
 
-	/* Bit 0 encodes PageTail() */
-	if (!(info & 1))
-		return (unsigned long)page;
+	if (!compound_info_has_mask()) {
+		/* Bit 0 encodes PageTail() */
+		if (info & 1)
+			return info - 1;
 
-	/*
-	 * If compound_info_has_mask() is false, the rest of compound_info is
-	 * the pointer to the head page.
-	 */
-	if (!compound_info_has_mask())
-		return info - 1;
+		return (unsigned long)page;
+	}
 
 	/*
 	 * If compound_info_has_mask() is true the rest of the info encodes
 	 * the mask that converts the address of the tail page to the head page.
 	 *
 	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 *
+	 * Let's do it in a branchless manner.
 	 */
-	return (unsigned long)page & info;
+
+	/* Non-tail: -1UL, Tail: 0 */
+	mask = (info & 1) - 1;
+
+	/* Non-tail: -1UL, Tail: info */
+	mask |= info;
+
+	return (unsigned long)page & mask;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
_

Patches currently in -mm which might be from kas@kernel.org are


