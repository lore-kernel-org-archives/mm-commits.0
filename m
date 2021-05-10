Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0E9C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA30F613D2
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 01:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhEJBF1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 21:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhEJBF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 21:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104CD613CE;
        Mon, 10 May 2021 01:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620608663;
        bh=ZPwNIqQgVwVWJGaG87QuekvE+/ggCIC8bnBpfmzX1uQ=;
        h=Date:From:To:Subject:From;
        b=ykhipzPF4qsy6SJjPEhGGXQOBHIfGuTRQHUfeGQUiKv8NQBAtBP+XivJYAYdqoyvu
         2qY1RO9dhXVEcgqR6yE16FcGm8wpTkWd2Ds3Tl0eQcBUhtvZ0eoUmO98eP+vDUPBrd
         15gUOZ5icFflQkp6MiV1S5lIBpNFJzHPunds2pN8=
Date:   Sun, 09 May 2021 18:04:22 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, corbet@lwn.net, eric.dumazet@gmail.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  +
 docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch added
 to -mm tree
Message-ID: <20210510010422.yGiRcHD5Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: proc.rst: meminfo: briefly describe gaps in memory accounting
has been added to the -mm tree.  Its filename is
     docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: docs: proc.rst: meminfo: briefly describe gaps in memory accounting

Add a paragraph that explains that it may happen that the counters in
/proc/meminfo do not add up to the overall memory usage.

Link: https://lkml.kernel.org/r/20210421061127.1182723-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting
+++ a/Documentation/filesystems/proc.rst
@@ -933,8 +933,15 @@ meminfo
 ~~~~~~~
 
 Provides information about distribution and utilization of memory.  This
-varies by architecture and compile options.  The following is from a
-16GB PIII, which has highmem enabled.  You may not have all of these fields.
+varies by architecture and compile options.  Some of the counters reported
+here overlap.  The memory reported by the non overlapping counters may not
+add up to the overall memory usage and the difference for some workloads
+can be substantial.  In many cases there are other means to find out
+additional memory using subsystem specific interfaces, for instance
+/proc/net/sockstat for TCP memory allocations.
+
+The following is from a 16GB PIII, which has highmem enabled.
+You may not have all of these fields.
 
 ::
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

