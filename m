Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6639EC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhLIUkU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:40:20 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34178 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLIUkU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:40:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5755DCE25DE
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1714C004DD;
        Thu,  9 Dec 2021 20:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639082203;
        bh=g86jNSNo+Tx5Q+a7BWft+WYYaOMukRmbe5qrIZYZHjE=;
        h=Date:From:To:Subject:From;
        b=OIWv8x6isHBqzXrp2AQ8UdrWXOqHl4PvvfPzUEMwLMIbscQH3NQqo6Wyjq099C7VW
         KvLD7nZ7hSc19hhJXbrz/RlFHa0iv+EZeUZ+6XeOEsTavNUKuKeINsniu6hl59+lMn
         cdbSOeNYI9N4kd0u0o/0qg5ZuOBBf5aHUVuCd7oU=
Date:   Thu, 09 Dec 2021 12:36:42 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, arend.vanspriel@broadcom.com,
        aspriel@gmail.com, chi-hsien.lin@infineon.com,
        chung-hsien.hsu@infineon.com, davem@davemloft.net,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        heikki.krogerus@linux.intel.com, kuba@kernel.org,
        kvalo@codeaurora.org, mchehab@kernel.org,
        mm-commits@vger.kernel.org, wright.feng@infineon.com
Subject:  +
 include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch
 added to -mm tree
Message-ID: <20211209203642.nYDbgmL7o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/unaligned: replace kernel.h with the necessary inclusions
has been added to the -mm tree.  Its filename is
     include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/unaligned: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

The rest of the changes are induced by the above and may not be split.

Link: https://lkml.kernel.org/r/20211209123823.20425-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-hsien Lin <chi-hsien.lin@infineon.com>
Cc: Wright Feng <wright.feng@infineon.com>
Cc: Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c |    2 ++
 include/linux/unaligned/packed_struct.h                 |    2 +-
 lib/lz4/lz4defs.h                                       |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c~include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions
+++ a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
@@ -4,6 +4,8 @@
  */
 
 #include <asm/unaligned.h>
+
+#include <linux/math.h>
 #include <linux/string.h>
 #include <linux/bug.h>
 
--- a/include/linux/unaligned/packed_struct.h~include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/unaligned/packed_struct.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_PACKED_STRUCT_H
 #define _LINUX_UNALIGNED_PACKED_STRUCT_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 struct __una_u16 { u16 x; } __packed;
 struct __una_u32 { u32 x; } __packed;
--- a/lib/lz4/lz4defs.h~include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions
+++ a/lib/lz4/lz4defs.h
@@ -36,6 +36,8 @@
  */
 
 #include <asm/unaligned.h>
+
+#include <linux/bitops.h>
 #include <linux/string.h>	 /* memset, memcpy */
 
 #define FORCE_INLINE __always_inline
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

include-linux-unaligned-replace-kernelh-with-the-necessary-inclusions.patch
kernelh-include-a-note-to-discourage-people-from-including-it-in-headers.patch
list-introduce-list_is_head-helper-and-re-use-it-in-listh.patch

