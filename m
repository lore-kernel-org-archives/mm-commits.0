Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CADEC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A93611C5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbhKICST (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234245AbhKICSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:18:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A5496117A;
        Tue,  9 Nov 2021 02:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636424133;
        bh=EmJtdFRUoTTEX7SKqfg6lw+olNOl6v24/3s6ySo6lWI=;
        h=Date:From:To:Subject:From;
        b=h+sksp6XVS7/eBVqAG5nJwp1HAEyxlZJ/QXN7KgwJStv5jTu8m8RlwgDL+Rt+ojXK
         1BiYjEKDAlwkKo//KxcjlxNsQ29irF9J4leMh1U7vYz2ax7qeT/rugcEBXguJsOHcz
         5KEBc8nVN4AHAVmVI5aN4RP4kp8Ln/EH7liOi2EI=
Date:   Mon, 08 Nov 2021 18:15:32 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dave@stgolabs.net,
        ebiederm@xmission.com, manfred@colorfullife.com,
        mclapinski@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
 removed from -mm tree
Message-ID: <20211109021532.ZSS7P3h9-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix
has been removed from the -mm tree.  Its filename was
     ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch

This patch was dropped because it was folded into ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch

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

ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

