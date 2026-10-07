Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5764930BF6D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334287; cv=none; b=WXYAtP9l9lsg3X1s3sX+5VOINUj1y0pOreHpQiFz/IVLGPdHfjWhySU1J7b8Yp7OrW2MPgexHQ84ACzBuZTcjg8qJ2YKFEFzTjhpD/sQWTOF7g+eVsOfP5lMxsUrDMzOXmAEtbwCwSQFVNKmwpKsBt4JDCjnU61uUVIXKeHX828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334287; c=relaxed/simple;
	bh=7oiF5wbxuegoYqfTyroEIjCrcIlG1DaCjoV44k9i5UQ=;
	h=Date:To:From:Subject:Message-Id; b=G70BrYiGCoxiO06s9s1JcrJI3Qzea/SWAlnQEpDl5rwMHDMFuRBdaBkBzyjOKHPycBkS+dEQNjw/cupMI7qOaV+9mwmOHCLNnnueG7V8Dfl+ifyRbgZSkEfqlYdUMx/PHqerXkCWtS/HT8G/3gAJj2dJKyMmczMnPX+B8Im3afs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XtXQ3PgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XtXQ3PgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6541F0089C;
	Wed,  7 Oct 2026 00:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334286;
	bh=p+HpBJpMEZtArAQs8aoC6lSG9JXUcl3n+501CM0Li7M=;
	h=Date:To:From:Subject;
	b=XtXQ3PgJi5FoK+J29nZxyFih9I4KDDPnOR84crrJZJDjyZrtOB6H3DJeJ74z/obg4
	 +2lZ7W0RdB94kZzxgR09OdO/HuGL7EBx4aFz+qwEzVQYAYBjXCSBWK3BZbZaRds4jT
	 80bLCDiK/fKmjAeGbgVR5BCG/ED34jwSFJHb1x7A=
Date: Tue, 06 Oct 2026 17:51:25 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-factor-out-damon_putback_folio_list.patch removed from -mm tree
Message-Id: <20261007005126.2E6541F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: factor out damon_putback_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-factor-out-damon_putback_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Youhong <liyouhong@kylinos.cn>
Subject: mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Mon, 31 Aug 2026 07:26:05 -0700

The putback loop is duplicated in damon_migrate_folio_list() and on the
invalid-nid path of damon_migrate_pages().  Factor it into a small helper
for readability.  No functional change.

Link: https://lore.kernel.org/20260831142611.77572-4-sj@kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---

 mm/damon/ops-common.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-factor-out-damon_putback_folio_list
+++ a/mm/damon/ops-common.c
@@ -335,6 +335,19 @@ static unsigned int __damon_migrate_foli
 	return nr_succeeded;
 }
 
+static void damon_putback_folio_list(struct list_head *folio_list)
+{
+	struct folio *folio;
+
+	while (!list_empty(folio_list)) {
+		folio = lru_to_folio(folio_list);
+		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
+		folio_putback_lru(folio);
+	}
+}
+
 static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 						struct pglist_data *pgdat,
 						int target_nid)
@@ -376,13 +389,7 @@ keep:
 
 	list_splice(&ret_folios, folio_list);
 
-	while (!list_empty(folio_list)) {
-		folio = lru_to_folio(folio_list);
-		list_del(&folio->lru);
-		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
-				folio_is_file_lru(folio));
-		folio_putback_lru(folio);
-	}
+	damon_putback_folio_list(folio_list);
 
 	return nr_migrated;
 }
@@ -399,14 +406,7 @@ unsigned long damon_migrate_pages(struct
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
 			!node_state(target_nid, N_MEMORY)) {
-		while (!list_empty(folio_list)) {
-			struct folio *folio = lru_to_folio(folio_list);
-
-			list_del(&folio->lru);
-			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
-					folio_is_file_lru(folio));
-			folio_putback_lru(folio);
-		}
+		damon_putback_folio_list(folio_list);
 		return nr_migrated;
 	}
 
_

Patches currently in -mm which might be from liyouhong@kylinos.cn are


