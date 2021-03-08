Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B57EC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E97D651D3
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhCHU4w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhCHU42 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:56:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0421651D3;
        Mon,  8 Mar 2021 20:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615236987;
        bh=7At6x9MFE7HF4bVRPduOUU2YnOCnZv7aEFrxpnIQY70=;
        h=Date:From:To:Subject:From;
        b=FGD0kvoikz2m7mMOoyXqA3t0RDz7swTujXtJmoCdUd+O+ANursSY+KmW7yP6Pdo5H
         G32mhee1FrD+pcDWITdODZxcJVmyYZ4d1yeqQHym7lW6Anq9AJSlOJk02acJYPoJH5
         T95Vw5cWIsQaG5g17vqGMXZ4+Vu8+BygB7wrEYdE=
Date:   Mon, 08 Mar 2021 12:56:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhang.yunkai@zte.com.cn
Subject:  + mm-process_vm_access-remove-duplicate-include.patch
 added to -mm tree
Message-ID: <20210308205627.TWVXHXREJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/process_vm_access.c: remove duplicate include
has been added to the -mm tree.  Its filename is
     mm-process_vm_access-remove-duplicate-include.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-process_vm_access-remove-duplicate-include.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-process_vm_access-remove-duplicate-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: mm/process_vm_access.c: remove duplicate include

'linux/compat.h' included in 'process_vm_access.c' is duplicated.

Link: https://lkml.kernel.org/r/20210306132122.220431-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/process_vm_access.c~mm-process_vm_access-remove-duplicate-include
+++ a/mm/process_vm_access.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
-#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
_

Patches currently in -mm which might be from zhang.yunkai@zte.com.cn are

module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch
sh-remove-duplicate-include-in-tlbh.patch
mm-process_vm_access-remove-duplicate-include.patch

