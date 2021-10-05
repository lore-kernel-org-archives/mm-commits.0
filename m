Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64ABC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6AC0611C6
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhJEXYA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236855AbhJEXX7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:23:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92FDC611C6;
        Tue,  5 Oct 2021 23:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633476128;
        bh=uJqQQAjMQjnhIE+rBahMo2y+2krsF3YiJwsFL4Xf8lA=;
        h=Date:From:To:Subject:From;
        b=x7qIXZY4jYn9sjtFgKGy8TISFMXu/JN6LH7+2ismjADYUo+REG0bcv5y2yez/obxn
         /vfGEdIBtjkAGY9omQeaDwgiqhNPUPL+UyY2cmUdrgAsCr5tUzsIepB/q0KwxjbEmf
         FmXwTAMBnbe9FWqsgBeH4V8I5s8sEZHJpTgyEhCo=
Date:   Tue, 05 Oct 2021 16:22:08 -0700
From:   akpm@linux-foundation.org
To:     lucas.demarchi@intel.com, mm-commits@vger.kernel.org
Subject:  + lib-string_helpers-add-linux-stringh-for-strlen.patch
 added to -mm tree
Message-ID: <20211005232208.iGesihLx6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/string_helpers.h: add linux/string.h for strlen()
has been added to the -mm tree.  Its filename is
     lib-string_helpers-add-linux-stringh-for-strlen.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpers-add-linux-stringh-for-strlen.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpers-add-linux-stringh-for-strlen.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@intel.com>
Subject: include/linux/string_helpers.h: add linux/string.h for strlen()

linux/string_helpers.h uses strlen(), so include the correponding header. 
Otherwise we get a compilation error if it's not also included by whoever
included the helper.

Link: https://lkml.kernel.org/r/20211005212634.3223113-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/string_helpers.h~lib-string_helpers-add-linux-stringh-for-strlen
+++ a/include/linux/string_helpers.h
@@ -4,6 +4,7 @@
 
 #include <linux/bits.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
 struct file;
_

Patches currently in -mm which might be from lucas.demarchi@intel.com are

lib-string_helpers-add-linux-stringh-for-strlen.patch

