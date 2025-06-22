Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8313183CA6
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750631386; cv=none; b=HEoCdSRB7L/ZeFkJxcJ8w2mBPwzagYa8DaxUcVF/ByXjQS/iblESm3CEPxuroGjPMD4mze9Gp5jg9x0Akh8UlxqICbZH70JxtvVPqalLzblxxmOvkOFej5BVo311+RK6D4DZSHzO4yOT8mHdZosYVds5scsWlAz+h0SXpd4TR6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750631386; c=relaxed/simple;
	bh=Z/SkCTzgmcB6AGS0vO73AyoHzcXB12x4aBW9ByrlppI=;
	h=Date:To:From:Subject:Message-Id; b=iG81dISCilAEJL3AVW3hLXQAQCCivfQXq79QSp4dhf0GCMEKuNBJvasJ2vN2i+VElS+tjcry7mOgK8NKzNg4rY2Mja75+COEuyHq1kOyI6yzX9zUczteU5mUjesRyZNGJ4BNWUM4XMXUkznNIeibsQviDgtmRNb6+UolIMCY3wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vzZmnicO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vzZmnicO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F762C4CEE3;
	Sun, 22 Jun 2025 22:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750631386;
	bh=Z/SkCTzgmcB6AGS0vO73AyoHzcXB12x4aBW9ByrlppI=;
	h=Date:To:From:Subject:From;
	b=vzZmnicOvbMP8jNBGfysgVK5qyNKF4slBtvNQQbprYtGs05EUZ6n8vgznAJyHVFMb
	 SjP4SsY+GpKKvELYpLijcwq9NadHiDfBMrwqguJlw/IiS4AON/lXbqEv+16Jepnyoh
	 Z1rwm3lvDzTfmkZrDyLGFGpUM1N3nYuZzjqNzeGk=
Date: Sun, 22 Jun 2025 15:29:45 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,catalin.marinas@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622222946.3F762C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3
Date: Fri, 20 Jun 2025 17:31:02 +0800

fix build error when CONFIG_DEBUG_KMEMLEAK=n, s/igonore/ignore/

Link: https://lkml.kernel.org/r/20250620093102.2416767-1-hao.ge@linux.dev
Fixes: 12ca42c23775 ("alloc_tag: allocate percpu counters for module tags dynamically")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    5 ++++-
 lib/alloc_tag.c          |    2 +-
 mm/kmemleak.c            |    8 ++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

--- a/include/linux/kmemleak.h~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3
+++ a/include/linux/kmemleak.h
@@ -28,7 +28,7 @@ extern void kmemleak_update_trace(const
 extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_transient_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
-extern void kmemleak_igonore_percpu(const void __percpu *ptr) __ref;
+extern void kmemleak_ignore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
 extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
@@ -98,6 +98,9 @@ static inline void kmemleak_not_leak(con
 static inline void kmemleak_transient_leak(const void *ptr)
 {
 }
+static inline void kmemleak_ignore_percpu(const void __percpu *ptr)
+{
+}
 static inline void kmemleak_ignore(const void *ptr)
 {
 }
--- a/lib/alloc_tag.c~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3
+++ a/lib/alloc_tag.c
@@ -638,7 +638,7 @@ static int load_module(struct module *mo
 		 * Avoid a kmemleak false positive. The pointer to the counters is stored
 		 * in the alloc_tag section of the module and cannot be directly accessed.
 		 */
-		kmemleak_igonore_percpu(tag->counters);
+		kmemleak_ignore_percpu(tag->counters);
 	}
 	return 0;
 }
--- a/mm/kmemleak.c~mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3
+++ a/mm/kmemleak.c
@@ -1247,18 +1247,18 @@ void __ref kmemleak_transient_leak(const
 EXPORT_SYMBOL(kmemleak_transient_leak);
 
 /**
- * kmemleak_ignore_phys - similar to kmemleak_ignore but taking a percpu
- *			  address argument
+ * kmemleak_ignore_percpu - similar to kmemleak_ignore but taking a percpu
+ *			    address argument
  * @ptr:	percpu address of the object
  */
-void __ref kmemleak_igonore_percpu(const void __percpu *ptr)
+void __ref kmemleak_ignore_percpu(const void __percpu *ptr)
 {
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
 		make_black_object((unsigned long)ptr, OBJECT_PERCPU);
 }
-EXPORT_SYMBOL_GPL(kmemleak_igonore_percpu);
+EXPORT_SYMBOL_GPL(kmemleak_ignore_percpu);
 
 /**
  * kmemleak_ignore - ignore an allocated object
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch
mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3.patch
mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

