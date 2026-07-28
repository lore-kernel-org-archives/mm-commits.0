Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650CE3C417E;
	Tue, 28 Jul 2026 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785262201; cv=none; b=LJCIVo+hJvQkwTp2hZuZlUJ8PMpJkhVPwN8hjR7Phx6hBX2NGBEK1PAHotMnGpFgCoAzbcfMofXm5Fe1y7yyMjKgerr9y1gU952HSjrgAkznfr9DqUAS67jq8GgKfrYkWJJRhGsqaJOeyqj4K+3vjgR/t5ha9HufVOVabvG4P1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785262201; c=relaxed/simple;
	bh=JKVZOOAjxlELEq6KIbgZRBVkknbt0k3dsKUsnMB3aRE=;
	h=Date:To:From:Subject:Message-Id; b=oRt1PcSKoYgFFW3TOgUzAjVwlacpD9WEJ84Oh/Am+vie8NNkORPe8nguu+s84hnWs2tenWvEwwD1YR3IAryzbgeZ0z3YQauS32EhKflYE82ii7vClfbpgxhb7AbuJEfx8NenAq/FW3yOeqv/Qk0+y9H4jFf9F2FqLSmKcBvUY8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbRAnBWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbRAnBWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60361F00A3A;
	Tue, 28 Jul 2026 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785262199;
	bh=eoNC0ImOYeMaPOadbm1raBtLQYxe7rEcSlUlNdHC+D0=;
	h=Date:To:From:Subject;
	b=qbRAnBWnKKoECUzOycXdhN7rzoOY8MFxAUB0akWwYkCPXjH4tNqyKJ81Kp8NdKMGx
	 akuvI9NwfqvLkJepIV5Z7xM48qygcgiP/UnAvc9PagX6VSmULxHX2mJgxRCUDCU8cM
	 V70NfCz4GYbbKBt6jnhAzAGMgZejsYVhuZDukqQ8=
Date: Tue, 28 Jul 2026 11:09:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryncsn@gmail.com,kas@kernel.org,jack@suse.cz,david@kernel.org,carges@cloudflare.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-__filemap_add_folio-restore-index-before-retrying.patch added to mm-hotfixes-unstable branch
Message-Id: <20260728180959.C60361F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: __filemap_add_folio() restore index before retrying
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-__filemap_add_folio-restore-index-before-retrying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-__filemap_add_folio-restore-index-before-retrying.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-filemap-__filemap_add_folio-restore-index-before-retrying.patch

