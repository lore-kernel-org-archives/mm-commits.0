Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8035C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 22:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF2261040
	for <mm-commits@archiver.kernel.org>; Fri, 29 Oct 2021 22:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhJ2WO2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Oct 2021 18:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230504AbhJ2WO2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 Oct 2021 18:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB49C61039;
        Fri, 29 Oct 2021 22:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635545519;
        bh=xBYeyG+cRxT911pEhpeHxhLzllVpva3QIex26HByrpI=;
        h=Date:From:To:Subject:From;
        b=LdHjNALeHr49ckRotrcOCfqz5USPlgP1boXtUd2S2eT3X8rMWZLTEfPVii9o/amW1
         3G0PJ1qcNuuOsGBqankSgkoKNT95GoQY82NotojADAGK2c2tZHwEe4Cf/UUdRnuAHF
         /Ar4rgLb9agltlb1S7bh6lBDuPnVwW9F+fChPSiw=
Date:   Fri, 29 Oct 2021 15:11:58 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, deng.changcheng@zte.com.cn, dyoung@redhat.com,
        horms@kernel.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vgoyal@redhat.com, ye.guojin@zte.com.cn, zealci@zte.com.cn
Subject:  +
 crash_dump-remove-duplicate-include-in-crash_dumph.patch added to -mm tree
Message-ID: <20211029221158.NoUmaT-pf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: crash_dump: remove duplicate include in crash_dump.h
has been added to the -mm tree.  Its filename is
     crash_dump-remove-duplicate-include-in-crash_dumph.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/crash_dump-remove-duplicate-include-in-crash_dumph.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/crash_dump-remove-duplicate-include-in-crash_dumph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

crash_dump-remove-duplicate-include-in-crash_dumph.patch
signal-remove-duplicate-include-in-signalh.patch

