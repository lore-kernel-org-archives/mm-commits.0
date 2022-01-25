Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E54AC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344630AbiAYGqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353956AbiAYGnt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:43:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E8AC07851E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 21:01:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BC3DB81662
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 05:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE395C340E0;
        Tue, 25 Jan 2022 05:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643086875;
        bh=dWKpbbSfWyZAXLomMkLFD5t5vFba9Qynm3Cz8WYQEgQ=;
        h=Date:From:To:Subject:From;
        b=N9NRgfx0og1j0ZMesAFZQGHOu6q4IRpbNC4HMwcKmO/ggfp6ElKGjzf7tqqM3MFH6
         MY6KjAdeWdZx2fGzmU62IkJG9beSR4ssj0LpM9PlcBwxxPgfLBhEFMytFo7GX9ZeJt
         lonc/8QD2Scz5GdElczzFXdwAWntpM2WJh6jYIvQ=
Date:   Mon, 24 Jan 2022 21:01:14 -0800
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        christian.brauner@ubuntu.com, haolee.swjtu@gmail.com,
        jamorris@linux.microsoft.com, keescook@chromium.org, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch added to -mm
 tree
Message-ID: <20220125050114.rbXNPwh1_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix
has been added to the -mm tree.  Its filename is
     proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch

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
Subject: proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix

remove now-unneeded cast

Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Hao Lee <haolee.swjtu@gmail.com>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c~proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix
+++ a/fs/proc/base.c
@@ -1764,7 +1764,7 @@ out:
 
 static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 {
-	char *tmp = (char *)kmalloc(PATH_MAX, GFP_KERNEL);
+	char *tmp = kmalloc(PATH_MAX, GFP_KERNEL);
 	char *pathname;
 	int len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sysctlh-fix-register_sysctl_mount_point-return-type.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

