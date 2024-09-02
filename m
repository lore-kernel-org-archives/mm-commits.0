Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F047A5C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247729; cv=none; b=C5T3ObHYQXaVWM8AlHoA1JWQ9XsW1Nlk7gfKxk3FUigdod/LKznZaU4Y8Lk71Fvi/rYkYAbmih/ugpjapXoIAibGmoqS5b+3vZytbTQNExtFyGXFXnKqnYBVn2tS+eUgJ4aGUzPh8MGWFLpmgnwmCOvmyzoljupHmzTF8uqsKMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247729; c=relaxed/simple;
	bh=iM2j1/Xoa6jij34OYlHb1gHlJ/5YRTVXDhBc2zhdClk=;
	h=Date:To:From:Subject:Message-Id; b=JCfucCQolixrqYDsUbIQ3OxldIqsqyhHN4xT+Ttuqhpq6Fk5e+ftH/LIfFnKTwJUrXWhkVssyjwtOIyyFfexK7cHFfClPbxV9AGnEV6NHVmhre0MTbeSqDwgtJwkMS+WILurFiK9avkNdH/lVddhygrQti/QN++PRe8a6/8ovd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bUu5cVv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bUu5cVv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8062C4CEC2;
	Mon,  2 Sep 2024 03:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247729;
	bh=iM2j1/Xoa6jij34OYlHb1gHlJ/5YRTVXDhBc2zhdClk=;
	h=Date:To:From:Subject:From;
	b=bUu5cVv896CYjGaDH70CI9F6KSwx+OlIohf0HI96ZcJClZUdkYk/wBelM1qxUyG4I
	 U2AnG4hCihvDG2642ewrldK3Rr1LPCpLHYJVJRSQrCJYQf7Mm9dEHAFHzT8rzcnSON
	 dkrXmbKtNT2co1ZtXyRhrA09wivtO1v0Sa9eo55Q=
Date: Sun, 01 Sep 2024 20:28:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch removed from -mm tree
Message-Id: <20240902032849.A8062C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: cleanup partially-mapped handling in __folio_remove_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: cleanup partially-mapped handling in __folio_remove_rmap()
Date: Wed, 10 Jul 2024 23:43:50 +0200

Let's simplify and reduce code indentation.  In the RMAP_LEVEL_PTE case,
we already check for nr when computing partially_mapped.

For RMAP_LEVEL_PMD, it's a bit more confusing.  Likely, we don't need the
"nr" check, but we could have "nr < nr_pmdmapped" also if we stumbled into
the "/* Raced ahead of another remove and an add?  */" case.  So let's
simply move the nr check in there.

Note that partially_mapped is always false for small folios.

No functional change intended.

Link: https://lkml.kernel.org/r/20240710214350.147864-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/mm/rmap.c~mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap
+++ a/mm/rmap.c
@@ -1568,22 +1568,19 @@ static __always_inline void __folio_remo
 			}
 		}
 
-		partially_mapped = nr < nr_pmdmapped;
+		partially_mapped = nr && nr < nr_pmdmapped;
 		break;
 	}
 
-	if (nr) {
-		/*
-		 * Queue anon large folio for deferred split if at least one
-		 * page of the folio is unmapped and at least one page
-		 * is still mapped.
-		 *
-		 * Check partially_mapped first to ensure it is a large folio.
-		 */
-		if (folio_test_anon(folio) && partially_mapped &&
-		    list_empty(&folio->_deferred_list))
-			deferred_split_folio(folio);
-	}
+	/*
+	 * Queue anon large folio for deferred split if at least one page of
+	 * the folio is unmapped and at least one page is still mapped.
+	 *
+	 * Check partially_mapped first to ensure it is a large folio.
+	 */
+	if (partially_mapped && folio_test_anon(folio) &&
+	    list_empty(&folio->_deferred_list))
+		deferred_split_folio(folio);
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

