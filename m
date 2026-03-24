Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5494B364931
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388633; cv=none; b=kgbFvT/f6BSuvUrlGiQh83TJqZ0/vmWD65tKIRVlf30rDmbspw/ejRI/2KOHLdy5eCjrzhzPKXUtPpQfSBTn7sooKno/nYRbNTCvy7MMWgEgBcj0jM4i/Nwt3U/TNhO2tDx+1vBAGKTVX8vjGKRfkO4pldT4wD9cvpFQaiFwZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388633; c=relaxed/simple;
	bh=7OQOE2uoNiGF+FxNenmPQx1u30h7/f6GRV8muD1Xsvo=;
	h=Date:To:From:Subject:Message-Id; b=PRWoJfzvCm26yM9LXb/cUA+5vW9kLGRmYqqKprtiRyuDaNoTu6e81jLNZ19c14mhmL7QHPyBso55UjxvdipZ/tJBUIMPG7k+n3McRtyUXsLyBfw4mPu1QBI4IiKaRD0SFBUQYQa0XvGgSy/ubWxVzmwWVI+7VGSCpZPz34o9Hg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OHx9FvMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OHx9FvMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCB7C19424;
	Tue, 24 Mar 2026 21:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388633;
	bh=7OQOE2uoNiGF+FxNenmPQx1u30h7/f6GRV8muD1Xsvo=;
	h=Date:To:From:Subject:From;
	b=OHx9FvMbcTecshk4wHAd77yZh1ikfFf53Lwdzh213Zuh64RXKmrOLMtHUXT9iZP8M
	 0w2uVUdh9YBNDPn4u46EaBh4rx7reWG9zWDsDsvzQjTbRq1G0fhv3fiTdcHDxanYue
	 tdg4VFTGfnYMKE3j1wYOOkd1z0WlR7fOXe6Go+J4=
Date: Tue, 24 Mar 2026 14:43:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-set-clear_compound_head-next-to-compound_head.patch removed from -mm tree
Message-Id: <20260324214353.2CCB7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move set/clear_compound_head() next to compound_head()
has been removed from the -mm tree.  Its filename was
     mm-move-set-clear_compound_head-next-to-compound_head.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm: move set/clear_compound_head() next to compound_head()
Date: Fri, 27 Feb 2026 19:42:42 +0000

Move set_compound_head() and clear_compound_head() to be adjacent to the
compound_head() function in page-flags.h.

These functions encode and decode the same compound_info field, so keeping
them together makes it easier to verify their logic is consistent,
especially when the encoding changes.

Link: https://lkml.kernel.org/r/20260227194302.274384-5-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
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

 include/linux/page-flags.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/include/linux/page-flags.h~mm-move-set-clear_compound_head-next-to-compound_head
+++ a/include/linux/page-flags.h
@@ -290,6 +290,17 @@ static __always_inline unsigned long _co
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *tail,
+		const struct page *head, unsigned int order)
+{
+	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
+}
+
+static __always_inline void clear_compound_head(struct page *page)
+{
+	WRITE_ONCE(page->compound_info, 0);
+}
+
 /**
  * page_folio - Converts from page to folio.
  * @p: The page.
@@ -870,17 +881,6 @@ static inline bool folio_test_large(cons
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *tail,
-		const struct page *head, unsigned int order)
-{
-	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
-}
-
-static __always_inline void clear_compound_head(struct page *page)
-{
-	WRITE_ONCE(page->compound_info, 0);
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void ClearPageCompound(struct page *page)
 {
_

Patches currently in -mm which might be from kas@kernel.org are


