Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CD51AAD3
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711480683; cv=none; b=N4j0DiTaQg3sTaB1E/YLMbicz0D3jsNDNarwljBeQzpO0wJwD2vpS0vATa9qUdbRDkYwDGtUJDqCZuctJruZtqoIOOJTsrE59F84FskWIowBD43VK9ngDVISXxizwZ6KiCJ1n8GuKWleu/4OK/2KEbQxoxbJfJznUB+49K1+H78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711480683; c=relaxed/simple;
	bh=jHccy49Od5fYLmrI8xWnepBzbbpZ1WHKRIJNbBNLoIM=;
	h=Date:To:From:Subject:Message-Id; b=HaERJ3l7tXpfreRI8Hi9Qud5506aZvGzGW5el7HXO0SRlxqSsbnDPaiEG6OtBQCW3IU/MylEFB/dhrzob8BxXP/n3mQSp+WEYEEVwLR9tl/JK37RTAoeRaMLRhxDxatEnR4p+YSKMdWNAI+6i7V4+rtrpiW2WaCPDez9GyVGBA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ch7dhao/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ch7dhao/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64C8C433C7;
	Tue, 26 Mar 2024 19:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711480682;
	bh=jHccy49Od5fYLmrI8xWnepBzbbpZ1WHKRIJNbBNLoIM=;
	h=Date:To:From:Subject:From;
	b=ch7dhao/V7L7qa/qs6DGvJKofgGKq/b60NrJvugSVEUdVP0WSaPKer7mkuNvR4Z4m
	 yYRkE4LnbtVOKdi3tu90t2lbZPYp+fflY4atlZfhIb0zZkI5JYPAjHSxthuqMxPm/e
	 xWP4/uoJ3QtcclA5qq1MBRtlH+regcyIA0VWXTmE=
Date: Tue, 26 Mar 2024 12:18:02 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rdunlap@infradead.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch added to mm-unstable branch
Message-Id: <20240326191802.C64C8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: fs/proc: fix allocinfo title
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: Documentation: fs/proc: fix allocinfo title
Date: Tue, 26 Mar 2024 00:38:13 -0700

Fix "Title underline too short." warning in the documentation.

Link: https://lkml.kernel.org/r/20240326073813.727090-1-surenb@google.com
Fixes: d08b311b6d49 ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix
+++ a/Documentation/filesystems/proc.rst
@@ -955,7 +955,7 @@ reclaimed to achieve this.
 
 
 allocinfo
-~~~~~~~
+~~~~~~~~~
 
 Provides information about memory allocations at all locations in the code
 base. Each allocation in the code is identified by its source file, line
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

