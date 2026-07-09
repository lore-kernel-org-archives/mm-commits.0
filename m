Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70F26ACC
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783617295; cv=none; b=hla4OrYYEg5cX2ekI+RmoAZ2YFWMUW1vZfcGgc/wrLG/CzdTEGMiy7ySCvfC6YERXX0hMhimxYZewJdNMXzeU/9jkbTw5JmMnUg4KRAI6xsTRj3rOhM4n5rfuCr8+fbHQ4kVEeu9RLUAu8qJykAIyvMMFbsMI6Stt8tveJBWcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783617295; c=relaxed/simple;
	bh=sDPQKTnd2LiNVbRqJx98HYTb3s+NHSvrGxTcx5M5k4g=;
	h=Date:To:From:Subject:Message-Id; b=PIzI6wd7GWoBHL/X6BZ7DZ4WnEtQl6rQjQxVz7oD14dA6frB7HMuGELzDi7QyZ1XZyBcfin+OiZvPu9dEEtCQU6Qn+IDAmn74zpf8pRJW1h5gDz9vKzkObshZqNaiE3f/yAhvV2IkR+TQ84qCqnG9FnTYQzpyWORdd6Jg+VWoLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EdpvTHRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EdpvTHRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E851F000E9;
	Thu,  9 Jul 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783617294;
	bh=zhAMBGv+bZgr3QYOOnJMBi5gUaB3KqABay3esgqNHHU=;
	h=Date:To:From:Subject;
	b=EdpvTHRhoYQHpUR64F5r5fFFvAE+SwuAq6oRus4xM0qY8i5TNCbHAbYnW3luHM0Xz
	 /RMj5+57yJDfN9ClC5gJ9MFl7rSYTMFPnQKgqD1PZmjKje5H8KPofpN8chmDQJ25X3
	 dD8s5mOJUp1DaY6B0VYU10PCUXLQaBeC6D7Dh/9k=
Date: Thu, 09 Jul 2026 10:14:53 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch added to mm-new branch
Message-Id: <20260709171454.58E851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag-add-ioctl-to-proc-allocinfo-fix
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: alloc_tag-add-ioctl-to-proc-allocinfo-fix
Date: Thu Jul  9 10:13:24 AM PDT 2026

include compat.h, per Suren

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp@intel.com/
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/alloc_tag.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/alloc_tag.c~alloc_tag-add-ioctl-to-proc-allocinfo-fix
+++ a/mm/alloc_tag.c
@@ -6,6 +6,7 @@
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/compat.h>
 #include <linux/page_ext.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

