Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199C033EE
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717793967; cv=none; b=RR0LF8v3jwKlZAVjZ6NKvULTRYCIrmn5SRwt/QzY6qmGFH55p8vGtvizF2cuKKxXqSTQebEGxZcJsat7S2ZTT8wtz3ECL7jQWGJnsKJUGeFaShtiuN8kVWv2wY5MjeJDr0OuThsD5EE2vnwHCnz6fK2X5akzioF2xTFVtIJc5ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717793967; c=relaxed/simple;
	bh=Gf0bFhBUCP0rDp7G9bcCxy2CNCS87kkWZb99gg4g2KM=;
	h=Date:To:From:Subject:Message-Id; b=gucANmrONWdzhIj3kyARBYHGFe7boEopCIXaDls0O9cXsCQH4fVoS5IR4haQkrHaCVLyUfdazSVTgzDezWSKDPhklAgcN8wdNeqN8ahOt86jV5yjA42tYncQblHvgpgyaQiKteoQjDMUR6BfETTvX7WSpt9iSbEz9lKIv/ae3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GakiHLOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GakiHLOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E141AC2BBFC;
	Fri,  7 Jun 2024 20:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717793967;
	bh=Gf0bFhBUCP0rDp7G9bcCxy2CNCS87kkWZb99gg4g2KM=;
	h=Date:To:From:Subject:From;
	b=GakiHLOrVXBxKl3fXCkRZGXMrWK+/ITum/J5AXObJAfkBGBP6WbucMe6ly23D+RUg
	 Z8z5vbvJ8Df3XQLqL/GZILc66U33RSSWmTh5DpqUcTdanWakSG3Zv/TIukjcnSzG8+
	 iIA8kKaq3YBaNVsfOP6NTjS7KlPMFhQ9jic5ux28=
Date: Fri, 07 Jun 2024 13:59:26 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch added to mm-unstable branch
Message-Id: <20240607205926.E141AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/admin-guide/mm/pagemap.rst: drop "Using pagemap to do something useful"
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: Documentation/admin-guide/mm/pagemap.rst: drop "Using pagemap to do something useful"
Date: Fri, 7 Jun 2024 14:23:57 +0200

That example was added in 2008.  In 2015, we restricted access to the PFNs
in the pagemap to CAP_SYS_ADMIN, making that approach quite less usable.

It's 2024 now, and using that racy and low-lewel mechanism to calculate
the USS should not be considered a good example anymore.  /proc/$pid/smaps
and /proc/$pid/smaps_rollup can do a much better job without any of that
low-level handling.

Let's just drop that example.

Link: https://lkml.kernel.org/r/20240607122357.115423-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -173,27 +173,6 @@ LRU related page flags
 The page-types tool in the tools/mm directory can be used to query the
 above flags.
 
-Using pagemap to do something useful
-====================================
-
-The general procedure for using pagemap to find out about a process' memory
-usage goes like this:
-
- 1. Read ``/proc/pid/maps`` to determine which parts of the memory space are
-    mapped to what.
- 2. Select the maps you are interested in -- all of them, or a particular
-    library, or the stack or the heap, etc.
- 3. Open ``/proc/pid/pagemap`` and seek to the pages you would like to examine.
- 4. Read a u64 for each page from pagemap.
- 5. Open ``/proc/kpagecount`` and/or ``/proc/kpageflags``.  For each PFN you
-    just read, seek to that entry in the file, and read the data you want.
-
-For example, to find the "unique set size" (USS), which is the amount of
-memory that a process is using that is not shared with any other process,
-you can go through every map in the process, find the PFNs, look those up
-in kpagecount, and tally up the number of pages that are only referenced
-once.
-
 Exceptions for Shared Memory
 ============================
 
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

