Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303C8403AFF
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219113; cv=none; b=B8gz5FnlgQpL6MI+i2WNAQZJtc8XRAZxgtZ/fn+bl4nQPnyo5vDXViX2WMon2WpHm2hLLWa/mE9+TkDzDogtkmbfvXK9+pOC+QW4x9nl6e19RTWY6oxpOEGAjjG2JEk1PGBFrbAECMGhn/SbjYvw6t4B5Gh0PAkETwXFQK0whW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219113; c=relaxed/simple;
	bh=+CChTs1leUFWpIG+OFxp+miqsdvWUACvQb0o5K24k8M=;
	h=Date:To:From:Subject:Message-Id; b=JoCmBHdmNm3nWj1ABk30iflH85tDCsnEDWdpgTPhUlrAT3TtEorwcg/eootzjONYTw4M1aWwLTEAeoRppYUFo0Y0sc6viBwh2zJ91aK5kdEDdXFnnrpiTe+nOxjqSjAYsF+rOWm6PWZqKz8ES2JkXcdfx5tWlDVakOrC5Thski0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bgvv/Iy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bgvv/Iy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ABD1F000E9;
	Mon, 31 Aug 2026 23:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219112;
	bh=D32YU8yFMv9j7SJaTXMLNss27ChlzPcKnXpqz4+b5tY=;
	h=Date:To:From:Subject;
	b=Bgvv/Iy4nKpGu34OWo7vbW8m/vmg9PqbtblgRJ0hcvEAnnl051sYXF9MD0ynGnsqa
	 oXuBzGmoj+CrMpZ6xtGjndTCpMvlLjRT+AJh1yEmsTJlhgC30HloFdEnzovAuciHj/
	 MvurrKisogAisDY47lWsn2N/EGLKDi3THsJ8rj/k=
Date: Mon, 31 Aug 2026 16:31:51 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,liyouhong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-factor-out-damon_putback_folio_list.patch added to mm-new branch
Message-Id: <20260831233152.00ABD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: factor out damon_putback_folio_list()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-factor-out-damon_putback_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-factor-out-damon_putback_folio_list.patch

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
From: Li Youhong <liyouhong@kylinos.cn>
Subject: mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Mon, 31 Aug 2026 07:26:05 -0700

The putback loop is duplicated in damon_migrate_folio_list() and on the
invalid-nid path of damon_migrate_pages().  Factor it into a small helper
for readability.  No functional change.

Link: https://lore.kernel.org/20260831142611.77572-4-sj@kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-factor-out-damon_putback_folio_list
+++ a/mm/damon/ops-common.c
@@ -330,6 +330,19 @@ static unsigned int __damon_migrate_foli
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
@@ -371,13 +384,7 @@ keep:
 
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
@@ -394,14 +401,7 @@ unsigned long damon_migrate_pages(struct
 
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

mm-damon-ops-common-factor-out-damon_putback_folio_list.patch

