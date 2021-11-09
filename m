Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C3DC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD174617E4
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237442AbhKIChx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BDB3614C8;
        Tue,  9 Nov 2021 02:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425307;
        bh=PbmavDJ6h4OooK6vu/WDTawKbOV0n+Xfiz2K+zz7EsM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QHZj2C+UDscpHacbTMMu2UsbcGpGfCs5Xnrm2QPJNZe+AtCM2Dg3dmcUYU2TURxCg
         ReZMtC+h2PhDBzwW5EhH0AFoSUfSIYbpwEPO6/Ii/4xmbJdUfTIo5xdLF55ux/jvGk
         yMvuJZrllK1phTuqEq3MKa7821YFJlAK4ndTCxQM=
Date:   Mon, 08 Nov 2021 18:35:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        deng.changcheng@zte.com.cn, dyoung@redhat.com, horms@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  [patch 69/87] crash_dump: fix boolreturn.cocci warning
Message-ID: <20211109023507.XV_0-EOzC%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
