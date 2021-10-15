Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAD4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645E561151
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhJOTea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235221AbhJOTea (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 15:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9BE160E05;
        Fri, 15 Oct 2021 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634326343;
        bh=I662ywLY8ZDV4gPANpVkU9vOH1uUD2NZLJYhKCxhM5I=;
        h=Date:From:To:Subject:From;
        b=CPpNz26/QAg4FAdh24Npb/t7DN4Z1SwHOcgxOWxtPbCHSS0nUDUl0HeBCHB0hkkCG
         3NFEMhdU/uE86cYPrcY3RKvsOUM2+W1PfrxJAPANly/b8GlCQ7EtS7CA5uAAzqH439
         1RSEUdkgE2kZyNtAaSXTsXxvui05eATVV44K6qho=
Date:   Fri, 15 Oct 2021 12:32:23 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch
 added to -mm tree
Message-ID: <20211015193223.LgI20C_G7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bottom_half.h needs kernel.h
has been added to the -mm tree.  Its filename is
     kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: bottom_half.h needs kernel.h

for _THIS_IP_ on arm at least

Link: https://lkml.kernel.org/r/20211015202908.1c417ae2@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bottom_half.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/bottom_half.h~kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix
+++ a/include/linux/bottom_half.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
+#include <linux/kernel.h>
 #include <linux/preempt.h>
 
 #if defined(CONFIG_PREEMPT_RT) || defined(CONFIG_TRACE_IRQFLAGS)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch

