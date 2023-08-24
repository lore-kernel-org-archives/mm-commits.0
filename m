Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0025EE49A0
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244067AbjHXXVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjHXXVG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81814A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62FCB63676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E6DC433C8;
        Thu, 24 Aug 2023 23:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919263;
        bh=A5FGuQ1/Xbi0ffDDu5mYa+4y2YTFhXhtTMNxcmkhCxA=;
        h=Date:To:From:Subject:From;
        b=UXUwFH/gcEadcR5w/V5AzeBzNeGLnN5SgqQuF94xQq1sKWOvkNyEldzn5ophWAqpw
         SQ/x+NNNb+hlbmRgjI5vCHiK/Hq9J7JLV0zHtutShY8R/kuAVVjak0cRzJEuoFHwGt
         YlC6pr2K6BFuaxS+ubhJmH8l1FickKKPtv6LcaFo=
Date:   Thu, 24 Aug 2023 16:21:03 -0700
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
Subject: [merged mm-stable] mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch removed from -mm tree
Message-Id: <20230824232103.B2E6DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add missing VM_FAULT_RESULT_TRACE name for VM_FAULT_COMPLETED
has been removed from the -mm tree.  Its filename was
     mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1184,7 +1184,8 @@ enum vm_fault_reason {
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


