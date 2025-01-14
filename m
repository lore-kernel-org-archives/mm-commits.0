Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C7F288CC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 02:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736823079; cv=none; b=HIoT4Zyp4qLxzX3syyA3h8xtTJ+6Oj+C6GkJwHrx92RysgRkIr7CXt6mooibJp4ut/2Fm4AYeLQsJka/BJ7QcR07iatGe35mqnNme2iiGZnfOWSsRJM2tq/O2mwbn+iU9Q4Y5KLGnQC6UgpamesZRZcCRsf1/VKBQAA+7tPUIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736823079; c=relaxed/simple;
	bh=8Illt2HinXZK+DYvej/lQEJPuBR+crV3pc1gPT8Mglo=;
	h=Date:To:From:Subject:Message-Id; b=HefbRHoW9qv0YRYwXAKV2xX3FXzeqyGaIWGuKVUhG8v+vzgmzfbpQ4+/CL6sYNssM0IXdGl0ImEv5cxOIJO6n+mRkxyWJ1jM2SYgTa4lKjdcrUG0zSsv0vXjP4wX68dvDvjGc3qZoNcOtp8oA12Lp2bVXJ4gFSVcgDA39PynYQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XpBNlLLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XpBNlLLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAB0C4CED6;
	Tue, 14 Jan 2025 02:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736823077;
	bh=8Illt2HinXZK+DYvej/lQEJPuBR+crV3pc1gPT8Mglo=;
	h=Date:To:From:Subject:From;
	b=XpBNlLLuGJL9vKJic7c5bgJXdIuYVyKckVEHoWCYogM4DuTyznhR4FgniPlpo3H5o
	 fc0VOg022MskIU/ues0X3vYwAILCAE21fAAGlqNucu3OOyHUNPShVRNRuHq/7BM0fS
	 pE0uZESS2gPaanqoDqXG8f2T5PGqAZeWZJi9YE5I=
Date: Mon, 13 Jan 2025 18:51:16 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-add-ksm-involvement-information-for-each-process-fix.patch added to mm-unstable branch
Message-Id: <20250114025117.7AAB0C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm-add-ksm-involvement-information-for-each-process-fix
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-add-ksm-involvement-information-for-each-process-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-add-ksm-involvement-information-for-each-process-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-add-ksm-involvement-information-for-each-process-fix
Date: Mon Jan 13 06:48:34 PM PST 2025

wording tweaks, per David and akpm

Cc: David Hildenbrand <david@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/Documentation/filesystems/proc.rst~ksm-add-ksm-involvement-information-for-each-process-fix
+++ a/Documentation/filesystems/proc.rst
@@ -2257,10 +2257,10 @@ Description
 ksm_rmap_items
 ^^^^^^^^^^^^^^
 
-The number of ksm_rmap_item structure in use. The structure of
-ksm_rmap_item is to store the reverse mapping information for virtual
-addresses. KSM will generate a ksm_rmap_item for each ksm-scanned page
-of the process.
+The number of ksm_rmap_item structures in use.  The structure
+ksm_rmap_item stores the reverse mapping information for virtual
+addresses.  KSM will generate a ksm_rmap_item for each ksm-scanned page of
+the process.
 
 ksm_zero_pages
 ^^^^^^^^^^^^^^
@@ -2289,14 +2289,16 @@ ksm_merge_any
 ^^^^^^^^^^^^^
 
 It specifies whether the process'mm is added by prctl() into the candidate list
-of KSM or not, and KSM scanning is fully enabled at process level.
+of KSM or not, and if KSM scanning is fully enabled at process level.
 
 ksm_mergeable
 ^^^^^^^^^^^^^
 
-It specifies whether any VMAs of the process'mm are currently applicable to KSM.
+It specifies whether any VMAs of the process'mm are currently applicable
+to KSM.
 
-More information about KSM can be found at Documentation/admin-guide/mm/ksm.rst.
+More information about KSM can be found in
+Documentation/admin-guide/mm/ksm.rst.
 
 
 Chapter 4: Configuring procfs
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

