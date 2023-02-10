Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ECFC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjBJA4h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBJAzN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B59B7430D
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F8A6B82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C48C433D2;
        Fri, 10 Feb 2023 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990455;
        bh=xb2nqqqcx1vv3DinPYcxm0+FancJTE0tfkkWRfjfkLo=;
        h=Date:To:From:Subject:From;
        b=lTPnYkuU/LWNNKgJgfvPDaNHSpiAuQLb0HXlQFuSJKyvDiC7ip+Z5jmcNZG5TF0M1
         ci7zheMKaDoTKSk/r3cGMd9fgU0W655FwBYAXpFgwwdNY7zJTLakQBC+3mkk/ddzKe
         nbYGEEcJTZp0/z7sa9vLJznEYuh0SEcVIqRChv7Y=
Date:   Thu, 09 Feb 2023 16:54:14 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-fix-w=1-build-warnings-with-config_shmem=n.patch removed from -mm tree
Message-Id: <20230210005415.08C48C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: fix W=1 build warnings with CONFIG_SHMEM=n
has been removed from the -mm tree.  Its filename was
     shmem-fix-w=1-build-warnings-with-config_shmem=n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: fix W=1 build warnings with CONFIG_SHMEM=n
Date: Mon, 6 Feb 2023 19:08:50 +0000

With W=1 and CONFIG_SHMEM=n, shmem.c functions have no prototypes so the
compiler emits warnings.

Link: https://lkml.kernel.org/r/20230206190850.4054983-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-fix-w=1-build-warnings-with-config_shmem=n
+++ a/mm/shmem.c
@@ -33,6 +33,7 @@
 #include <linux/random.h>
 #include <linux/sched/signal.h>
 #include <linux/export.h>
+#include <linux/shmem_fs.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/hugetlb.h>
@@ -58,7 +59,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
-#include <linux/shmem_fs.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
 #include <linux/percpu_counter.h>
_

Patches currently in -mm which might be from willy@infradead.org are


