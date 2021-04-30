Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4094C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75456147D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhD3GAT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhD3GAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B40396148E;
        Fri, 30 Apr 2021 05:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762372;
        bh=ukGCoCiRhyHZYdNW9ZvO/BO4uHLU+a7G8tNWgL76wrk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XB4cOHYtEuRCAhu9SPzEMq4c7khDaB+ldiDMJCZjlT/kDOWLP5ZznzolsapNAI31k
         K1kdZudlRNUj+I32LTHUbTKrzOfmKSzYUAKidil8eMwN9Qme/eQfCC0HC/mNwo8geU
         en2O5ywITVqfMQj36APlYxPct31gpMyDbzBU6UnE=
Date:   Thu, 29 Apr 2021 22:59:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 123/178] mm/doc: turn fault flags into an enum
Message-ID: <20210430055931.ECXicnQqR%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -432,8 +432,7 @@ extern unsigned int kobjsize(const void
 extern pgprot_t protection_map[16];
 
 /**
- * Fault flag definitions.
- *
+ * enum fault_flag - Fault flag definitions.
  * @FAULT_FLAG_WRITE: Fault was a write fault.
  * @FAULT_FLAG_MKWRITE: Fault was mkwrite of existing PTE.
  * @FAULT_FLAG_ALLOW_RETRY: Allow to retry the fault if blocked.
@@ -464,16 +463,18 @@ extern pgprot_t protection_map[16];
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
@@ -496,7 +497,7 @@ extern pgprot_t protection_map[16];
  * Return: true if the page fault allows retry and this is the first
  * attempt of the fault handling; false otherwise.
  */
-static inline bool fault_flag_allow_retry_first(unsigned int flags)
+static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 {
 	return (flags & FAULT_FLAG_ALLOW_RETRY) &&
 	    (!(flags & FAULT_FLAG_TRIED));
@@ -531,7 +532,7 @@ struct vm_fault {
 		pgoff_t pgoff;			/* Logical page offset based on vma */
 		unsigned long address;		/* Faulting virtual address */
 	};
-	unsigned int flags;		/* FAULT_FLAG_xxx flags
+	enum fault_flag flags;		/* FAULT_FLAG_xxx flags
 					 * XXX: should really be 'const' */
 	pmd_t *pmd;			/* Pointer to pmd entry matching
 					 * the 'address' */
_
