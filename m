Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220FDC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358168AbiATCIO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41672 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCIO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DDA615C2
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267FEC004E1;
        Thu, 20 Jan 2022 02:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644493;
        bh=g8TVnTSUsOZBBb3jkEzlFb6UiH4V6dyoHBQab2OEtZU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jvdalAAamOo0c1fKSBaphZagmWYJAS04jZbUcHH26vlsOK3wABwyUu/b+652F1tSv
         7Nt/NhlwG+4biHNR6iz6p2IFWcYeBS9qQ50FlRj/yjXQVCeREEsXU8RIMZM7K/HUCe
         R8EPoGwn0Tp44msTrNTbxeUWXgUHPRCacSIycfa4=
Date:   Wed, 19 Jan 2022 18:08:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        arend.vanspriel@broadcom.com, aspriel@gmail.com,
        chi-hsien.lin@infineon.com, chung-hsien.hsu@infineon.com,
        davem@davemloft.net, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, heikki.krogerus@linux.intel.com,
        kuba@kernel.org, kvalo@codeaurora.org, kvalo@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wright.feng@infineon.com
Subject:  [patch 10/55] include/linux/unaligned: replace kernel.h
 with the necessary inclusions
Message-ID: <20220120020812.5WZBpxrFt%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/unaligned: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

The rest of the changes are induced by the above and may not be split.

Link: https://lkml.kernel.org/r/20211209123823.20425-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>	[brcmfmac]
Acked-by: Kalle Valo <kvalo@kernel.org>
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
