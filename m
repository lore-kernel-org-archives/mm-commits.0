Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583B9C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452E361361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhKKC4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234599AbhKKC4c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4B760F46;
        Thu, 11 Nov 2021 02:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599223;
        bh=Br9Z0cSoqUpgapNBx06oY5cSbr+Pz49/F3tfzz/ErxM=;
        h=Date:From:To:Subject:From;
        b=CgZVpaWzIMmP2KsXfuuAHex24GhANuZnsB7q+pvXXCbco6srvT9hhS2HCvFu/OesC
         aVmCpm7DQMfO7XDDQjNJ6FXw5il4+bWELL4tL33ugc+uuxGWvVSpLkqgfgTcS6/s+U
         kS+YNdz1j/UclK/q07YI8Zbh0UI/vaImTdGuiGj0=
Date:   Wed, 10 Nov 2021 18:53:43 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, deng.changcheng@zte.com.cn, dyoung@redhat.com,
        horms@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vgoyal@redhat.com, ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  [merged] crash_dump-fix-boolreturncocci-warning.patch
 removed from -mm tree
Message-ID: <20211111025343.-upvL69v3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_dump: fix boolreturn.cocci warning
has been removed from the -mm tree.  Its filename was
     crash_dump-fix-boolreturncocci-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


