Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6375F2836A
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720732124; cv=none; b=IF6jLnmgabp3g3Fd1E8lIrocluitiTT8J714gw2/NPD0/FrtvcyqEioZoPMROGnPPGY9vOJaiYWtm2xqTdugXmaUu2k+ds7BKioyKt4B7fVRYQAy5Zz3FQH8Xi25cCR29xUZLz1RZP27aBiTLqgira0cdVgzj39+tJP2jGgfXek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720732124; c=relaxed/simple;
	bh=Lpa+Y/j2OkYNirUv13PfkGtnVDcICA6UR9fWvVSaaCw=;
	h=Date:To:From:Subject:Message-Id; b=AIneBaQzzkgCztv/aD5jAAT7kISJQX3Q7BOXPNbSVjbQe7venKO/2sY0B7M9vZVaQ+Y5odlhTmZQbCtObXwl45RD5NgJ4lxdSWjWssA/Bi7AZHugyEVQqb7Fr1qDJSsAXJCjtfAK0dI7P0IDqprV6DeiCdq0fl9gzsvULJtr3to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q3h+Jxrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q3h+Jxrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BFAC116B1;
	Thu, 11 Jul 2024 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720732124;
	bh=Lpa+Y/j2OkYNirUv13PfkGtnVDcICA6UR9fWvVSaaCw=;
	h=Date:To:From:Subject:From;
	b=Q3h+JxrdGTuEzCBDI2h+KnL5dYDwzmiKOAs07XUTUuvTOuRFeRwIiMe0aUSr4wx18
	 ysWd3tykssID21vbssGvZzoEH8UHjsPu6wX9oautCQCFaaGT8xsfSjPjyPgH6AQ5+K
	 4EGupAlCPWO6CWjGLnH4F/S/IzupTeOYANz2dvlE=
Date: Thu, 11 Jul 2024 14:08:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch added to mm-hotfixes-unstable branch
Message-Id: <20240711210844.27BFAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: export memory allocation profiling symbols used by modules
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: export memory allocation profiling symbols used by modules
Date: Thu, 11 Jul 2024 13:46:26 -0700

Export mem_alloc_profiling_key, page_ext_get() and page_ext_set() symbols
as they can be used by modules (mem_alloc_profiling_key is used indirectly
via mem_alloc_profiling_enabled()).

Link: https://lkml.kernel.org/r/20240711204626.1669138-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407080044.DWMC9N9I-lkp@intel.com/
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    1 +
 mm/page_ext.c   |    2 ++
 2 files changed, 3 insertions(+)

--- a/lib/alloc_tag.c~alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules
+++ a/lib/alloc_tag.c
@@ -15,6 +15,7 @@ EXPORT_SYMBOL(_shared_alloc_tag);
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
+EXPORT_SYMBOL(mem_alloc_profiling_key);
 
 struct allocinfo_private {
 	struct codetag_iterator iter;
--- a/mm/page_ext.c~alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules
+++ a/mm/page_ext.c
@@ -527,6 +527,7 @@ struct page_ext *page_ext_get(const stru
 
 	return page_ext;
 }
+EXPORT_SYMBOL(page_ext_get);
 
 /**
  * page_ext_put() - Working with page extended information is done.
@@ -545,3 +546,4 @@ void page_ext_put(struct page_ext *page_
 
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL(page_ext_put);
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch

