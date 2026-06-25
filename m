Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2828534BA33
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 01:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782351869; cv=none; b=mEktfSEql0cyFjZAELvc1l8gC/j8GtQk6SMHp0jZF5RoKd0eqM8v6Qxq314YJIychwJu7zLGpvAmDZAcJhPXqt5f4efYe3XMABQL4lftH9vW0a29v39K2bis3aMuu6xpophgF/wjjlbmqMh149VpXPBt93O2FmuFtVDHR35veGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782351869; c=relaxed/simple;
	bh=gd/rWRPR1EJb1jGzEGnvJddmsy9NxPBe2qQS2UX9nL4=;
	h=Date:To:From:Subject:Message-Id; b=hBsGotKBSePbDlOE73EaBGE1Efeo/zplItswFPG/dcV0c2mDjJM7ZwT+lGTxj9nUGfjTtWr5YpSdOryLX3pqbWWizuT1lQgSvs9irQ1HYRIrh80j8i3QlvbR1DlAjGeKguW9SG+sar1WzwhVegFdQV6ZqQIkcRRBGCEXUahfTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k12WA1+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k12WA1+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886561F00A3A;
	Thu, 25 Jun 2026 01:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782351866;
	bh=OS9CCVokQ+7/HiNGkP0TWCExS+db7XagPv9xcZk1rwM=;
	h=Date:To:From:Subject;
	b=k12WA1+YxJ8NBbghR9KiqVO825292nRihMjlg3XvDlmQH0rBmoCfowQFkzdvACMf1
	 YndUWa4AWx6g7UQlaoi2KvLH2v1+8BhOKKb9k3QKM0zehbplSQo9ng9ZAzF8GUZ5Gx
	 /9SV/NNeoA5axO3Snk6hE3lKEEEaNf195koCIhzs=
Date: Wed, 24 Jun 2026 18:44:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch added to mm-new branch
Message-Id: <20260625014426.886561F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: reduce unnecessary xarray lookups in filemap_get_folios_contig()
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mm/filemap: reduce unnecessary xarray lookups in filemap_get_folios_contig()
Date: Sat, 20 Jun 2026 14:24:46 +0800

Apply the same optimization used in filemap_get_read_batch() by moving the
boundary check from the loop condition to before xas_next(), avoiding an
unnecessary xarray lookup and reducing branches in the fast path.

Link: https://lore.kernel.org/20260620062446.351475-3-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/mm/filemap.c~mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig
+++ a/mm/filemap.c
@@ -2270,10 +2270,11 @@ unsigned filemap_get_folios_contig(struc
 	unsigned long nr;
 	struct folio *folio;
 
-	rcu_read_lock();
+	if (*start > end)
+		return 0;
 
-	for (folio = xas_load(&xas); folio && xas.xa_index <= end;
-			folio = xas_next(&xas)) {
+	rcu_read_lock();
+	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
 		/*
@@ -2281,11 +2282,11 @@ unsigned filemap_get_folios_contig(struc
 		 * No current caller is looking for DAX entries.
 		 */
 		if (xa_is_value(folio))
-			goto update_start;
+			break;
 
 		/* If we landed in the middle of a THP, continue at its end. */
 		if (xa_is_sibling(folio))
-			goto update_start;
+			break;
 
 		if (!folio_try_get(folio))
 			goto retry;
@@ -2293,29 +2294,27 @@ unsigned filemap_get_folios_contig(struc
 		if (unlikely(folio != xas_reload(&xas)))
 			goto put_folio;
 
-		if (!folio_batch_add(fbatch, folio)) {
-			*start = folio_next_index(folio);
-			goto out;
-		}
+		if (!folio_batch_add(fbatch, folio))
+			break;
+
 		xas_advance(&xas, folio_next_index(folio) - 1);
+		if (xas.xa_index >= end)
+			break;
 		continue;
+
 put_folio:
 		folio_put(folio);
-
 retry:
 		xas_reset(&xas);
 	}
+	rcu_read_unlock();
 
-update_start:
 	nr = folio_batch_count(fbatch);
-
 	if (nr) {
 		folio = fbatch->folios[nr - 1];
 		*start = folio_next_index(folio);
 	}
-out:
-	rcu_read_unlock();
-	return folio_batch_count(fbatch);
+	return nr;
 }
 EXPORT_SYMBOL(filemap_get_folios_contig);
 
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch
mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch

