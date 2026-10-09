Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0612B41BA81
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525579; cv=none; b=sEAvuAsH2xd0bJSi1pTxgB9AfXH5+NS8jQLNyHT3oBGkoPTBZBTUBPNBqS2QnjC/Lwt3cY68uELIzsfrQE7cWAraMqAbl7Gtx8j3Dza4yj/znRz92y/I4Cdhrla/qAobz8vaO0N8kelgjfmysm9TglJ4MQZcKK2UmtOlyG6MgJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525579; c=relaxed/simple;
	bh=Ltp1cB4eg4zH4rnsez7R2TWuJZwkti93++/LTK5vurc=;
	h=Date:To:From:Subject:Message-Id; b=Bj6m7Qp0jQtutUFIvUsLvkt2U+KsrrjUhG+K2mj/+smlSnuoSw6CGq4zEXHQtmMl/8LYBg3PFrzrVd+aZ7+tjGnkF/rn4O9k1ZRAgaPK5jIE0XlAHEbx7jMevMY8Pd2KRZ1Q+MQk/eFOr79rGMpgwEnwXPdkeh5MjLUXui4+0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SnjSkwQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SnjSkwQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A331F00899;
	Fri,  9 Oct 2026 05:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525576;
	bh=Lvm9poSbz3iVPyuIPiF9nI3HlYr5WzEncsocZz8MyAk=;
	h=Date:To:From:Subject;
	b=SnjSkwQpUL+g0BrUpw0cq3z2PnZ1652nMJvqkbQPwsYJbu60Xkqo3yAz0wKPJ76Un
	 ChkcygBQIMvT+jEgCfRRRGs9zAnRx1RG41HyooSESjOGMPlJ0ktNyXSH2epvk/p3VT
	 QFPQ/OIOp6rYeVk8XBAGi3UiAh9DUQ2RfVoTRoN0=
Date: Thu, 08 Oct 2026 22:59:36 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,osalvador@suse.de,muchun.song@linux.dev,lance.yang@linux.dev,gourry@gourry.net,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch removed from -mm tree
Message-Id: <20261009055936.62A331F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/hugetlb: use direct assignment instead of folio_change_private()
Date: Sun, 20 Sep 2026 22:28:01 -0400

folio_change_private() should be used along with folio_attach_private() and
folio_detach_private(), where adding and remove ->private content requires
folio refcount change. add_hugetlb_folio() simply sets folio->private to
NULL without refcount manipulation. Change it to direct assignment to avoid
semantic confusion.

It prepares for a future commit that remove PG_private.

No functional change intended.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-5-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Oscar Salvador <osalvador@suse.de>
---

 mm/hugetlb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-direct-assignment-instead-of-folio_change_private
+++ a/mm/hugetlb.c
@@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h,
 	}
 
 	__folio_set_hugetlb(folio);
-	folio_change_private(folio, NULL);
-	/*
-	 * We have to set hugetlb_vmemmap_optimized again as above
-	 * folio_change_private(folio, NULL) cleared it.
-	 */
+	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
+	folio->private = NULL;
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
_

Patches currently in -mm which might be from ziy@nvidia.com are


