Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4637C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C4420866
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193889;
	bh=rq+MEMUDg400wcxLgvqGrFkZZT8Rv1EgDPEiP8D0/ew=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nsra2WYchVqalKePQEAgIrQqByenCwJsqkNpGWO0h7tkQ7WtcrYYtdNp3bcs4wOu+
	 +SKUqL2k+l3eEr/rjEzPo+bAePnRMEQyOrD+gLJ2fFOGv8+FxQUuoPAxUq6/z7LpX/
	 e163KttXwlUpScbQouUEj1EpyngNQAK54sIf+8PE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgHLA6J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLA6J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:58:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DE06207DA;
        Wed, 12 Aug 2020 00:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193888;
        bh=rq+MEMUDg400wcxLgvqGrFkZZT8Rv1EgDPEiP8D0/ew=;
        h=Date:From:To:Subject:From;
        b=vHenSaOS3oDoofTWusBdx+p3CbLE9sz1buGUZ1yjc1wcNXL/05d5OAoSTrAn02Uhz
         fSCyEMtXt53FzqSIrGMyIX3gtEcQVp+oG3qfgKYQVXPgN0y0t1LCmUQD9frlGZg/Qd
         oxtAlCG+oL9n0GQW/TiJrsf3jXnnq8SxACZ+2Z1A=
Date:   Tue, 11 Aug 2020 17:58:07 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bhe@redhat.com,
        guojianchao@bytedance.com, mgorman@suse.de, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        rientjes@google.com, songmuchun@bytedance.com, walken@google.com
Subject:  [folded-merged]
 mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch removed
 from -mm tree
Message-ID: <20200812005807.p8G3gZJWZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch

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

mm-hugetlb-add-mempolicy-check-in-the-reservation-routine.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

