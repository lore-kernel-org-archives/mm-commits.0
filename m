Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F633A9D8A;
	Wed,  5 Aug 2026 03:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898974; cv=none; b=quTLEcqjdAaLxPyqhAsEEZy3EDEbQ+TEuUFPnYcUfRQvtxVQ7oyyEaA942xj2/YdjYaSoHW0bpsEqpNqHML8fbnjR47CfwHl56WZu+xhNZ1iiRQEUTosEvYI4+fyeS2ZmLBGZGYWL0UFVCKiC44c6cbFoglkrIDqjS62fR+TD6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898974; c=relaxed/simple;
	bh=4aJu8OpRZ1ausZCvhpdiW4le9uC9+5Fv/x8ttb+RuP0=;
	h=Date:To:From:Subject:Message-Id; b=cPmFrvsxINEV/8CPLrjuIT94CZma0S5Ce4T1Dw3W8YY06XukhyjBpaYwB1CKLLr7Hq9V6a7t18CrBgIIbI5UxBmA1fWoZ0rPz/q+leG08UiavofA6CRDM1uduGC5H9a/ziX7LUZBLMoELtxR9XSoeIBu6XcSbcZMgyFiX+2bRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gi5jeYQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gi5jeYQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37651F000E9;
	Wed,  5 Aug 2026 03:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898973;
	bh=KK1BMmn/JGCRxfMnlD8zDo0dlqxXCPvNChTi+KkdZvo=;
	h=Date:To:From:Subject;
	b=gi5jeYQQe8ZprlrWE9XuFztcp/Ez8y7fKSNvHf7sXD3GHdLDEoMni4Ks1hnbt74Bq
	 pBpE+ykr5sPAWMb5PjgbgGV+Qk0s9N+XZA8wOnfENg2Tx6lC3ogcGEDRAZsvAyIP0D
	 3OwTi5uPYHiqHTzA6pytDi/sOUgpR2JDNBINtrZk=
Date: Tue, 04 Aug 2026 20:02:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryncsn@gmail.com,kas@kernel.org,jack@suse.cz,david@kernel.org,carges@cloudflare.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-__filemap_add_folio-restore-index-before-retrying.patch removed from -mm tree
Message-Id: <20260805030252.E37651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: __filemap_add_folio() restore index before retrying
has been removed from the -mm tree.  Its filename was
     mm-filemap-__filemap_add_folio-restore-index-before-retrying.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/filemap: __filemap_add_folio() restore index before retrying
Date: Mon, 27 Jul 2026 22:24:14 -0700 (PDT)

In __filemap_add_folio()'s split-a-conflict loop, xas_set_order() is
applied repeatedly: each application modifies xas.xa_index, rounding it
down according to the split_order attempted at that stage: and if all goes
as intended, it eventually (or immediately) converges on an
xas_try_split() to the required folio_order, with xas.xa_index now the
same as index: then xas_store() puts the new folio into the xarray there.

But if a new node was needed, and GFP_NOWAIT allocation did not get one,
the lock is dropped, xas_nomem() used to allocate, and sequence retried. 
If (that part of) the xarray is unchanged when the lock is reacquired, no
problem.  But what if the conflict was meanwhile resolved by another
thread (perhaps even doing the same thing, inserting a folio at that same
index)?  Isn't there a danger of now putting our folio into the xarray at
an intermediate rounded-down index?  With !folio_contains() bug to follow,
when CONFIG_DEBUG_VM=y is checking for that.

Fix this with an xas_set_order() to restore the original xas.xa_index at
the bottom of the loop, so the retry does a full re-evaluation after
reacquiring the lock, and cannot reach xas_store() with the wrong index.

Production was suffering from rare SIGILLs and SIGSEGVs, executable text
found a page away from where it belonged, !folio_contains() bug hit when
debug enabled: symptoms not seen since this patch went in.

Link: https://lore.kernel.org/562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com
Fixes: 200a89c159a7 ("mm/filemap: use xas_try_split() in __filemap_add_folio()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Chris J Arges <carges@cloudflare.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/filemap.c~mm-filemap-__filemap_add_folio-restore-index-before-retrying
+++ a/mm/filemap.c
@@ -931,6 +931,12 @@ unlock:
 
 		if (!xas_nomem(&xas, gfp))
 			break;
+
+		/*
+		 * Lock has been dropped: start again with the original index
+		 * and order (but now with the memory reserved by xas_nomem()).
+		 */
+		xas_set_order(&xas, index, forder);
 	}
 
 	if (xas_error(&xas))
_

Patches currently in -mm which might be from hughd@google.com are


