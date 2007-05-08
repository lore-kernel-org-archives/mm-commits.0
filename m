From: akpm@linux-foundation.org
Subject: - readahead-call-scheme-doc-fixes-for-readahead.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:13 -0700
Message-ID: <200705080815.l488FDwl019037@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934656AbXEHISe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     doc. fixes for readahead
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme-doc-fixes-for-readahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: doc. fixes for readahead
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mm/readahead.c & filemap.c kernel-doc warnings (goes with readahead
patch when it's submitted).

Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'mapping'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'ra'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'filp'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'offset'
Warning(/tester/linsrc/linux-2621-rc7mm2//mm/readahead.c:1633): No description found for parameter 'req_size'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~readahead-call-scheme-doc-fixes-for-readahead mm/filemap.c
diff -puN mm/readahead.c~readahead-call-scheme-doc-fixes-for-readahead mm/readahead.c
--- a/mm/readahead.c~readahead-call-scheme-doc-fixes-for-readahead
+++ a/mm/readahead.c
@@ -1584,8 +1584,13 @@ thrashing_recovery_readahead(struct addr
 
 /**
  * page_cache_readahead_adaptive - thrashing safe adaptive read-ahead
- * @mapping, @ra, @filp, @offset, @req_size: the same as page_cache_readahead()
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @filp: passed on to ->readpage() and ->readpages()
  * @page: the page at @offset, or NULL if non-present
+ * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            PAGE_CACHE_SIZE units
  *
  * page_cache_readahead_adaptive() is the entry point of the adaptive
  * read-ahead logic. It tries a set of methods in turn to determine the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
parport_serial-fix-pci-must_checks.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
introduce-a-handy-list_first_entry-macro-v2.patch
consolidate-asm-consth-to-linux-consth.patch
x86_64-kill-19000-sparse-warnings.patch
move-log_buf_shift-to-a-more-sensible-place.patch
doc-fix-oops-tracing-duplicate.patch
docbook-librs-typo-fixes.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
git-r8169.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
profile-likely-unlikely-macros.patch
