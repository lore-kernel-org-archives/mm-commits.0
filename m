From: akpm@linux-foundation.org
Subject: + page-types-introduce-kpageflags_flags.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:46:20 -0700
Message-ID: <200909292146.n8TLkKNJ013164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbZI2VqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, andi@firstfloor.org


The patch titled
     page-types: introduce kpageflags_flags()
has been added to the -mm tree.  Its filename is
     page-types-introduce-kpageflags_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: introduce kpageflags_flags()
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/page-types.c~page-types-introduce-kpageflags_flags Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-introduce-kpageflags_flags
+++ a/Documentation/vm/page-types.c
@@ -436,6 +436,16 @@ static uint64_t well_known_flags(uint64_
 	return flags;
 }
 
+static uint64_t kpageflags_flags(uint64_t flags)
+{
+	flags = expand_overloaded_flags(flags);
+
+	if (!opt_raw)
+		flags = well_known_flags(flags);
+
+	return flags;
+}
+
 /*
  * page frame walker
  */
@@ -470,10 +480,7 @@ static int hash_slot(uint64_t flags)
 static void add_page(unsigned long voffset,
 		     unsigned long offset, uint64_t flags)
 {
-	flags = expand_overloaded_flags(flags);
-
-	if (!opt_raw)
-		flags = well_known_flags(flags);
+	flags = kpageflags_flags(flags);
 
 	if (!bit_mask_ok(flags))
 		return;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
pagemap-export-kpf_hwpoison.patch
pagemap-document-kpf_ksm-and-show-it-in-page-types.patch
page-types-add-gpl-note.patch
page-types-introduce-checked_open.patch
page-types-make-standalone-pagemap-kpageflags-read-routines.patch
page-types-make-voffset-local-variables.patch
page-types-introduce-kpageflags_flags.patch
page-types-add-hwpoison-unpoison-feature.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

