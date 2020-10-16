Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B852C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE988218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881719;
	bh=Yl+vmYBPobn8wr0Ts0GuMwAR/wJAHFI/HFOeQSUM3Wc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XIaBo2Mq9fflbGVrNUjSZL6FgjFLNAPPlIAqZ2LWcS7BQokYq0Td74eRVK8v4fsNB
	 rj+3z7cHpQ512RCQ8i+eRYjJgeIfmkL7B3aJtdK+YW/ArJntAjvv8JZreNl/kjYtOj
	 oFxaE0s/Dn3Mpp8FEOVo5GcBx7sN7lbynewJjA4E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgJPUzT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUzT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:55:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E52221775;
        Fri, 16 Oct 2020 20:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881718;
        bh=Yl+vmYBPobn8wr0Ts0GuMwAR/wJAHFI/HFOeQSUM3Wc=;
        h=Date:From:To:Subject:From;
        b=eyA+/c+M0fs/gP61g4P0Z0Ineme50iOHvBdg2Nj7uTkk8mWpI8s6LBO92F0M/Tw59
         CpolrB1UexSbdi+zsTljcFngf5Uc3fpPmwmltgDMONbIP8WjGWd7WRlVgRvvc/8mk5
         4JiYxaeubLSTV1z4zc3fcSoiXoHPU/UKpmOp2Ms0=
Date:   Fri, 16 Oct 2020 13:55:18 -0700
From:   akpm@linux-foundation.org
To:     jannh@google.com, keescook@chromium.org, lenaptr@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch removed from
 -mm tree
Message-ID: <20201016205518.8Td3uQV3Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched.h: drop in_ubsan field when UBSAN is in trap mode
has been removed from the -mm tree.  Its filename was
     schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Elena Petrova <lenaptr@google.com>
Subject: sched.h: drop in_ubsan field when UBSAN is in trap mode

in_ubsan field of task_struct is only used in lib/ubsan.c, which in its
turn is used only `ifneq ($(CONFIG_UBSAN_TRAP),y)`.

Removing unnecessary field from a task_struct will help preserve the ABI
between vanilla and CONFIG_UBSAN_TRAP'ed kernels.  In particular, this
will help enabling bounds sanitizer transparently for Android's GKI.

Link: https://lkml.kernel.org/r/20200910134802.3160311-1-lenaptr@google.com
Signed-off-by: Elena Petrova <lenaptr@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sched.h~schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode
+++ a/include/linux/sched.h
@@ -1013,7 +1013,7 @@ struct task_struct {
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
-#ifdef CONFIG_UBSAN
+#if defined(CONFIG_UBSAN) && !defined(CONFIG_UBSAN_TRAP)
 	unsigned int			in_ubsan;
 #endif
 
_

Patches currently in -mm which might be from lenaptr@google.com are


