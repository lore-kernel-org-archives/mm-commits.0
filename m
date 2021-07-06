Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFE6C11F66
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793D461CA8
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGFT0X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhGFT0X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:26:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6865861CA8;
        Tue,  6 Jul 2021 19:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599424;
        bh=Liz1eE06gcZA8Zampt8fZiNwy/GHpwRWbS9P9AiXFNA=;
        h=Date:From:To:Subject:From;
        b=qjPHo+1ZvodByU6hIfiN0KsfCV3AXzOqr1fBiJu36uUSJLxcKh/wfNdVi9wEBKYIV
         XnRgBEpp6RMAuynnsPx/uDLrQjWrzY+/SeScS6pDmxgQ2cUtreNpGq39+AIlkVi19b
         nZadCEsd9eNuynHaufVfrV32XCyhWU5w2AWCRQtM=
Date:   Tue, 06 Jul 2021 12:23:44 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [merged]
 kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch removed from
 -mm tree
Message-ID: <20210706192344.KdV4gYdHh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cgroup/cgroup.c: don't export cgroup_get_e_css twice
has been removed from the -mm tree.  Its filename was
     kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/cgroup/cgroup.c: don't export cgroup_get_e_css twice


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/cgroup/cgroup.c~kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice
+++ a/kernel/cgroup/cgroup.c
@@ -600,7 +600,6 @@ static void cgroup_get_live(struct cgrou
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
 	css_get(&cgrp->self);
 }
-EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 
 /**
  * __cgroup_task_count - count the number of tasks in a cgroup. The caller
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

