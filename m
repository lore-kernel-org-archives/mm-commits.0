Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F019D2D47E9
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452076; cv=none; b=XTsAGEm1f/26JYWfgbGBrt3Pa2bl5ITJ480RuIyATW1D/f9e/6Q2NzKv2T9du1l0Dip38fwDWoOrq4jetHMql57zYP2NUP4YFYIRmDTeSwm1OZoGSybJpkVar/L0C5j3EagWBs6A8hfVMC2HbNHvSFYsXzXpO9DNCg6nOY0/9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452076; c=relaxed/simple;
	bh=cD4Ph5yxNvWBRELtrahru5Sdm/crQWFUrTDkPtuEVR0=;
	h=Date:To:From:Subject:Message-Id; b=bOFM40cak5yy1PuMgn42UalnRzlqBCBg/C4CdYNHsKAIXcl0XlCowmXO8vyVugY0O8+GKH9syJVIO2C+4mOgxCNZHA68bs6ryCmb8BN+2kIOHWL4cXEZRxj6q/q4twcjSZ91/RdjBWFszaE2TarLAlGOLoOk7wYVw2fbRidL8XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A5Q+2wzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A5Q+2wzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD851F000E9;
	Tue,  7 Jul 2026 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783452074;
	bh=XExpXz3ZimMECKncL+macb7K1y0vXsrwDyVSaoosMVg=;
	h=Date:To:From:Subject;
	b=A5Q+2wzI64TSrLXI9igOcBBFnN6RysxExkbypNTJaQrbTZBAxdYBLepMJCYKb1IXH
	 t+fBmpD1PfszJwCBK77F8V3znQaeKvuUXasCLKc8yQwMUG/hSbX9R3coGUnMlKbR10
	 9eMZ1UFm58LOzQ2qLn9s0t49gR3NindJqUovLiHs=
Date: Tue, 07 Jul 2026 12:21:14 -0700
To: mm-commits@vger.kernel.org,zhen.ni@easystack.cn,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-numa-node-filter-fix.patch added to mm-unstable branch
Message-Id: <20260707192114.8AD851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_owner-add-numa-node-filter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-numa-node-filter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-numa-node-filter-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: "Zi Yan" <ziy@nvidia.com>
Subject: mm-page_owner-add-numa-node-filter-fix
Date: Tue, 07 Jul 2026 11:54:37 -0400

build fix

Link: https://lore.kernel.org/DJSGLP9VFLRI.355AAWR2VHIEL@nvidia.com
Signed-off-by: "Zi Yan" <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter-fix
+++ a/mm/page_owner.c
@@ -811,7 +811,7 @@ read_page_owner(struct file *file, char
 			 */
 			if (page_flags.f == PAGE_POISON_PATTERN)
 				goto ext_put_continue;
-			nid = memdesc_nid(page_flags);
+			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter))
 				goto ext_put_continue;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-percpu-km-clear-page-private-before-free-them.patch
mm-compaction-stop-recording-free-page-order-in-page-private.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

