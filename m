Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA4D253F2D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092871; cv=none; b=ilzpl5yQxCQZ3jV4CHDn1sff4nIEdCeuqcMcE9CrojgFd6IkZ5M33NNFJPTWCWVd0Wh3VAfeN7RyWIU7S61UHrdPHlSZIBvslY47auqRhiKQ2gkin8J2paIAjOxEU37VYZh001XIXN2YF4V6YT1Zq9HeSWcJc5RHamyfU8h2jdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092871; c=relaxed/simple;
	bh=CkWLybvmdf1nvSicfOZCRBLreTqWTiiC3EU8d1LXUZk=;
	h=Date:To:From:Subject:Message-Id; b=lwfellNktV5G1OFkBM2CcgIOex2ZNVGj1MpPKdFjBT7TBg+GbVbA0aZsmQeqYK+xO9G/jonplk2+0ETsgukMvce+LOUHhe6Z2OERnxQUaxDCrDDFs3k92Pgm+6a2fspqaaFspeCOUHJ0bJsWYCmQ01xYMycuUu5BLbRY50t2zG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UPgSoCZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UPgSoCZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA59C4CEE7;
	Mon, 12 May 2025 23:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092871;
	bh=CkWLybvmdf1nvSicfOZCRBLreTqWTiiC3EU8d1LXUZk=;
	h=Date:To:From:Subject:From;
	b=UPgSoCZhMM1IciAQGeK+7ZtAtp3oXy9bM1VhSkGlPjz6nrlJYO+H1lI3X4cIKhJqq
	 Ci03WEUFJQKc1LgCByaIfBBg0l5GDad9hJ6+t/ItyOlaXZ7Rog+PMS1IBAuNShxQvD
	 vYRCT7qnvSIkynMeLNgSXMjuFPAaj1UCh6fx82KA=
Date: Mon, 12 May 2025 16:34:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-vm_pat.patch added to mm-new branch
Message-Id: <20250512233431.1EA59C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove VM_PAT
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-vm_pat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-vm_pat.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove VM_PAT
Date: Mon, 12 May 2025 14:34:19 +0200

It's unused, so let's remove it.

Link: https://lkml.kernel.org/r/20250512123424.637989-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org> # x86 bits
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h             |    4 +---
 include/trace/events/mmflags.h |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

--- a/include/linux/mm.h~mm-remove-vm_pat
+++ a/include/linux/mm.h
@@ -357,9 +357,7 @@ extern unsigned int kobjsize(const void
 # define VM_SHADOW_STACK	VM_NONE
 #endif
 
-#if defined(CONFIG_X86)
-# define VM_PAT		VM_ARCH_1	/* PAT reserves whole VMA at once (x86) */
-#elif defined(CONFIG_PPC64)
+#if defined(CONFIG_PPC64)
 # define VM_SAO		VM_ARCH_1	/* Strong Access Ordering (powerpc) */
 #elif defined(CONFIG_PARISC)
 # define VM_GROWSUP	VM_ARCH_1
--- a/include/trace/events/mmflags.h~mm-remove-vm_pat
+++ a/include/trace/events/mmflags.h
@@ -172,9 +172,7 @@ IF_HAVE_PG_ARCH_3(arch_3)
 	__def_pageflag_names						\
 	) : "none"
 
-#if defined(CONFIG_X86)
-#define __VM_ARCH_SPECIFIC_1 {VM_PAT,     "pat"           }
-#elif defined(CONFIG_PPC64)
+#if defined(CONFIG_PPC64)
 #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC)
 #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch
x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch
mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch
mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch
mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch
x86-mm-pat-remove-old-pfnmap-tracking-interface.patch
mm-remove-vm_pat.patch
x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch
x86-mm-pat-remove-memtype__match.patch
x86-mm-pat-inline-memtype_match-into-memtype_erase.patch
drm-i915-track_pfn-pfnmap-tracking.patch
mm-io-mapping-track_pfn-pfnmap-tracking.patch

