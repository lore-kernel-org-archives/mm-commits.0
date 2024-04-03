Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F71552FF
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712176022; cv=none; b=Hl0z/oxwYmArAP6ingDyIKgNJf60iBAwnXqZeNy5ie5622tvrvNDN/JgFGgP4QiJ5NvAyieLi5Di+OgyBOFxccR7PpxfUXn3E4VmMz2OIrPPnrY3LJxg1rXmg0bgXRp9Nb7Mt0MUUSMjryIOKd68BucZYyJlRpjbB8dyXa6fpQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712176022; c=relaxed/simple;
	bh=+fe3mD6AL4yfGqoYgAAVC1qrk5IaCZ39lRCpqJoPnG8=;
	h=Date:To:From:Subject:Message-Id; b=bleEvxPvdsj+YC54SSBiCfVH1zAtrz9oxMOx+98PglBOInHxwhAgzLKOD/9cL+bAYN7QqKyrbLIqmQ+0iexPswY/u9NFwXgkskUuWjVEbKy15gQnKOoEpPiNyyBiX9OeFEEUFZzKzTl2FN0gqU1U/8/MJNKL7wR3/GoXGnmaaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fW4y7e29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fW4y7e29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D23C433C7;
	Wed,  3 Apr 2024 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712176021;
	bh=+fe3mD6AL4yfGqoYgAAVC1qrk5IaCZ39lRCpqJoPnG8=;
	h=Date:To:From:Subject:From;
	b=fW4y7e29VoD6SX8DFJQ1U2SRFqwzOrG9O350+2BRPsfY7mlRNVHBqOIQIQnsxLawO
	 k3i213eg06WDnAc9p52tb6AjTqs/Iz34g+lUN1nyrIVxxvYEE0osGD/73z2JRVgFsX
	 QrEgThJgKTBNvlLNHVjkAeFB/5CYQtuEaSj0wTSI=
Date: Wed, 03 Apr 2024 13:27:00 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,aishwarya.tcv@arm.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slab-move-memcg-charging-to-post-alloc-hook-fix.patch added to mm-unstable branch
Message-Id: <20240403202701.76D23C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! mm, slab: move memcg charging to post-alloc hook
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-move-memcg-charging-to-post-alloc-hook-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-move-memcg-charging-to-post-alloc-hook-fix.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: fixup! mm, slab: move memcg charging to post-alloc hook
Date: Wed, 3 Apr 2024 17:45:15 +0200

The call to memcg_alloc_abort_single() is wrong, it expects a pointer to
single object, not an array.

Link: https://lkml.kernel.org/r/4af50be2-4109-45e5-8a36-2136252a635e@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Tested-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slab-move-memcg-charging-to-post-alloc-hook-fix
+++ a/mm/slub.c
@@ -2172,7 +2172,7 @@ bool memcg_slab_post_alloc_hook(struct k
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, p);
+		memcg_alloc_abort_single(s, *p);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-change-move_freepages-to-__move_freepages_block.patch
mm-slab-move-memcg-charging-to-post-alloc-hook.patch
mm-slab-move-memcg-charging-to-post-alloc-hook-fix.patch
mm-slab-move-slab_memcg-hooks-to-mm-memcontrolc.patch

