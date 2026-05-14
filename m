Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C535214812
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719111; cv=none; b=JgrME5E8iv7Y3dLKctE9C6E8FPhrboYPPhSdVP4yJi90wJ2OojWHyGucQTHe+3glQxhByc1q3DaaGJ+BYu0I+4bX61hkDPaBhwBoZ4CtbQ9EaYZ47s/HlH3rKi6BN90zaoO3TDAZh+hUXSCalmCDuDq7xmPcD5F/JyOm/aelGsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719111; c=relaxed/simple;
	bh=PVQg+fs/4+DlW1z2obvLwNILldqyxVuYVImAWrbxN0k=;
	h=Date:To:From:Subject:Message-Id; b=Nua/umoIi9c56PIxYZ553uHiS/6hcKA1RLwNOAZ+UyOhsZvlqJJIrD/EA4omcWLp3OMU+JGmlyfZUFzXZkjcXssegb+WXRDQT3jhJ2zSe78drjW9X/d6quMhoASvErmI0g/c0pFG7VAuiOW2gxrsK8rlzsJ6wOoRbehnyVClOVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4KaIRjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4KaIRjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17FFC19425;
	Thu, 14 May 2026 00:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719110;
	bh=PVQg+fs/4+DlW1z2obvLwNILldqyxVuYVImAWrbxN0k=;
	h=Date:To:From:Subject:From;
	b=N4KaIRjx5eO5ogSUimNbMTnDmmUiP3jVzhrQ+gPIlbSX1aVrcZC37/pN6p0a8zi9Z
	 PaHJLRrfIfgi9BBhJ/0is9DezEak35Dd1xukqzOV3aW2KCuL4lCAQLjum6bhRApuL4
	 P3Po3xu68Krd88CeENo2Vnz/5KgPEHWmiosMSolI=
Date: Wed, 13 May 2026 17:38:30 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch removed from -mm tree
Message-Id: <20260514003830.A17FFC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch

This patch was dropped because it was folded into mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix
Date: Thu Apr 23 07:18:38 AM PDT 2026

s/__GPF_ZERO/__GFP_ZERO/, per David

Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp_types.h~mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix
+++ a/include/linux/gfp_types.h
@@ -274,7 +274,7 @@ enum {
  * %__GFP_ZERO returns a zeroed page on success.
  *
  * %__GFP_ZEROTAGS zeroes memory tags at allocation time. Setting memory tags at
- * the same time as zeroing memory (e.g., with __GPF_ZERO) has minimal
+ * the same time as zeroing memory (e.g., with __GFP_ZERO) has minimal
  * additional performance impact. However, __GFP_ZEROTAGS also zeroes the tags
  * even if memory is not getting zeroed at allocation time (e.g.,
  * with init_on_free).
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix.patch
proc-rewrite-next_tgid-fix.patch

