Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D62338AC96
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298386; cv=none; b=tyIEidw8gYLJLkv+wAk/na2l2CCSCuWlcAIO65e5znHHbXg3h/ro1WW85XzWCxDDt+u53sgOAqcBFQoZvilvx/61qsPLePYR3dg9U55QcIbkrR3VQfTwtCaFigLDPKTyfNUe5VQH92wq33g/RDCDV/ou7XnOwlhQZXICwfjUPro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298386; c=relaxed/simple;
	bh=zVY8JO3p3noXS+1XzwbF4I3JA8J5ScajV2HhgWJEuHs=;
	h=Date:To:From:Subject:Message-Id; b=TgfNmObfvN8C9hvxgt56zfTtoquoun46uSbf35hGxXwC4I816X+QAzSHlVkmaG00YKU0waY4Ha7GlFYjFJDxVhHktekWQzELwKgT3oYWbts7QpA1G9fluh3sooul1MKC1tX+TAmfstg2vdjwX9IYdSdQmYsX8XzO34LVWtSz34E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wWunx+VT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wWunx+VT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1A11F000E9;
	Wed, 29 Jul 2026 04:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298385;
	bh=Golh+JX8OctF7fjYGfjE7K1PIUsTm2vXENPOfp1tkHw=;
	h=Date:To:From:Subject;
	b=wWunx+VT/IPmbfFfhQiFE9q9g4WRdpfLjEMHMJ7mTdPbJxKEgJA7zF+hjGVMthH+y
	 FhTd1qsUqYkuwbzVrWDkldEA3cRXWDiYewNNN6vrOFbAjAlvNj7ETYDQojBACuDKpV
	 TqC8Itpql7M7Bb+QBk/9Vp0svP6toE9JR2MbZtPI=
Date: Tue, 28 Jul 2026 21:13:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch removed from -mm tree
Message-Id: <20260729041304.DF1A11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: reduce unnecessary xarray lookups when read cached pages
has been removed from the -mm tree.  Its filename was
     mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mm/filemap: reduce unnecessary xarray lookups when read cached pages
Date: Sat, 20 Jun 2026 14:24:45 +0800

Patch series "mm/filemap: reduce unnecessary xarray lookups".

This series optimizes xarray lookups in filemap by avoiding redundant
iterations after obtaining the last needed folio.  The boundary check is
moved to before advancing the xarray iterator, eliminating unnecessary
lookups and branches in the fast path.  This reduces the overhead of
filemap_get_read_batch() from 2.91% to 2.53% in 4k read tests.


This patch (of 2):

When reading small amounts of data from the page cache, only a single
folio is typically returned from filemap_read_get_batch().  In this case,
calling xas_advance() or xas_next() after adding the folio to the batch is
unnecessary and only introduces extra branches.

The same issue exists for large reads, where one additional xarray walk is
always performed before termination.

Quit the loop once we get the last folio in the range, so the final
redundant xarray advancement can be avoided.

The xas_next() does not update xa_index when xas->xa_node is set to
XAS_RESTART, so the put and retry path would not update xa_index, hence
the warning should therefore never trigger.

During the 4k reads test, the overhead of this function dropped from 2.91%
to 2.53%.

Link: https://lore.kernel.org/20260620062446.351475-2-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages
+++ a/mm/filemap.c
@@ -2467,11 +2467,14 @@ static void filemap_get_read_batch(struc
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
 
+	if (index > max)
+		return;
+
 	rcu_read_lock();
 	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
-		if (xas.xa_index > max || xa_is_value(folio))
+		if (xa_is_value(folio))
 			break;
 		if (xa_is_sibling(folio))
 			break;
@@ -2488,6 +2491,8 @@ static void filemap_get_read_batch(struc
 		if (folio_test_readahead(folio))
 			break;
 		xas_advance(&xas, folio_next_index(folio) - 1);
+		if (xas.xa_index >= max)
+			break;
 		continue;
 put_folio:
 		folio_put(folio);
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are


