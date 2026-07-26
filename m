Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773718DF80;
	Sun, 26 Jul 2026 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785027293; cv=none; b=HECDnX/O1zrLrsstLtBlicWZ/TeRYCjVbd7OWzZxEPOgJLGvABS8QZXJH4d6khLvqpUuHUUGxSfxeN4oZ7rJ7HKGA++U9F9i2PYVWQLHpURtJs9xEYp7ti/z1X7Ekj2guuehw7U8PrP6vY8TcTYPNle9XE/wOjKPRKt04jTdL74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785027293; c=relaxed/simple;
	bh=BXQhL2CFAgtlJJSfIuodK01uaOQ2BWkHO2URvoqpha4=;
	h=Date:To:From:Subject:Message-Id; b=hVrFSmleRuwgRsu4O0MijOWMoSTAD4C1nh6CWdGP+MynrvXwXgrxXlArhLnhSKtzntCEV5R2jWsAii7jt1SBtfPX40p8CWYv6odvAiGVK+XEvKASYwrenAJhNb06fzgTq/FspqhkjXxobm9KIrATQeiiIQSg/W6vnSE/+O8sTss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzrUWn0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzrUWn0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273A21F000E9;
	Sun, 26 Jul 2026 00:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785027292;
	bh=XcYFCAXo9HrTKkjFMYfT8xvow1Yi+ERMUUs+iRUe0o0=;
	h=Date:To:From:Subject;
	b=IzrUWn0C+0rwSQ1MMBP0q7mJNgx2M1yAGcZbZwByP1i8DflMVvIuYmQZ5YOmLFDt4
	 NwMY8c+80t4tCH7tRHi2xwAFSuEH6ygkuO+fwCzR9JH+jk6BW+nXQC5UezR3QPwCov
	 UEp89M5nPNy5zg0NhuSQFMCdU4l+6OayHIXkorkY=
Date: Sat, 25 Jul 2026 17:54:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,david@fromorbit.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,mfleming@cloudflare.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-initialise-workingset-state-before-folio-split.patch added to mm-hotfixes-unstable branch
Message-Id: <20260726005452.273A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: Initialise workingset state before folio split
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-initialise-workingset-state-before-folio-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-initialise-workingset-state-before-folio-split.patch

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
From: Matt Fleming <mfleming@cloudflare.com>
Subject: mm/huge_memory: Initialise workingset state before folio split
Date: Sat, 25 Jul 2026 11:14:19 +0100

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset.  That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Link: https://lore.kernel.org/20260725101419.3938406-1-matt@readmodwrite.com
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-initialise-workingset-state-before-folio-split
+++ a/mm/huge_memory.c
@@ -4033,7 +4033,7 @@ static int __folio_split(struct folio *f
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
+		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
 			goto out;
@@ -4047,6 +4047,8 @@ static int __folio_split(struct folio *f
 			goto out;
 		}
 
+		mapping_set_update(&xas, mapping);
+
 		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);
_

Patches currently in -mm which might be from mfleming@cloudflare.com are

mm-huge_memory-initialise-workingset-state-before-folio-split.patch

