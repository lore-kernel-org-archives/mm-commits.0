Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2352C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 22:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B700C61040
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 22:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJ2WO1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Oct 2021 18:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230504AbhJ2WO0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 Oct 2021 18:14:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0EEA60F9B;
        Fri, 29 Oct 2021 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635545517;
        bh=vg1lwLmQtc59+kVT+wUZ4Zh7Da00zMqK6vDjI4NTpIM=;
        h=Date:From:To:Subject:From;
        b=K1P9a+oQcd9xLwFeu+ZEHneftUv3x6/VcMUehGip24zSLpdhZdqnCoBRx9qKSJSei
         zL+aDY7nEHR3kwcSaDjs5LJV4biebPCsWU1iUK3jzdixUvNtgnol9TP83CALjhl240
         XzX9/DyVhZJZsOCr+JFCzhVs038PiC4a4OwRCCkE=
Date:   Fri, 29 Oct 2021 15:11:56 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, deng.changcheng@zte.com.cn, dyoung@redhat.com,
        horms@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vgoyal@redhat.com, ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  + crash_dump-fix-boolreturncocci-warning.patch added to
 -mm tree
Message-ID: <20211029221156.4cEf05ApE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_dump: fix boolreturn.cocci warning
has been added to the -mm tree.  Its filename is
     crash_dump-fix-boolreturncocci-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/crash_dump-fix-boolreturncocci-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/crash_dump-fix-boolreturncocci-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changcheng Deng <deng.changcheng@zte.com.cn>
Subject: crash_dump: fix boolreturn.cocci warning

./include/linux/crash_dump.h: 119: 50-51: WARNING: return of 0/1 in
function 'is_kdump_kernel' with return type bool

Return statements in functions returning bool should use true/false
instead of 1/0.

Link: https://lkml.kernel.org/r/20211020083905.1037952-1-deng.changcheng@zte.com.cn
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ye Guojin <ye.guojin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/crash_dump.h~crash_dump-fix-boolreturncocci-warning
+++ a/include/linux/crash_dump.h
@@ -116,7 +116,7 @@ extern void register_vmcore_cb(struct vm
 extern void unregister_vmcore_cb(struct vmcore_cb *cb);
 
 #else /* !CONFIG_CRASH_DUMP */
-static inline bool is_kdump_kernel(void) { return 0; }
+static inline bool is_kdump_kernel(void) { return false; }
 #endif /* CONFIG_CRASH_DUMP */
 
 /* Device Dump information to be filled by drivers */
_

Patches currently in -mm which might be from deng.changcheng@zte.com.cn are

lib-test_vmallocc-use-swap-to-make-code-cleaner.patch
crash_dump-fix-boolreturncocci-warning.patch

