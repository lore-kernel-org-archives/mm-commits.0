Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960D63BB671;
	Wed,  5 Aug 2026 03:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785898991; cv=none; b=GjV4UUIPYIIv738uW6jWdJkXROukCI/RhC+DuhRKYE443ZF6y9qQJuPdZltglDM0xKdA+fvRezzxG7G2wQirKov90jviKBwGuT4z4YwbjboOxTfcBE43M4SYC0+c839XqXPh+KhCz2iweQ/3dJNm36J5UEz7ko/VKM9Db0xokRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785898991; c=relaxed/simple;
	bh=EsXDsxpzlk1krxjxDAjyA9hP24Lu2TeW2EJXVFVXwHI=;
	h=Date:To:From:Subject:Message-Id; b=gtTeVJjKLnKkSVgTD50LEUOXGiDXcrDPMweKES+VxIyLBZDYMvPNxXWC5jxr5PMK5r8eT8M/s7pz6X9pEzHo6qv5ntEH3WPM5C2RS8cXXRsJDQRRn2xkp3jFUodiAdECHIb8AvRMeMmVH/a3FB7TvKujmzeB01qCVzvpFZCxurk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPQBYtv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPQBYtv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111691F000E9;
	Wed,  5 Aug 2026 03:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785898990;
	bh=HmK6z0nmNzhKUERKwJbWwseCv9H41eKI9OA0OqYrqDI=;
	h=Date:To:From:Subject;
	b=xPQBYtv7UYwSUMBnNQDvtPMya9LQQCYmgdSgwCjfCKYG0dIllw9921XzYxRmm80R+
	 z9+Tmudq2ik5NSIGE5ovqRGzkxHvgPyNumA0nyrWAizK8kaCMwdwUZ2wl87TlfktEu
	 laV446U/KbnYiNILNudeQ0/Q2tt1UQlRVt5D8Wwk=
Date: Tue, 04 Aug 2026 20:03:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch removed from -mm tree
Message-Id: <20260805030310.111691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: putback folios on invalid migrate nid
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-putback-folios-on-invalid-migrate-nid.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: liyouhong <liyouhong@kylinos.cn>
Subject: mm/damon/ops-common: putback folios on invalid migrate nid
Date: Sun, 26 Jul 2026 09:48:15 +0800

damon_pa_migrate() and damos_va_migrate() isolate folios into a local list
and then call damon_migrate_pages().  When target_nid is invalid
(including the scheme default NUMA_NO_NODE / -1), damon_migrate_pages()
returns early without putting the folios back to the LRU.

Callers then discard the list head while those folios remain isolated with
an extra reference taken by folio_isolate_lru().  The pages stay off the
LRU for as long as the mapping exists (anon active+inactive counts drop
while RSS does not), and the leftover references can pin the pages after
the mapping is gone.

Put the folios back on the invalid-nid path so ignored migration requests
still return them to the LRU.

Link: https://lore.kernel.org/20260726014815.1280757-1-dayou5941@163.com
Fixes: 7e6c3130690a ("mm/damon/ops-common: ignore migration request to invalid nodes")
Assisted-by: Cursor:grok-4.5
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-putback-folios-on-invalid-migrate-nid
+++ a/mm/damon/ops-common.c
@@ -392,8 +392,15 @@ unsigned long damon_migrate_pages(struct
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY))
+			!node_state(target_nid, N_MEMORY)) {
+		while (!list_empty(folio_list)) {
+			struct folio *folio = lru_to_folio(folio_list);
+
+			list_del(&folio->lru);
+			folio_putback_lru(folio);
+		}
 		return nr_migrated;
+	}
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
_

Patches currently in -mm which might be from liyouhong@kylinos.cn are

mm-memory-failure-fix-refcount-leak-on-soft-offline-lbs-folio.patch

