Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1BCC433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33DC821655
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953821;
	bh=0jftaNERMKK9mhKTPZouChRraUQ6Ozr7mZLZLa9SUKE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vqH+/bN7T1KNobwu1Mcs/LwaW7DkhMLQcrG3GbFlZeTjTtOsduVlxUwtKvK3qr+wZ
	 CNmGj3hio15v65y764Sd56s+3CqSkiiU5HyXg6FqP3LxRH0932wr0Q84KBG5uwGaMF
	 drYyrrdoZkeGhWXV0pbWC1vezoy9Y+b97MZAEhY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgILXhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgILXg7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:36:59 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B0620758;
        Sat, 12 Sep 2020 23:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953818;
        bh=0jftaNERMKK9mhKTPZouChRraUQ6Ozr7mZLZLa9SUKE=;
        h=Date:From:To:Subject:From;
        b=OsKOkGmTzXlNxsufBA3haqmmP/1CPdPPkF78OQ821pZcMTyzVF1kxOqAeAycfU5DI
         32XYT8Dq8IoNDddDJIJDnWBZnWKlstZGO/g97op0oDAuM44afiS/ojXP78dM+7CuQw
         bdtG5GQNO0Y092DpkAlz+ivMZKxUJHiDZRla7iJU=
Date:   Sat, 12 Sep 2020 16:36:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        jannh@google.com, lenaptr@google.com
Subject:  +
 schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch added to -mm tree
Message-ID: <20200912233658.ZsOjM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched.h: drop in_ubsan field when UBSAN is in trap mode
has been added to the -mm tree.  Its filename is
     schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1009,7 +1009,7 @@ struct task_struct {
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
-#ifdef CONFIG_UBSAN
+#if defined(CONFIG_UBSAN) && !defined(CONFIG_UBSAN_TRAP)
 	unsigned int			in_ubsan;
 #endif
 
_

Patches currently in -mm which might be from lenaptr@google.com are

schedh-drop-in_ubsan-field-when-ubsan-is-in-trap-mode.patch

