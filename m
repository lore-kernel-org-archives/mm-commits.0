Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E4533936C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465799; cv=none; b=KrhQre26QJQbZXfeHfNiiPXoEShfKK/Z8Q7npvlzcbxlplm81n37SFmuklf1ynwz9Cv5qApk+zZ4CW4K6z9UrzrOKbQoprbwAjYOwgF6lXahbXwq2AoKdn4UcLW7qs6qjSd6iKreOBjjMSFqxHpVZCYAnz9HNZS9KpfqXyUsIPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465799; c=relaxed/simple;
	bh=GeRoYT87WKMw6NljCdNBulaQjJCffFtpl0IRksiebdE=;
	h=Date:To:From:Subject:Message-Id; b=REzw8CC2oLWV4mvs5ZE1KNjfMCgxVLdjg81BTBUrrW2NMswiALgDkq4Q6qFTNiYyHyw2yN0wwGhcTnJa71RkOkLUvkIQ9HUumhMeJl7eLIqZS9ldj7Jw40E1Uk/MVanbVdLnx91mdG1bBSizP0tdknq0seIBle9WmtgFI3HCJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sf6gmJlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sf6gmJlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482681F000E9;
	Fri, 31 Jul 2026 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465798;
	bh=0GLC6U6F0Me+Uw1YuZ6kn0oBf0twhboTmgNVRmKegBQ=;
	h=Date:To:From:Subject;
	b=Sf6gmJlwuJeLiFJSU4xKm10uRf82gbjIiBjjLoYzJKGBH9RRIl11JcF0KLDVZMErv
	 ojx8G1HErKWb37Qt65rCwSfDnxXoikFknuzYX7GDg3JZzEyF5VUrT+WQcGwl4/bnef
	 7hB4ZTxOCjAacWk3SYBbZYmKfkMJo87IQxApXwgk=
Date: Thu, 30 Jul 2026 19:43:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-name-some-args-in-a-function-declaration.patch removed from -mm tree
Message-Id: <20260731024318.482681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: name some args in a function declaration
has been removed from the -mm tree.  Its filename was
     mm-name-some-args-in-a-function-declaration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm: name some args in a function declaration
Date: Fri, 03 Jul 2026 12:31:43 +0000

Checkpatch complains about this, a later patch will move the code, fix it
so that checkpatch doesn't complain about that patch.  Do it in a separate
patch so the "move the code" patch is trivial to review using Git's diff
colouring.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-3-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-name-some-args-in-a-function-declaration
+++ a/mm/internal.h
@@ -919,8 +919,8 @@ extern bool free_pages_prepare(struct pa
 
 extern int user_min_free_kbytes;
 
-struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
+		nodemask_t *nodemask);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

