Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EE41EA7EC
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891922; cv=none; b=HY/a1sl3cjt8xsrL0Vj3oFumXcmEs24y7/yrdePBrBgBb1saGD85f4NGS2LLRJAmtqQoVVArIzgOAUzWKXoLukx8cl1kMFmJQyBhdcGsZvwVFV+4BtpXfCkAeyYh0ehGgBI6r0eJTYZwdYAi4nKGK5WptwCBMuRQgcJF3qbc9mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891922; c=relaxed/simple;
	bh=n9urXCG1+/khssyDJhJ6RVBq3saiOIkik9UlBUzajtg=;
	h=Date:To:From:Subject:Message-Id; b=S5fFVPjBMzgU+W+k8ujU2zEjvNM1lAU+k5oDfTOya004YIq7BJzqZGVFsOVnJd2YDIi3hXlu1GuVAJWXRlzLK2eoGuJuhZPe4Zazkwgylk9phuB648TKGa49uewcAuHiX/Lk0PWJmFC99EFOCXVQDZRTTdacYgoXJsAOBdJJ72w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CttNbB3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CttNbB3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F356C4CEEA;
	Wed, 25 Jun 2025 22:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750891922;
	bh=n9urXCG1+/khssyDJhJ6RVBq3saiOIkik9UlBUzajtg=;
	h=Date:To:From:Subject:From;
	b=CttNbB3XXy709f9KCYVeKUjkdZbNnW+pjAfXx5CQ/D0eIux0XyxLijqQbkqhYewbB
	 dPs94gPvTdOUP/vnydqrf4zdbq5e0E42zplJhFr758UnbAvXyC3WhJfwff04FNyB7Y
	 FFmdRzgQW4+OLX12Yjz6vzft6dFTUmFyJtPvKwKY=
Date: Wed, 25 Jun 2025 15:52:01 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,catalin.marinas@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3.patch removed from -mm tree
Message-Id: <20250625225202.1F356C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3
has been removed from the -mm tree.  Its filename was
     mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters-v3.patch

This patch was dropped because it was folded into mm-alloc_tag-fix-the-kmemleak-false-positive-issue-in-the-allocation-of-the-percpu-variable-tag-counters.patch

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
mm-percpu-conditionally-define-_shared_alloc_tag-via-config_arch_module_needs_weak_per_cpu.patch

