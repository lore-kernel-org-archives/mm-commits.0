Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178818EFF8
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 23:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578812; cv=none; b=t66hbQWCbnq7T8oRex0ROMEHEMTuTQfW4cdF/brwkBTVbI2aTi9Lbs7XSnSW7hvpHOeIPY87i7BvNz0KopnvpADG0Nlo+ormWlCTIqrts+M7VojYxEH/mR1Ba6ljt6rmCDlECcl2rB4F1W/I8cmH70Ap06mOcPwEmYQ1ngBTjzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578812; c=relaxed/simple;
	bh=6H+6yRPicAH+rtapW05c/Ne+oVMWFEcEXaLduNbpDgU=;
	h=Date:To:From:Subject:Message-Id; b=XZ3RWGpxD5R3s+9x00B9a/IbmP0XcX0sG+2A7meC6Sd1VnVqmhOc+ZkDtTsjuy77ujHbvvPlOPFVfeLpFFpkAl78G43nF8eTBhcl1EWIRhSptQH8UnnwEE3bFFwPwHPh2xS+MM04F8lQAlG+22ZkcHKWOHqMfXDSwkAC2AHAjeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xMCuX/YF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xMCuX/YF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0C0C4CEC3;
	Thu,  5 Sep 2024 23:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725578811;
	bh=6H+6yRPicAH+rtapW05c/Ne+oVMWFEcEXaLduNbpDgU=;
	h=Date:To:From:Subject:From;
	b=xMCuX/YFdT1nBcGz+avfffqeJE2eyGn4skYQDC5/HcXZrg3e/92va/OymPVsjNBdr
	 L/oN6fUZOjkaZsGh9mywfHVQ0yp4rp0kpbEUDle3vARo0F1/bXHM8Lk7BUDg87Qm2e
	 v+Ep8d9FSRwgIC3KnAcXzizLj6DbewMTNTmNhPtU=
Date: Thu, 05 Sep 2024 16:26:50 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,muchun.song@linux.dev,kent.overstreet@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-codetag-fix-a-typo.patch added to mm-unstable branch
Message-Id: <20240905232651.9D0C0C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/codetag: fix a typo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-codetag-fix-a-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-codetag-fix-a-typo.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/codetag: fix a typo
Date: Tue, 3 Sep 2024 15:36:47 -0600

Link: https://lkml.kernel.org/r/20240903213649.3566695-1-yuzhao@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~mm-codetag-fix-a-typo
+++ a/include/linux/alloc_tag.h
@@ -70,7 +70,7 @@ static inline struct alloc_tag *ct_to_al
 /*
  * When percpu variables are required to be defined as weak, static percpu
  * variables can't be used inside a function (see comments for DECLARE_PER_CPU_SECTION).
- * Instead we will accound all module allocations to a single counter.
+ * Instead we will account all module allocations to a single counter.
  */
 DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch
mm-codetag-fix-a-typo.patch
mm-codetag-fix-pgalloc_tag_split.patch
mm-codetag-add-pgalloc_tag_copy.patch

