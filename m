Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522BC547066
	for <mm-commits@vger.kernel.org>; Thu,  8 Oct 2026 00:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791418135; cv=none; b=C+whd74XY8/iv+/crx6n9+gMAYxDXz+PRwnnUgIAtyB3y9KcvOmKyWgDYC3lR9j7ThIpITAjwKIp/32gyaSc3Ez08sD82PSDyhr25eVm+A7V8r0MxFGZVki/PkhPBL4yeLwpbT3KpVUoMJQshWAvwgncE8XFlEJbhQgzZcaJcG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791418135; c=relaxed/simple;
	bh=dyC0eyfz+zwGNEVUhdDrxu5w1Oj3oY379v8JNDL4k68=;
	h=Date:To:From:Subject:Message-Id; b=afR6roVMaV91Le35oPRJcoU18Y8qEhTtA1dj3l5RPGEMt9NFAp9QxR2wPVGRzM2+VRoe/8iSOmohMb5+5X1gHzqYP7yECDExfJ/T4P5zCdtBRgz/IKfS0XnPVyD78oq8C73h3OXIio0TxRdWuSUE11k6u61TTdNCg/8ITlQo0ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tjh42gAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tjh42gAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD8C1F000FF;
	Thu,  8 Oct 2026 00:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791418134;
	bh=tQ9Z1a0wIe9TioQCqrzAuTJJgiEb+kekwbPu3pLfCD8=;
	h=Date:To:From:Subject;
	b=tjh42gAHFilHIpPQ7+7LpnkTXK7VYFLSBzvmTpx86A/YU9a2xmMwV02fvVhoC9uTj
	 tu9MpTX2yk3D/c6u+B57fPEV1WzvJisp5YaT2ux2yrfo2ja+WX1wfGukJE9eJSz08L
	 0je0FFg0JkF76l5uBGdWPz278X6PhgRN5TmkkZ0Y=
Date: Wed, 07 Oct 2026 17:08:53 -0700
To: mm-commits@vger.kernel.org,lzsx618@gmail.com,armaan.sandhu0504@gmail.com,andriy.shevchenko@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261008000853.DAD8C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix
Date: Wed Oct  7 05:06:09 PM PDT 2026

add additional test case from Leizhen

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Armaan Sandhu <armaan.sandhu0504@gmail.com>
Cc: Leizhen Zhang <lzsx618@gmail.com>
---

 lib/tests/cmdline_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/tests/cmdline_kunit.c~lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix
+++ a/lib/tests/cmdline_kunit.c
@@ -151,6 +151,7 @@ static const struct {
 	{ "0-2147483647",  { 3, 0, 1, 2, },    0,          },
 	{ "-5-2147483647", { 3, -5, -4, -3, }, 0,          },
 	{ "2147483647--5", { 0, 2147483647, }, 0,          },
+	{ "1,0-2147483647", { 3, 1, 0, 1, },   1, },
 };
 
 static void cmdline_test_range_overflow(struct kunit *test)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

