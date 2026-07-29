Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596E38D3ED
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298388; cv=none; b=qHq3KprdtN/SNHwp/ylJqGv9AK4XFcCbbnyVzjU8VHb1Agf4du1d4F2FP/FxdMh1P3bBVkbL6ZxaPSC8Cao6ORKdsTyrB4jQu1Sf2E8rK6Vnrbqgl+b4YTnb1UZ21VuuM0pTbqVpa2EmDQCWyQXEYfpuaE6ApMiDe4Wg4EHFmFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298388; c=relaxed/simple;
	bh=pe1r8iaH+J9u6vWnFSlBhriguxtONO3oGZzBPkvE0L8=;
	h=Date:To:From:Subject:Message-Id; b=hDNThSXCDDPMA4Gcs+XuMa93CDgxtimudOI1eUP3GRKN04QEcX9+xiClbCbcIPh4CWcqrq84pyrarm3G7daM2Mwg5Xiizv4xrrktuaUOw8Dl4jGHq0KxUVQprOTPo31WTv35mW3at5ui3kwTlFHvVxK5QIsgyzuqQJaWjZgXgH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lPomjKTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lPomjKTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97841F000E9;
	Wed, 29 Jul 2026 04:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298387;
	bh=vQQw9IeAYQKGIT5iXC+0qIFiiGlzAC1aQS7oBksXvvw=;
	h=Date:To:From:Subject;
	b=lPomjKTitGebvQcryIw5yzhX9rA4fNoc95UyJiiwgmkH2B0y671sionjJHlf6vWnq
	 EuFWMq/o4cv0iY+PL2ITbtWatCuzkqZBGIiNj2FGPascp7/Y5CmpN6axO+O3cpHKwh
	 gKGS9c6CWxlDpHAr6uJuhe90Ps4oDyN4pbpr8B1g=
Date: Tue, 28 Jul 2026 21:13:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch removed from -mm tree
Message-Id: <20260729041306.D97841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: reduce unnecessary xarray lookups in filemap_get_folios_contig()
has been removed from the -mm tree.  Its filename was
     mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


