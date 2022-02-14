Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E04C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 22:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiBNWzA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:55:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiBNWzA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 17:55:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C9177E73
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 14:54:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3683F6151D
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 22:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A379C340E9;
        Mon, 14 Feb 2022 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644879290;
        bh=kDU2o7qHlUlAlk3Fn4Dvo+Xqqj0prMm4rt/twRFGyn8=;
        h=Date:To:From:Subject:From;
        b=T9P6cPFdRsnjdsRB3netXh26LMmN81IePwxrbklBgn3T8bWtIilkt9cuuG0zLF3X7
         WRCfGFxS/v7gj6hWoL8kliwOhIgErurqniGZr6slHrwf619sptnCAP0fVW+0dpNBcI
         MLN4Oja1H3EnpMW6FDhb9sC+pfLW+pRnHID4RUfk=
Date:   Mon, 14 Feb 2022 14:54:50 -0800
To:     mm-commits@vger.kernel.org, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-outline-copy_overflow-fix.patch removed from -mm tree
Message-Id: <20220214225450.8A379C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-outline-copy_overflow-fix
has been removed from the -mm tree.  Its filename was
     mm-outline-copy_overflow-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-outline-copy_overflow-fix

export copy_overflow() to modules

Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/maccess.c~mm-outline-copy_overflow-fix
+++ a/mm/maccess.c
@@ -340,3 +340,4 @@ void copy_overflow(int size, unsigned lo
 {
 	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
 }
+EXPORT_SYMBOL_GPL(copy_overflow);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

