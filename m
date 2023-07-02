Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA924EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 17:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjGBRyu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGBRyt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 13:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D82E5C
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 10:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E4D560C7A
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAF6C433C9;
        Sun,  2 Jul 2023 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688320487;
        bh=zWqu+JMGZMAJoBQ9tpMryVZRj86tnSJY/4jQzzK3cDg=;
        h=Date:To:From:Subject:From;
        b=c8geF+cVTqyoNrGNYm/496/g9ofW2fyk70JoHG/BYY7By0Ba2WduuvjSJDc01ORrZ
         oLwN0D0y14IUU7x0X+ctE5mi/AQBxWHaNr1+f2zRlFvAMWq165wyQFzB8hiIy/nEo3
         uVsiV+Szw7+OLgKX4uFSLS2hzNhhF4/Ia1fik3kE=
Date:   Sun, 02 Jul 2023 10:54:46 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, apopple@nvidia.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch added to mm-unstable branch
Message-Id: <20230702175447.9AAF6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add missing VM_FAULT_RESULT_TRACE name for VM_FAULT_COMPLETED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch

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
Subject: mm: add missing VM_FAULT_RESULT_TRACE name for VM_FAULT_COMPLETED
Date: Fri, 30 Jun 2023 14:19:53 -0700

VM_FAULT_RESULT_TRACE should contain an element for every vm_fault_reason
to be used as flag_array inside trace_print_flags_seq().  The element for
VM_FAULT_COMPLETED is missing, add it.

Link: https://lkml.kernel.org/r/20230630211957.1341547-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed
+++ a/include/linux/mm_types.h
@@ -1077,7 +1077,8 @@ enum vm_fault_reason {
 	{ VM_FAULT_RETRY,               "RETRY" },	\
 	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
 	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
-	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" }
+	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
+	{ VM_FAULT_COMPLETED,           "COMPLETED" }
 
 struct vm_special_mapping {
 	const char *name;	/* The name, e.g. "[vdso]". */
_

Patches currently in -mm which might be from surenb@google.com are

swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch

