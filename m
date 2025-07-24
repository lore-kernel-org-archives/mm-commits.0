Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D14217F31
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394008; cv=none; b=LSrJVI+sqmYlRN1ra5oyLwByM6t8jvr8MpP/B8lvyOv140Fxo6xv4Nx4Ksn/H6I9bEqdy56qRNBsWbQJJ4GVa660EjIy7C8BzO3gfQTKsk5Qo7ppdvtABs4+AIy7AoRNGUsyhrnTJ1yClaVWxQxwUJr4LeHhs6QdsGuFP/sMwC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394008; c=relaxed/simple;
	bh=fYPEkEExIQJX8qrhiSnX5ZevJuzb7+WOv4ymdmNvdDE=;
	h=Date:To:From:Subject:Message-Id; b=Uoa0nflgkVS8BwtuSUfVTSikGpBnLiB3vfHAJWgScgG9Uzkcn3fRbn88FzeNuwGsiD1Td5kXPGaWW5XecE7qnsKHDDV5fh89NWUNl4Ka5Xcq8zh7zSk3eMuGkd6yh1VLyZ/P9iurKxufkDN8P2MX2LjcYqqPJBrshVVWcG7ZOvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I8Z57xtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I8Z57xtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E81C4CEED;
	Thu, 24 Jul 2025 21:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753394007;
	bh=fYPEkEExIQJX8qrhiSnX5ZevJuzb7+WOv4ymdmNvdDE=;
	h=Date:To:From:Subject:From;
	b=I8Z57xtFKkFr9IDRlNZyDEOKyEn+TxzJUlAWRK58DzIYk29G9y3AiYLiCQTXZ81p6
	 sQd8DS9uiUaqVdZ+MOVV3B6pnPAtzvuyrmwL2lIMaAAuOhrMGiHQguRhoVVpDIvLqD
	 qqupceLFMq0+tYO9RLV+BKd0FR04v8EUvLc6Fhrw=
Date: Thu, 24 Jul 2025 14:53:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch added to mm-new branch
Message-Id: <20250724215327.77E81C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-add-anon_vma-lifetime-debug-check-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-add-anon_vma-lifetime-debug-check-fix
Date: Thu Jul 24 02:48:22 PM PDT 2025

PAGE_MAPPING_ANON became FOLIO_MAPPING_ANON

Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-add-anon_vma-lifetime-debug-check-fix
+++ a/include/linux/rmap.h
@@ -458,8 +458,9 @@ static inline void __folio_rmap_sanity_c
 	 */
 	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
 		unsigned long mapping = (unsigned long)folio->mapping;
-		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
+		struct anon_vma *anon_vma;
 
+		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
 		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch
selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch
mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch
init-kconfig-restore-config_broken-help-text.patch

