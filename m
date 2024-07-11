Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6621116E876
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 19:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720726551; cv=none; b=f6ORuOCA6YzIsSuwAl8IyVj/9UNp1rFPGnwc835GlFwih5lkV7ASlO5dq2p4SzeNWQHKPxgpD0zpfp3enzAdQds91TkQ4ruORfHk+rSEhfwQ3+2hL0bPu8UMdVoLIC+eV7F9/OGqYCP3vMU4Ns/Kj3Zuq2QW6Bb5l5MfPdb4NSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720726551; c=relaxed/simple;
	bh=NtyXR/MVY29twhaGPq2n0qRFjoTrShMgnpq/yuVYiF8=;
	h=Date:To:From:Subject:Message-Id; b=LrAnNbVTj7MQuzm+LTnBQBHrFY3uNOxN+pwXlWCPh2FGglKX1eEEXnaiVRktzFYAUtco6tlxkt+r73/RxQi0HfW/RwLUiCseLT63c2uuZumnKElEWKJ3mEg4Xxj5HnAxW1XBcJ3pAZ1YDBmIsv+aa8b+hEy6mX+ZCtpbz8m4S/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lAxDu+pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lAxDu+pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDC9C116B1;
	Thu, 11 Jul 2024 19:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720726550;
	bh=NtyXR/MVY29twhaGPq2n0qRFjoTrShMgnpq/yuVYiF8=;
	h=Date:To:From:Subject:From;
	b=lAxDu+pgIZIAg+F0O3A4Ulvbm9d1Sg8YdsKVlPJUQisU32CWE4AqOLR8VI24ttwYW
	 wIIZhwjcN5cjjIoH4Oys3E1MDJYJm+N1KADcJynTXvqWppdGYf3QECK8LHMick0sPC
	 et4oeuoKDPpP1OnbbG0Azt0YeOk2Fg+ExUV17Y0Y=
Date: Thu, 11 Jul 2024 12:35:50 -0700
To: mm-commits@vger.kernel.org,yonghong.song@linux.dev,song@kernel.org,sdf@fomichev.me,roman.gushchin@linux.dev,rientjes@google.com,mjguzik@gmail.com,martin.lau@linux.dev,kpsingh@kernel.org,jolsa@kernel.org,john.fastabend@gmail.com,haoluo@google.com,eddyz87@gmail.com,daniel@iogearbox.net,cl@linux.com,ast@kernel.org,andrii@kernel.org,akinobu.mita@gmail.com,42.hyeyoo@gmail.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc.patch added to mm-unstable branch
Message-Id: <20240711193550.BCDC9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, page_alloc: put should_fail_alloc_page() back behing CONFIG_FAIL_PAGE_ALLOC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: put should_fail_alloc_page() back behing CONFIG_FAIL_PAGE_ALLOC
Date: Thu, 11 Jul 2024 18:35:31 +0200

This mostly reverts commit af3b854492f3 ("mm/page_alloc.c: allow error
injection").  The commit made should_fail_alloc_page() a noinline function
that's always called from the page allocation hotpath, even if it's empty
because CONFIG_FAIL_PAGE_ALLOC is not enabled, and there is no option to
disable it and prevent the associated function call overhead.

As with the preceding patch "mm, slab: put should_failslab back behind
CONFIG_SHOULD_FAILSLAB" and for the same reasons, put the
should_fail_alloc_page() back behind the config option.  When enabled, the
ALLOW_ERROR_INJECTION and BTF_ID records are preserved so it's not a
complete revert.

Link: https://lkml.kernel.org/r/20240711-b4-fault-injection-reverts-v1-2-9e2651945d68@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    6 ++----
 kernel/bpf/verifier.c        |    2 ++
 mm/fail_page_alloc.c         |    4 +++-
 mm/page_alloc.c              |    6 ------
 4 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/fault-inject.h~mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc
+++ a/include/linux/fault-inject.h
@@ -91,12 +91,10 @@ static inline void fault_config_init(str
 
 struct kmem_cache;
 
-bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
-
 #ifdef CONFIG_FAIL_PAGE_ALLOC
-bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
+bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
 #else
-static inline bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+static inline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return false;
 }
--- a/kernel/bpf/verifier.c~mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc
+++ a/kernel/bpf/verifier.c
@@ -21122,7 +21122,9 @@ BTF_SET_START(btf_non_sleepable_error_in
  * Assume non-sleepable from bpf safety point of view.
  */
 BTF_ID(func, __filemap_add_folio)
+#ifdef CONFIG_FAIL_PAGE_ALLOC
 BTF_ID(func, should_fail_alloc_page)
+#endif
 #ifdef CONFIG_FAILSLAB
 BTF_ID(func, should_failslab)
 #endif
--- a/mm/fail_page_alloc.c~mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc
+++ a/mm/fail_page_alloc.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fault-inject.h>
+#include <linux/error-injection.h>
 #include <linux/mm.h>
 
 static struct {
@@ -21,7 +22,7 @@ static int __init setup_fail_page_alloc(
 }
 __setup("fail_page_alloc=", setup_fail_page_alloc);
 
-bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	int flags = 0;
 
@@ -41,6 +42,7 @@ bool __should_fail_alloc_page(gfp_t gfp_
 
 	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
 }
+ALLOW_ERROR_INJECTION(should_fail_alloc_page, TRUE);
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
--- a/mm/page_alloc.c~mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc
+++ a/mm/page_alloc.c
@@ -3050,12 +3050,6 @@ out:
 	return page;
 }
 
-noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
-{
-	return __should_fail_alloc_page(gfp_mask, order);
-}
-ALLOW_ERROR_INJECTION(should_fail_alloc_page, TRUE);
-
 static inline long __zone_watermark_unusable_free(struct zone *z,
 				unsigned int order, unsigned int alloc_flags)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slab-put-should_failslab-back-behind-config_should_failslab.patch
mm-page_alloc-put-should_fail_alloc_page-back-behing-config_fail_page_alloc.patch

