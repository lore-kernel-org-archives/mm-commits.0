Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B68C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5306192B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhGFTWH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhGFTWH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E07E661C7A;
        Tue,  6 Jul 2021 19:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599168;
        bh=S+f3hkVExfYewkxhs+toqYKFoTUPFlUgLv8/TnYMjXg=;
        h=Date:From:To:Subject:From;
        b=gXR4NbHXT86aApAg78YfQ9V4y88q8lZATZq6GutfS/6wU/2UPhvj/M/57IGm7aw7g
         mFvoE8U0HZhiebPmofpwWhsR55Zb41Wxyb4wG46vD7GPAOmWl24svJtPQf/y7Lkx0Y
         mY3Gu+vnMigQaW4Uf9I+fVIv861h2baWTe2rz9g8=
Date:   Tue, 06 Jul 2021 12:19:27 -0700
From:   akpm@linux-foundation.org
To:     cfijalkovich@google.com, hridya@google.com, hughd@google.com,
        kaleshsingh@google.com, mm-commits@vger.kernel.org,
        song@kernel.org, surenb@google.com, timmurray@google.com,
        viro@zeniv.linux.org.uk, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [merged]
 mm-thp-relax-the-vm_denywrite-constraint-on-file-backed-thps.patch removed
 from -mm tree
Message-ID: <20210706191927.fZsXWEn-k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs
has been removed from the -mm tree.  Its filename was
     mm-thp-relax-the-vm_denywrite-constraint-on-file-backed-thps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Collin Fijalkovich <cfijalkovich@google.com>
Subject: mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs

Transparent huge pages are supported for read-only non-shmem files, but
are only used for vmas with VM_DENYWRITE.  This condition ensures that
file THPs are protected from writes while an application is running
(ETXTBSY).  Any existing file THPs are then dropped from the page cache
when a file is opened for write in do_dentry_open().  Since sys_mmap
ignores MAP_DENYWRITE, this constrains the use of file THPs to vmas
produced by execve().

Systems that make heavy use of shared libraries (e.g.  Android) are unable
to apply VM_DENYWRITE through the dynamic linker, preventing them from
benefiting from the resultant reduced contention on the TLB.

This patch reduces the constraint on file THPs allowing use with any
executable mapping from a file not opened for write (see
inode_is_open_for_write()).  It also introduces additional conditions to
ensure that files opened for write will never be backed by file THPs.

Restricting the use of THPs to executable mappings eliminates the risk
that a read-only file later opened for write would encounter significant
latencies due to page cache truncation.

The ld linker flag '-z max-page-size=(hugepage size)' can be used to
produce executables with the necessary layout.  The dynamic linker must
map these file's segments at a hugepage size aligned vma for the mapping
to be backed with THPs.

Comparison of the performance characteristics of 4KB and 2MB-backed
libraries follows; the Android dex2oat tool was used to AOT compile an
example application on a single ARM core.

4KB Pages:
==========

count              event_name            # count / runtime
598,995,035,942    cpu-cycles            # 1.800861 GHz
 81,195,620,851    raw-stall-frontend    # 244.112 M/sec
347,754,466,597    iTLB-loads            # 1.046 G/sec
  2,970,248,900    iTLB-load-misses      # 0.854122% miss rate

Total test time: 332.854998 seconds.

2MB Pages:
==========

count              event_name            # count / runtime
592,872,663,047    cpu-cycles            # 1.800358 GHz
 76,485,624,143    raw-stall-frontend    # 232.261 M/sec
350,478,413,710    iTLB-loads            # 1.064 G/sec
    803,233,322    iTLB-load-misses      # 0.229182% miss rate

Total test time: 329.826087 seconds

A check of /proc/$(pidof dex2oat64)/smaps shows THPs in use:

/apex/com.android.art/lib64/libart.so
FilePmdMapped:      4096 kB

/apex/com.android.art/lib64/libart-compiler.so
FilePmdMapped:      2048 kB

Link: https://lkml.kernel.org/r/20210406000930.3455850-1-cfijalkovich@google.com
Signed-off-by: Collin Fijalkovich <cfijalkovich@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Song Liu <song@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c       |   13 +++++++++++--
 mm/khugepaged.c |   16 +++++++++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

--- a/fs/open.c~mm-thp-relax-the-vm_denywrite-constraint-on-file-backed-thps
+++ a/fs/open.c
@@ -852,8 +852,17 @@ static int do_dentry_open(struct file *f
 	 * XXX: Huge page cache doesn't support writing yet. Drop all page
 	 * cache for this file before processing writes.
 	 */
-	if ((f->f_mode & FMODE_WRITE) && filemap_nr_thps(inode->i_mapping))
-		truncate_pagecache(inode, 0);
+	if (f->f_mode & FMODE_WRITE) {
+		/*
+		 * Paired with smp_mb() in collapse_file() to ensure nr_thps
+		 * is up to date and the update to i_writecount by
+		 * get_write_access() is visible. Ensures subsequent insertion
+		 * of THPs into the page cache will fail.
+		 */
+		smp_mb();
+		if (filemap_nr_thps(inode->i_mapping))
+			truncate_pagecache(inode, 0);
+	}
 
 	return 0;
 
--- a/mm/khugepaged.c~mm-thp-relax-the-vm_denywrite-constraint-on-file-backed-thps
+++ a/mm/khugepaged.c
@@ -457,7 +457,8 @@ static bool hugepage_vma_check(struct vm
 
 	/* Read-only file mappings need to be aligned for THP to work. */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
-	    (vm_flags & VM_DENYWRITE)) {
+	    !inode_is_open_for_write(vma->vm_file->f_inode) &&
+	    (vm_flags & VM_EXEC)) {
 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
 				HPAGE_PMD_NR);
 	}
@@ -1862,6 +1863,19 @@ out_unlock:
 	else {
 		__mod_lruvec_page_state(new_page, NR_FILE_THPS, nr);
 		filemap_nr_thps_inc(mapping);
+		/*
+		 * Paired with smp_mb() in do_dentry_open() to ensure
+		 * i_writecount is up to date and the update to nr_thps is
+		 * visible. Ensures the page cache will be truncated if the
+		 * file is opened writable.
+		 */
+		smp_mb();
+		if (inode_is_open_for_write(mapping->host)) {
+			result = SCAN_FAIL;
+			__mod_lruvec_page_state(new_page, NR_FILE_THPS, -nr);
+			filemap_nr_thps_dec(mapping);
+			goto xa_locked;
+		}
 	}
 
 	if (nr_none) {
_

Patches currently in -mm which might be from cfijalkovich@google.com are


