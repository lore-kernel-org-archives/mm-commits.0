Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25E7C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjDFDEc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbjDFDEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8CB5BA9
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBE3564174
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C987C433EF;
        Thu,  6 Apr 2023 03:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750231;
        bh=adt7MdYSIWIEynKOWvfRdAyPWoqmmU+rAr1yoXRRfkU=;
        h=Date:To:From:Subject:From;
        b=IwcC3q5f/6YZGWdUjinZIDnsXqHwGBlfrb7ikKU7IcHbRohjrFgE+O0LdhXMOHpvr
         GhXeXhcLUhSrqvWj10e426s+huNfneevnHGWJbL2o/ssvpzJ9/7a+yj+E1zbq50BWP
         XDzgYy65UOpvL9iTZJCoKbWIGsFhu8lmnZS+Ldvc=
Date:   Wed, 05 Apr 2023 20:03:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        pasha.tatashin@soleen.com, mathieu.desnoyers@efficios.com,
        Liam.Howlett@oracle.com, laurent.dufour@fr.ibm.com, jgg@ziepe.ca,
        hughd@google.com, error27@gmail.com, dhowells@redhat.com,
        david@redhat.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-fault_flag_vma_lock-flag.patch removed from -mm tree
Message-Id: <20230406030351.3C987C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add FAULT_FLAG_VMA_LOCK flag
has been removed from the -mm tree.  Its filename was
     mm-add-fault_flag_vma_lock-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: add FAULT_FLAG_VMA_LOCK flag
Date: Mon, 27 Feb 2023 09:36:24 -0800

Add a new flag to distinguish page faults handled under protection of
per-vma lock.

[surenb@google.com: document FAULT_FLAG_VMA_LOCK flag]
  Link: https://lkml.kernel.org/r/20230301022720.1380780-2-surenb@google.com
  Link: https://lore.kernel.org/all/20230301113648.7c279865@canb.auug.org.au/
Link: https://lkml.kernel.org/r/20230227173632.3292573-26-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Laurent Dufour <laurent.dufour@fr.ibm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    3 ++-
 include/linux/mm_types.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-add-fault_flag_vma_lock-flag
+++ a/include/linux/mm.h
@@ -479,7 +479,8 @@ static inline bool fault_flag_allow_retr
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
-	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }
+	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
+	{ FAULT_FLAG_VMA_LOCK,		"VMA_LOCK" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
--- a/include/linux/mm_types.h~mm-add-fault_flag_vma_lock-flag
+++ a/include/linux/mm_types.h
@@ -1049,6 +1049,7 @@ typedef struct {
  *                      mapped after the fault.
  * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
  *                        We should only access orig_pte if this flag set.
+ * @FAULT_FLAG_VMA_LOCK: The fault is handled under VMA lock.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -1086,6 +1087,7 @@ enum fault_flag {
 	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
 	FAULT_FLAG_UNSHARE =		1 << 10,
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
+	FAULT_FLAG_VMA_LOCK =		1 << 12,
 };
 
 typedef unsigned int __bitwise zap_flags_t;
_

Patches currently in -mm which might be from surenb@google.com are


