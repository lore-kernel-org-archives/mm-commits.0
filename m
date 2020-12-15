Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF86C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7174D2072C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgLOCPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:15:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgLOCPe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:15:34 -0500
Date:   Mon, 14 Dec 2020 18:14:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998493;
        bh=LN1dRU8eZ+nz55FgheLaNQkkSvHtwrdiHjS5H9bPzXI=;
        h=From:To:Subject:From;
        b=Jnrkpw9ptSVFZgm6WKpaBi4PSep4UTT4BypaN9BwgifgSzRqXigXF5PZhWYVNTDX6
         tahRrndBJxhow1v1TBWyofrTx7F9EDYbf4e0iq2uw31zIU++LqamPB99TrHJARVmEF
         iy4eTT5CBkR4wNZcDy/c37JIWnv1um1GhG2xAmgM=
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-memcontrol-add-file_thp-shmem_thp-to-memorystat-fix.patch removed from
 -mm tree
Message-ID: <20201215021453.j1w7SRWkD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: add file_thp, shmem_thp to memory.stat fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-add-file_thp-shmem_thp-to-memorystat-fix.patch

This patch was dropped because it was folded into mm-memcontrol-add-file_thp-shmem_thp-to-memorystat.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: add file_thp, shmem_thp to memory.stat fix

add documentation

Link: https://lkml.kernel.org/r/20201026174029.GC548555@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-add-file_thp-shmem_thp-to-memorystat-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1300,6 +1300,14 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used in anonymous mappings backed by
 		transparent hugepages
 
+	  file_thp
+		Amount of cached filesystem data backed by transparent
+		hugepages
+
+	  shmem_thp
+		Amount of shm, tmpfs, shared anonymous mmap()s backed by
+		transparent hugepages
+
 	  inactive_anon, active_anon, inactive_file, active_file, unevictable
 		Amount of memory, swap-backed and filesystem-backed,
 		on the internal memory management lists used by the
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-add-file_thp-shmem_thp-to-memorystat.patch
mm-dont-wake-kswapd-prematurely-when-watermark-boosting-is-disabled.patch

