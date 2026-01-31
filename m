Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF438B7B2
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898349; cv=none; b=oHafYDYGUrjWr1Kwkn38Ody87j8Pg8fC4OfyajXayQIaXWvVK6ftrjbUBsd0HAF78ej6ibay34QY1AqxMtk/wh2AGjg40UsdDH6Suib7BfAadHdsJYjsx/2FUCbIv3gAWQacQ41tNIhwAP6+QrfbHz0IrGNp6knYyQwoVjdV6WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898349; c=relaxed/simple;
	bh=gQGiZp3kKNnCNgsJvj3voD2wLLIJ2ah5E+rYuDRQbfo=;
	h=Date:To:From:Subject:Message-Id; b=EAMgSl8OHnha0TtcaYUEao8qiADKg2rwX8xjJDhTN+Oaho9pI4GzGbUpmKK4Bc/d3EuZw8yziNJQ3Q9QT4rEvAKv90wsbA5cy9Wo3iYZfd+pzwZfOaBMqG0j0p2uLaTsLxi0P5Cpa/2His4rVcSI4XB/noAdX3xvZtJOvkuxSvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZBG4EI7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBG4EI7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C41C116D0;
	Sat, 31 Jan 2026 22:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898349;
	bh=gQGiZp3kKNnCNgsJvj3voD2wLLIJ2ah5E+rYuDRQbfo=;
	h=Date:To:From:Subject:From;
	b=ZBG4EI7qxDty0HtN8fVO7wwHDdXADnWGRK0Rutn8pKmvB6Jf02srNHYQ9axJDusVz
	 r0zTG3BCPYaI9fch52wrp9TucI2+ncwAfy3Mepn45CaTbj+ejlpEIZxuCo7bYTYlc2
	 30pCgQMeZixU5dHJR+nNJivkiTuNZaUIK9sc7FFg=
Date: Sat, 31 Jan 2026 14:25:48 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-reference-to-damon_stat-usage.patch removed from -mm tree
Message-Id: <20260131222549.27C41C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: add reference to DAMON_STAT usage
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-reference-to-damon_stat-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add reference to DAMON_STAT usage
Date: Sun, 18 Jan 2026 10:02:55 -0800

Design document's special-purpose DAMON modules section is providing the
list of links to the usage documents of existing DAMON modules.  It is
missing the link for DAMON_STAT, though.  Add the missed link.

Link: https://lkml.kernel.org/r/20260118180305.70023-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-reference-to-damon_stat-usage
+++ a/Documentation/mm/damon/design.rst
@@ -834,7 +834,7 @@ To support such cases, yet more DAMON AP
 simple and optimized user space interfaces are available.  Currently, two
 modules for proactive reclamation and LRU lists manipulation are provided.  For
 more detail, please read the usage documents for those
-(:doc:`/admin-guide/mm/damon/reclaim` and
+(:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
 
_

Patches currently in -mm which might be from sj@kernel.org are


