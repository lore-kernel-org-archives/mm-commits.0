Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4611C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7363C61A27
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhCXX3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhCXX3M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A37DD619E8;
        Wed, 24 Mar 2021 23:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616628551;
        bh=l0CWAs/rp9vL2JkaaWvjzHlOpvPPcIsoaQf+yliR1hk=;
        h=Date:From:To:Subject:From;
        b=PMzij2NIk5StzWLsJewFObuHEH1C9jy1/kjHFUXDYP7oXm/jKzST1iBrnyyc3JISg
         Qoqfzns7BCG9qVc6lNHBuqRjbPLB9WVW3dI0TQpxumuyvtBDEfyn+0ww/CyPwrEXx2
         Y9M3ei43VZGut7GcRNroq7mhNmCaUYSOmJx6Am9k=
Date:   Wed, 24 Mar 2021 16:29:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        jhubbard@nvidia.com, corbet@lwn.net, willy@infradead.org
Subject:  + mm-doc-turn-fault-flags-into-an-enum.patch added to -mm
 tree
Message-ID: <20210324232911.ql67c%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/doc: turn fault flags into an enum
has been added to the -mm tree.  Its filename is
     mm-doc-turn-fault-flags-into-an-enum.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-doc-turn-fault-flags-into-an-enum.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-turn-fault-flags-into-an-enum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/doc: turn fault flags into an enum

The kernel-doc script complains about
./include/linux/mm.h:425: warning: wrong kernel-doc identifier on line:
 * Fault flag definitions.

I don't know how to document a series of #defines, so turn these
definitions into an enum and document that instead.

Link: https://lkml.kernel.org/r/20210322195022.2143603-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~mm-doc-turn-fault-flags-into-an-enum
+++ a/include/linux/mm.h
@@ -422,8 +422,7 @@ extern unsigned int kobjsize(const void
 extern pgprot_t protection_map[16];
 
 /**
- * Fault flag definitions.
- *
+ * enum fault_flag - Fault flag definitions.
  * @FAULT_FLAG_WRITE: Fault was a write fault.
  * @FAULT_FLAG_MKWRITE: Fault was mkwrite of existing PTE.
  * @FAULT_FLAG_ALLOW_RETRY: Allow to retry the fault if blocked.
@@ -454,16 +453,18 @@ extern pgprot_t protection_map[16];
  * signals before a retry to make sure the continuous page faults can still be
  * interrupted if necessary.
  */
-#define FAULT_FLAG_WRITE			0x01
-#define FAULT_FLAG_MKWRITE			0x02
-#define FAULT_FLAG_ALLOW_RETRY			0x04
-#define FAULT_FLAG_RETRY_NOWAIT			0x08
-#define FAULT_FLAG_KILLABLE			0x10
-#define FAULT_FLAG_TRIED			0x20
-#define FAULT_FLAG_USER				0x40
-#define FAULT_FLAG_REMOTE			0x80
-#define FAULT_FLAG_INSTRUCTION  		0x100
-#define FAULT_FLAG_INTERRUPTIBLE		0x200
+enum fault_flag {
+	FAULT_FLAG_WRITE =		1 << 0,
+	FAULT_FLAG_MKWRITE =		1 << 1,
+	FAULT_FLAG_ALLOW_RETRY =	1 << 2,
+	FAULT_FLAG_RETRY_NOWAIT = 	1 << 3,
+	FAULT_FLAG_KILLABLE =		1 << 4,
+	FAULT_FLAG_TRIED = 		1 << 5,
+	FAULT_FLAG_USER =		1 << 6,
+	FAULT_FLAG_REMOTE =		1 << 7,
+	FAULT_FLAG_INSTRUCTION =	1 << 8,
+	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
+};
 
 /*
  * The default fault flags that should be used by most of the
@@ -486,7 +487,7 @@ extern pgprot_t protection_map[16];
  * Return: true if the page fault allows retry and this is the first
  * attempt of the fault handling; false otherwise.
  */
-static inline bool fault_flag_allow_retry_first(unsigned int flags)
+static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 {
 	return (flags & FAULT_FLAG_ALLOW_RETRY) &&
 	    (!(flags & FAULT_FLAG_TRIED));
@@ -521,7 +522,7 @@ struct vm_fault {
 		pgoff_t pgoff;			/* Logical page offset based on vma */
 		unsigned long address;		/* Faulting virtual address */
 	};
-	unsigned int flags;		/* FAULT_FLAG_xxx flags
+	enum fault_flag flags;		/* FAULT_FLAG_xxx flags
 					 * XXX: should really be 'const' */
 	pmd_t *pmd;			/* Pointer to pmd entry matching
 					 * the 'address' */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-introduce-and-use-mapping_empty.patch
mm-stop-accounting-shadow-entries.patch
dax-account-dax-entries-as-nrpages.patch
mm-remove-nrexceptional-from-inode.patch
mm-move-page_mapping_file-to-pagemaph.patch
mm-doc-fix-fault_flag_allow_retry_first-kerneldoc.patch
mm-doc-fix-page_maybe_dma_pinned-kerneldoc.patch
mm-doc-turn-fault-flags-into-an-enum.patch
mm-doc-add-mmh-and-mm_typesh-to-the-mm-api-document.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch

