Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B843421D5B0
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786497569; cv=none; b=ncxCMqgiLhlOrwKl5YjV85V8CW/r0lxslkeNAtK989tgglkf4vohG48p0xoPk8GZlc0gw/mchSR2cgsWZyYfhtTky1+MqsGW/lK15NiE7nF3iLT6YXedVkoflYUY/SSuiXnDV/FTG8bGio9y4cICjEJcQrzyvPOsgFwgkAghmzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786497569; c=relaxed/simple;
	bh=2gIv/Z74aX9WL2/qXNsbK3K7CLmDmI7awy5j1RaCfdQ=;
	h=Date:To:From:Subject:Message-Id; b=KXqxfAetr+cyrXf52H/bTbNtnfDAuFbM4sNaCz8TU36yEaUxkDZYI+PxP5yG7+AXvmxlBnBCZfrwaovzT5elRVRNAaNAvsWd5Cmc4bDMa3G0S2vMarKA/jdrOOwY1HoLoCkUATy8+PCjKTAPefVzUQpLMfuTSuLsaCxoipaftaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yohy229t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yohy229t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412631F000E9;
	Wed, 12 Aug 2026 01:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786497568;
	bh=YDNPFdf9lM+aICpNW23W8cBoQqdz2mHaaZFAru2tozc=;
	h=Date:To:From:Subject;
	b=Yohy229tqT78Rl1asdeSj22CY6/tw2LttaleUm94lSw4dzQYGBl9jyy3rmQlFQFKs
	 Ug4nUCiB9L0h/PXyKTV9j5/p7j61PjtHLEtcsTmOMhgs8O0V8c8ML7nOYs51fMI5TD
	 eYwGqFX0GyEltGnQkWglfTpN+v7mAlsJx4vU5ZCc=
Date: Tue, 11 Aug 2026 18:19:27 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch added to mm-unstable branch
Message-Id: <20260812011928.412631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
Date: Tue Aug 11 06:18:29 PM PDT 2026

fix kerneldoc

Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/e7911812-9b99-4f94-be6b-597bf202ffeb@infradead.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix
+++ a/include/linux/mm.h
@@ -2319,7 +2319,7 @@ static inline bool vma_flags_is_cow_mapp
 
 /**
  * vma_is_cow_mapping() - Is this VMA a CoW mapping?
- * @desc: The VMA to check.
+ * @vma: The VMA to check.
  *
  * See vma_flags_is_cow_mapping() for details.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping-fix-fix.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

