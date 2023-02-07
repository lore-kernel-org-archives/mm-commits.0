Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4CEC05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjBGBCg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBGBCf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:02:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A951B3A88
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:02:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A3F61086
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E0FC433D2;
        Tue,  7 Feb 2023 01:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675731752;
        bh=1SGHgQe1RlSBRA7wknlP3FyjAVp/AnQfieZuqck4vPA=;
        h=Date:To:From:Subject:From;
        b=asyAiFcU0jWdYi5sTZjTU0aZ8X+zkKf7PBR9m0C4JBzo8mFFVQhT/2eTybQ8y+wxl
         6Z/NZF8Tvga/2vFQKbEkaaXBs1QDmEdrkiMSpsLchZIlR8X3rYe19kLn6Iq9bXilCt
         oMSTwiw4ZJOPFJ7WNg0u2UwVQtiCQfk1omc+H9/8=
Date:   Mon, 06 Feb 2023 17:02:31 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-fix-w=1-build-warnings-with-config_shmem=n.patch added to mm-unstable branch
Message-Id: <20230207010232.84E0FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix W=1 build warnings with CONFIG_SHMEM=n
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-fix-w=1-build-warnings-with-config_shmem=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-fix-w=1-build-warnings-with-config_shmem=n.patch

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

mm-add-memcpy_from_file_folio.patch
shmem-fix-w=1-build-warnings-with-config_shmem=n.patch

