Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3350C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC07861250
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhKKC4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234599AbhKKC4f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B34E61075;
        Thu, 11 Nov 2021 02:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599226;
        bh=jpuMzA0+j3uGOQvhGsnhgaKs9hkU/MgOG5iz3eHe+GE=;
        h=Date:From:To:Subject:From;
        b=eyBXncaX8Qzq31M2uQyLrNnsSqEAWn5sFkdlBj9bHJZ4kjRkU6u3eZ9kexHooFdmf
         iMrBCkSVjSdMgWfqjASxkCWPn9/LEuMXg2KkorFjPtoo/3vQCuYzyvlMEigd+2M8J+
         if4rAWhZoxGim4+2NALsY1wMdMozhMng0KajKIYA=
Date:   Wed, 10 Nov 2021 18:53:46 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, deng.changcheng@zte.com.cn, dyoung@redhat.com,
        horms@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vgoyal@redhat.com, ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  [merged]
 crash_dump-remove-duplicate-include-in-crash_dumph.patch removed from -mm
 tree
Message-ID: <20211111025346.yIWluIfzI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_dump: remove duplicate include in crash_dump.h
has been removed from the -mm tree.  Its filename was
     crash_dump-remove-duplicate-include-in-crash_dumph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ye Guojin <ye.guojin@zte.com.cn>
Subject: crash_dump: remove duplicate include in crash_dump.h

In crash_dump.h, header file <linux/pgtable.h> is included twice.  This
duplication was introduced in commit 65fddcfca8ad("mm: reorder includes
after introduction of linux/pgtable.h") where the order of the header
files is adjusted, while the old one was not removed.

Clean it up here.

Link: https://lkml.kernel.org/r/20211020090659.1038877-1-ye.guojin@zte.com.cn
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Changcheng Deng <deng.changcheng@zte.com.cn>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/crash_dump.h~crash_dump-remove-duplicate-include-in-crash_dumph
+++ a/include/linux/crash_dump.h
@@ -8,8 +8,6 @@
 #include <linux/pgtable.h>
 #include <uapi/linux/vmcore.h>
 
-#include <linux/pgtable.h> /* for pgprot_t */
-
 /* For IS_ENABLED(CONFIG_CRASH_DUMP) */
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
_

Patches currently in -mm which might be from ye.guojin@zte.com.cn are


