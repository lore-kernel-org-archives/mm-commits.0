Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17894D2FF
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 00:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750809687; cv=none; b=oE2HknouyE625s3bmYFokNnBgmnTgif6BreV44nsHxdL5SJOdJlTxmkJ8FDIT4kfxwiIGhSIezD5ciUvwUJlJlt1jQwkykGB5hdAB15qgkKYSjb7W1sPpsjebgTl8R82+MfuCkIP677nvohUcnADcrooFG6lRjhKZODuEl0mWak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750809687; c=relaxed/simple;
	bh=xMp99tNoPShxFqpqPd8mdjEr9mfWpQj3+GrSM6ql6xk=;
	h=Date:To:From:Subject:Message-Id; b=Usb/SVs+bczqktEgKwm059cFah+ge9HRXsGHMVuO69u4S3cTlCOgIDG+meindZAsQCF3xbVZpKOJ6cjMDWFERJWd4pVaOFUN2tua9TtdJ9UfxyEk17TQco7xSORUT8Qil/L5K8zoPOvMIcWsHhM90Y5vU0/Vj3k67OgtArsfg6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mX4t2rm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mX4t2rm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BA1C4CEE3;
	Wed, 25 Jun 2025 00:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750809686;
	bh=xMp99tNoPShxFqpqPd8mdjEr9mfWpQj3+GrSM6ql6xk=;
	h=Date:To:From:Subject:From;
	b=mX4t2rm17Ll3H0kr6//OtVwRvLFhc7xg2Zn7UFwQbaBivVYeNGlkt04xNgs94k7+g
	 m3KuLaLntGGOSnbgguxlUvFm5uWlak4hxVAecdftd4McPXT8DcSRKkkv2qBpRIzOkm
	 JQ+aYkkirE70xaoU5yDWMGHIkA5sl8bF+4Kfu8sQ=
Date: Tue, 24 Jun 2025 17:01:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] filemap-add-__filemap_get_folio_mpol-fix.patch removed from -mm tree
Message-Id: <20250625000126.79BA1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap-add-__filemap_get_folio_mpol-fix
has been removed from the -mm tree.  Its filename was
     filemap-add-__filemap_get_folio_mpol-fix.patch

This patch was dropped because it was folded into filemap-add-__filemap_get_folio_mpol.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: filemap-add-__filemap_get_folio_mpol-fix
Date: Sun Jun 22 11:41:13 AM PDT 2025

fix EXPORT_SYMBOL()

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-add-__filemap_get_folio_mpol-fix
+++ a/mm/filemap.c
@@ -2032,7 +2032,7 @@ no_page:
 		folio_clear_dropbehind(folio);
 	return folio;
 }
-EXPORT_SYMBOL(__filemap_get_folio);
+EXPORT_SYMBOL(__filemap_get_folio_mpol);
 
 static inline struct folio *find_get_entry(struct xa_state *xas, pgoff_t max,
 		xa_mark_t mark)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
filemap-add-__filemap_get_folio_mpol.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

