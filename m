Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7D5C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 18:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbiCASZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 13:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiCASZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 13:25:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E376514D
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 10:24:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A028BB81BF4
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 18:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA25C340EE;
        Tue,  1 Mar 2022 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646159093;
        bh=X7CJIToS60HcEPTx7uViaTTyFBeFec0eDybpvO2i2Xc=;
        h=Date:To:From:Subject:From;
        b=WHOmGRh0qT7vrHdrQ+pXygJ+kU5NW3ifQQfc3BP/bbqJhGYL4BszpQMVqa9UX+vlr
         eQXeDgEHD+OAZIvG333he+g9PwD3NgHFXtm+1ultgZydFZIK3qbbKUAEQ4CmHSH4n9
         QquuvxXI3vx3y12UvZUzzTaZ82GmqtI8j4/S6hpQ=
Date:   Tue, 01 Mar 2022 10:24:52 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        v.narang@samsung.com, swboyd@chromium.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        ojeda@kernel.org, mcgrof@kernel.org, maninder1.s@samsung.com,
        lkp@intel.com, linux@rasmusvillemoes.dk, atomlin@redhat.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch added to -mm tree
Message-Id: <20220301182453.4AA25C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix
has been added to the -mm tree.  Its filename is
     kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch

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
kallsyms-enhance-%ps-s-b-printing-when-kallsysms-is-disabled-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-dp-drm_dpc-fix-build.patch
arch-x86-kernel-resourcec-needs-spinlockh.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

