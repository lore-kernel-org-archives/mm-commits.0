Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A549182D83
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 16:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408872; cv=none; b=Js+WygZyqDFQBPWTwlqZVGgdu2Zt4ymZo4IdQK5POFixjWyMFy23hNbeWrfmKacNA2rAPqeUs4q0Zzk9VgJalqD5FOfjc4QmaUsUcfhd213Ahcfc9+kGVUr098aXHkmbYxYFJHM3BaYXDc18+jtRlgwb4St+40wQgS/m0k/VE10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408872; c=relaxed/simple;
	bh=6Sz2QH632CXre0tfv1W2t6FfvzNmPv+J1LDUyBhYkcA=;
	h=Date:To:From:Subject:Message-Id; b=Ci6aStZCQCKRL6FuW0ZAvDduTcn7gPcv8IVto3n/LSRmbYJxVFLNFHUnaB0lCrinJ0ZvsjoWH6ljriGdi4WjU2CMa/BcZamgk/jYAlDbUo9Q6n3l6LKU+3EdYatXwWdLIWejiYS2JiUMh9aerrf0QosFgIFZpaOnKZcBgEf9LoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=irdsEUjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="irdsEUjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD9FC113CD;
	Mon, 29 Apr 2024 16:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714408872;
	bh=6Sz2QH632CXre0tfv1W2t6FfvzNmPv+J1LDUyBhYkcA=;
	h=Date:To:From:Subject:From;
	b=irdsEUjWN9tCIeOdy/Lq0GngJDENC+9sbc0o9jYI/lIoXBAnfn82WKP4Ew0wvprff
	 i7e40BR1ax2x3/g0JMZ7AVDbSM/L6SXLR2+6ChlQjyTEwVRpcLkvUAstTxyM/VIxbI
	 ILO67vWYNQMedgrA79IpMmjs/CXxcKaqdXRhc9g8=
Date: Mon, 29 Apr 2024 09:41:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch added to mm-unstable branch
Message-Id: <20240429164111.DBD9FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: change the type of we_locked from int to bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/rmap: change the type of we_locked from int to bool
Date: Sun, 28 Apr 2024 09:20:48 +0800

Change the type of we_locked from int to bool because folio_trylock return
bool

Link: https://lkml.kernel.org/r/20240428012049.8182-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-change-the-type-of-we_locked-from-int-to-bool
+++ a/mm/rmap.c
@@ -964,7 +964,7 @@ static bool invalid_folio_referenced_vma
 int folio_referenced(struct folio *folio, int is_locked,
 		     struct mem_cgroup *memcg, unsigned long *vm_flags)
 {
-	int we_locked = 0;
+	bool we_locked = false;
 	struct folio_referenced_arg pra = {
 		.mapcount = folio_mapcount(folio),
 		.memcg = memcg,
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-mmap-make-vma_wants_writenotify-return-bool.patch
mm-mmap-make-accountable_mapping-return-bool.patch
mm-page-flags-make-pageuptodate-return-bool.patch
mm-pagemap-make-trylock_page-return-bool.patch
mm-rmap-change-the-type-of-we_locked-from-int-to-bool.patch

