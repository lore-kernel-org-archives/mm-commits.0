Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA1CC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 22:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242067AbiCBWEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 17:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbiCBWEL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 17:04:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEE8C9920
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 14:03:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1D9BB82285
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 22:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD6EC340F2;
        Wed,  2 Mar 2022 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646258604;
        bh=6YLCRyAoEDcYGe/aFmnihGX5/b0x00pOLnLS1qgiaXI=;
        h=Date:To:From:Subject:From;
        b=I/kWNxZiVQZR29T6juP+Mdr5zCNwpXqstiF2vlYAfixgVtCbu/QNETWru4fXc/tjX
         ilb/zHER60jsp5UBFiQ/46IDbQ8yz3wEnb7dIze39iEFTo1kOyfJrx2COQOLJ/tBQM
         8620gYklQayATlSTgAhLWVegE8vaFRBLrFg0k2MA=
Date:   Wed, 02 Mar 2022 14:03:23 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        v.narang@samsung.com, swboyd@chromium.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        ojeda@kernel.org, mcgrof@kernel.org, maninder1.s@samsung.com,
        lkp@intel.com, linux@rasmusvillemoes.dk, atomlin@redhat.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch removed from -mm tree
Message-Id: <20220302220324.3FD6EC340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix
has been removed from the -mm tree.  Its filename was
     kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch

This patch was dropped because it was folded into kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix

fix -Wunused-but-set-variable warning

>> lib/vsprintf.c:991:13: warning: variable 'modbuildid' set but not used [-Wunused-but-set-variable]

Reported-by: kernel test robot <lkp@intel.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/vsprintf.c~kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix
+++ a/lib/vsprintf.c
@@ -988,7 +988,7 @@ static int sprint_module_info(char *buf,
 	unsigned long base;
 	int ret = 0;
 	const char *modname;
-	int modbuildid = 0;
+	int modbuildid __maybe_unused = 0;
 	int len;
 #if IS_ENABLED(CONFIG_STACKTRACE_BUILD_ID)
 	const unsigned char *buildid = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

