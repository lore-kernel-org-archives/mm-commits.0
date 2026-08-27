Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EE7282F29;
	Thu, 27 Aug 2026 03:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802145; cv=none; b=Gopb4XDjNuhpVXdgJZNYE+z7viTNXxT2ScXQg6+0erlhT7BbQ4Zz/lELyo0aRa68+syJYXo4dxIWuoIluzIQG4e0kWJ9mrDxHy7XAKGueuBLNc9ZMKLyLH9mN64u2JbDwHDfkVWkiqAyp6RADdXSEFBu+Y3ff6LOnIlVxBseDMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802145; c=relaxed/simple;
	bh=TnXg1gWFLDdcuQ4BKoHGN4O5gKFrn37nTCCicl2IZFY=;
	h=Date:To:From:Subject:Message-Id; b=HaQ1eBW/gJdtV8Ds4MksXmEGZYkH4GbhAAej2KG0bu/WUO8uiZPY6pYTuoL190v5VS95ZmohQvgfTqB6GfpfJ8iyDOVzUsoHyFIZocbcYidIsn3WPAoKV9tka8yodl/BcwhuA2H3EzYDaW2NQ5TODgTw4jwZOCONRjEUaWl5VW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tvKEz5wW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tvKEz5wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A811F000E9;
	Thu, 27 Aug 2026 03:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787802144;
	bh=hK72YDTO2q8/FTK5H+dTEAZMAhBQm0AQ87eEYgkh2f4=;
	h=Date:To:From:Subject;
	b=tvKEz5wWoWJtICKhlwB6Y5sSxfH59NiZIBNngAIHRnPXlPa+DcLqRM61Jk6fe4zma
	 bB30MPT9z4JIud4KN8gIxjpHDhZFBQDDclDIVxGtQu4eme9RDi9e5COjbO8kPr5VNP
	 xnKgIV47xNmJER302tLHjOkElBWZQFpilxxSCVqQ=
Date: Wed, 26 Aug 2026 20:42:23 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,kent.overstreet@linux.dev,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch added to mm-new branch
Message-Id: <20260827034224.27A811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: remove /proc/allocinfo outside of mod_lock
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

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
From: Hao Ge <hao.ge@linux.dev>
Subject: alloc_tag: remove /proc/allocinfo outside of mod_lock
Date: Mon, 17 Aug 2026 14:27:26 +0800

shutdown_mem_profiling() calls remove_proc_entry() from
reserve_module_tags(), which runs under mod_lock held for write. 
remove_proc_entry() waits for readers, and a reader takes mod_lock for
read in allocinfo_start():

  CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
  ----------------                   ----------------------------
  reserve_module_tags()
    down_write(&mod_lock)  [held]
                                     use_pde()            [in_use++]
                                     allocinfo_start()
                                       down_read(&mod_lock)  <- blocks
    shutdown_mem_profiling()
      remove_proc_entry()
        wait for in_use == 0         <- blocks

Move remove_proc_entry() to a workqueue.

Link: https://lore.kernel.org/20260817062726.106511-3-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/alloc_tag.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/alloc_tag.c~alloc_tag-remove-proc-allocinfo-outside-of-mod_lock
+++ a/mm/alloc_tag.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
@@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new,
 	put_page_tag_ref(handle_new);
 }
 
+static void remove_allocinfo_file(struct work_struct *work)
+{
+	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+}
+
+static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
+
 static void shutdown_mem_profiling(bool remove_file)
 {
 	if (mem_alloc_profiling_enabled())
@@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool
 		return;
 
 	if (remove_file)
-		remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
+		schedule_work(&remove_allocinfo_work);
 	mem_profiling_support = false;
 }
 
_

Patches currently in -mm which might be from hao.ge@linux.dev are

module-fix-lost-error-code-from-codetag_load_module.patch
alloc_tag-skip-percpu-counter-allocation-when-profiling-is-disabled.patch
alloc_tag-remove-proc-allocinfo-outside-of-mod_lock.patch

