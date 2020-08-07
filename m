Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C0DC433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F63E2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596763391;
	bh=qOrhbqggB2ROLVi+2wrSeAKp4Yb0tX/xuWOdq3I7I58=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cb/p2ToU2dRDZKWsg/2UKt+by9jOdvCgSLabwVjnaCw5U1Tf81cCLNFTtX97P8LnS
	 gZhfoUmsAJSot4pZjXEGOcwgZU7Jt0IEk7RLOnyoqaevBHkMBRrLGKPiVOP5w3vbcp
	 0/7MUfS0wolndPuYN3hZDBeUZ4Yy8AedjSp4fHe0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHGBXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Aug 2020 21:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgHGBXH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 Aug 2020 21:23:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E236E2177B;
        Fri,  7 Aug 2020 01:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596763387;
        bh=qOrhbqggB2ROLVi+2wrSeAKp4Yb0tX/xuWOdq3I7I58=;
        h=Date:From:To:Subject:From;
        b=D4J1z7kDB/jcKgR69WjQrZF0yG21l2AQ3UxEShgD8VKKqYXNWpdlxthTci85pxI7v
         JmGeIdGcZWOguTPpkTq2yq7NiMcwU2oi6ylwSDx9PwRDA/+uwCoiAnhfCMIr5/FfhU
         Bnh1MkXl0xKa3OOThqOO3V+s6zf8Jru5sVJfxvuE=
Date:   Thu, 06 Aug 2020 18:23:06 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bhe@redhat.com,
        guojianchao@bytedance.com, mgorman@suse.de, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, walken@google.com
Subject:  +
 mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch added
 to -mm tree
Message-ID: <20200807012306.SClwo0CBr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix

include sched.h for `current'

Cc: Baoquan He <bhe@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jianchao Guo <guojianchao@bytedance.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mempolicy.h~mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix
+++ a/include/linux/mempolicy.h
@@ -6,7 +6,7 @@
 #ifndef _LINUX_MEMPOLICY_H
 #define _LINUX_MEMPOLICY_H 1
 
-
+#include <linux/sched.h>
 #include <linux/mmzone.h>
 #include <linux/dax.h>
 #include <linux/slab.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

