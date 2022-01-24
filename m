Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F69C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 00:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3411659AbiAYAeT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:34:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40044 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846674AbiAXXQm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 18:16:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7461C60AEE
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 23:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A694AC340E4;
        Mon, 24 Jan 2022 23:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643066200;
        bh=+4QHjpalzjiN+czt3bWtx6YpnfCA+2Fh0iwBfMQpV+U=;
        h=Date:From:To:Subject:From;
        b=KKMi2PQFnGVJ7MdC1yWu6e6AmmsB6thov4X1U7CrPIo2w0jmTE4BvOIamKuUjYQz+
         VokV7WNlabFtQPMlsBt+QKr2UkxzOCOgy9481pzmF3SEH1sYb8w81XLOxw04odwsZ4
         dbvAi/liiksjbkJgQhMyNRY9958sWVnmQRy5YXQs=
Date:   Mon, 24 Jan 2022 15:16:40 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, ztong0001@gmail.com
Subject:  +
 include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch
 added to -mm tree
Message-ID: <20220124231640.adHZIK6Iz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sysctl.h: fix register_sysctl_mount_point() return type
has been added to the -mm tree.  Its filename is
     include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch

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
Subject: include/linux/sysctl.h: fix register_sysctl_mount_point() return type

The CONFIG_SYSCTL=n stub returns the wrong type.

Fixes: ee9efac48a082 ("sysctl: add helper to register a sysctl mount point")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sysctl.h~include-linux-sysctlh-fix-register_sysctl_mount_point-return-type
+++ a/include/linux/sysctl.h
@@ -265,7 +265,7 @@ static inline struct ctl_table_header *r
 	return NULL;
 }
 
-static inline struct sysctl_header *register_sysctl_mount_point(const char *path)
+static inline struct ctl_table_header *register_sysctl_mount_point(const char *path)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

