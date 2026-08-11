Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C793ACEF2;
	Tue, 11 Aug 2026 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786477124; cv=none; b=GQ+mxL40VNVft261glrnanL11Nk08m+MQHaf+AkEIzT++NMsoW/ayR9nxgWulehHm3OCo1+5DWBLU3oV3TinIm6keUgDOYqtXrMOarpQc76nMGcSzJ9be5ijBRnaXgmEcSRp3EgmahrsaRAooWe/pfJT7GQ/kmzrFhXiBkQvi28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786477124; c=relaxed/simple;
	bh=kdwaezZG/lpZUu9hqQOgK0xeZGI07Ie8FRbsQ+Wefs8=;
	h=Date:To:From:Subject:Message-Id; b=DxOkLwcVowFlmu1HUVcDDGbEoov/Ig2W82LLojcmUepksYrCY9woXvPgxSou1nmd+DIPIoB6t7ye/iYEKSc987PHn7Q1kc9ZXNALtRQrTXW1i8Fz/F+BaSykwNhmJf4qJWL+7x5FZNvFdTnUPHAWe0hHqJZMxZKLJUW6Rts9ffQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bjB/ZtmB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bjB/ZtmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DF71F000E9;
	Tue, 11 Aug 2026 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786477122;
	bh=wK9xAUNm/7h0OUd/u47IfYHlJkbMbItUmfct8dEIfi8=;
	h=Date:To:From:Subject;
	b=bjB/ZtmBXqQe0DSok12IUkiZvsbznWkPu8EyqEM0YV9FVwAvYc4kkyjEimeBFwO/G
	 Ri3wxlJmiGe0EXRbcZJfVzLFAc/qjJWO+9Kl3Ki5AlrRn8lccK35PmsfLgmumx9t7w
	 o6Q/TSuGyQFG+9q1h7Qv7IM4fOaNhi3tSocfeEoY=
Date: Tue, 11 Aug 2026 12:38:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,mboone@akamai.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,imv4bel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagewalk-fix-stale-walk-action-escaping-walk_pmd_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20260811193842.A5DF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pagewalk: fix stale walk->action escaping walk_pmd_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-pagewalk-fix-stale-walk-action-escaping-walk_pmd_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagewalk-fix-stale-walk-action-escaping-walk_pmd_range.patch

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
From: Hyunwoo Kim <imv4bel@gmail.com>
Subject: mm/pagewalk: fix stale walk->action escaping walk_pmd_range()
Date: Wed, 12 Aug 2026 01:18:57 +0900

If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none() check is
retried.  The PMD entry may be cleared at the point of retry.

In this case, if walk->ops->install_pte is not specified, the code
continues to the next PMD entry in the range without resetting
walk->action to ACTION_SUBTREE.

This leaves walk->action erroneously set to ACTION_AGAIN, which is
incorrect.

This was incorrect but not problematic up until commit 3b89863c3fa4
("mm/pagewalk: fix race between concurrent split and refault") which
updated walk_pud_range() to check for walk->action == ACTION_AGAIN upon
walk_pmd_range()'s return, causing the PUD walk to be retried.

In this case this results in duplicate walk callbacks being invoked, which
is erroneous and will break any caller that is not idempotent with respect
to this (and waste time for those which are).

A specific example of this breaking things is mincore which walks an
internal cursor data structure a byte at a time on assumption that page
table entry callbacks are called only once for each entry.

Fix the problem by resetting walk->action to ACTION_SUBTREE prior to the
none check.

The pattern also exists in walk_pud_range() so fix it there too.

This issue was found through AI-based fuzzing.

Link: https://lore.kernel.org/20260811161949.3879321-2-imv4bel@gmail.com
Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Max Boone <mboone@akamai.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/pagewalk.c~mm-pagewalk-fix-stale-walk-action-escaping-walk_pmd_range
+++ a/mm/pagewalk.c
@@ -126,6 +126,7 @@ static int walk_pmd_range(pud_t *pud, un
 	pmd = pmd_offset(pud, addr);
 	do {
 again:
+		walk->action = ACTION_SUBTREE;
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			if (has_install)
@@ -138,8 +139,6 @@ again:
 				continue;
 		}
 
-		walk->action = ACTION_SUBTREE;
-
 		/*
 		 * This implies that each ->pmd_entry() handler
 		 * needs to know about pmd_trans_huge() pmds
@@ -196,6 +195,7 @@ static int walk_pud_range(p4d_t *p4d, un
 	pud = pud_offset(p4d, addr);
 	do {
  again:
+		walk->action = ACTION_SUBTREE;
 		next = pud_addr_end(addr, end);
 		if (pud_none(*pud)) {
 			if (has_install)
@@ -208,8 +208,6 @@ static int walk_pud_range(p4d_t *p4d, un
 				continue;
 		}
 
-		walk->action = ACTION_SUBTREE;
-
 		if (ops->pud_entry)
 			err = ops->pud_entry(pud, addr, next, walk);
 		if (err)
_

Patches currently in -mm which might be from imv4bel@gmail.com are

mm-pagewalk-fix-stale-walk-action-escaping-walk_pmd_range.patch

