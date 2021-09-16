Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9A8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 20:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B9EB611F2
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 20:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhIPUEh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 16:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhIPUEh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 16:04:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30565611CA;
        Thu, 16 Sep 2021 20:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631822596;
        bh=VgSqmCSAUBSc3LAfrLKxLK98acnUZydOWuxm3H5YJSQ=;
        h=Date:From:To:Subject:From;
        b=GGK8km5T1MxH6jjOsSX5ArT/B1L3kh6R9vp3GkcCjmtkW/8TtTtsQE9L4wccQXO9F
         KnId/9CIyTLeyFUbk1W2cnQEV2SeBt7cnOmh6HjfH/KrPSelPkcZ5Krk/iadWykdyy
         DlVfTjOCHC2gbEKObmQ43psCgAp2NYAxgnUi9y58=
Date:   Thu, 16 Sep 2021 13:03:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave@stgolabs.net,
        ebiederm@xmission.com, manfred@colorfullife.com,
        mclapinski@google.com, mm-commits@vger.kernel.org
Subject:  +
 ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
 added to -mm tree
Message-ID: <20210916200315.GEpzV0bln%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix
has been added to the -mm tree.  Its filename is
     ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch

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
Subject: ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix

ipc/ipc_sysctl.c needs capability.h for checkpoint_restore_ns_capable()

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Michal Clapinski <mclapinski@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/ipc/ipc_sysctl.c~ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix
+++ a/ipc/ipc_sysctl.c
@@ -10,6 +10,7 @@
 #include <linux/nsproxy.h>
 #include <linux/sysctl.h>
 #include <linux/uaccess.h>
+#include <linux/capability.h>
 #include <linux/ipc_namespace.h>
 #include <linux/msg.h>
 #include "util.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch

