Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7ABC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D678B61A53
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhI3WYs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhI3WYr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC64E61A4F;
        Thu, 30 Sep 2021 22:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633040584;
        bh=/xG39mGgK8Yvl1Q7YqqrTFb8W0wlRD7vixJfh8EoilA=;
        h=Date:From:To:Subject:From;
        b=o3nAC/dY+oQK8cvgoeLU5lIazSFeZQP9YJ1A4j3aX0TgH15JIhPowkraanG2xTCvc
         Yxp1iJdX+EpTjQ2c3t9gDRAvigw/34CNLUAIMM4jOnYrsjRrF/w/yWTJM16P/29fm2
         3tbDZVi6eSVh103b0+yAiK9kYtQMgAfrK00oS8ek=
Date:   Thu, 30 Sep 2021 15:23:04 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, geert+renesas@glider.be,
        mm-commits@vger.kernel.org, peng.fan@nxp.com, rppt@kernel.org
Subject:  + memblock-check-memory-total_size.patch added to -mm
 tree
Message-ID: <20210930222304.--OL_47EE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: check memory total_size
has been added to the -mm tree.  Its filename is
     memblock-check-memory-total_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-check-memory-total_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-check-memory-total_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peng Fan <peng.fan@nxp.com>
Subject: memblock: check memory total_size

mem=[X][G|M] is broken on ARM64 platform, there are cases that even
type.cnt is 1, but total_size is not 0 because regions are merged into 1. 
So only check 'cnt' is not enough, total_size should be used, othersize
bootargs 'mem=[X][G|B]' not work anymore.

Link: https://lkml.kernel.org/r/20210930024437.32598-1-peng.fan@oss.nxp.com
Fixes: e888fa7bb882 ("memblock: Check memory add/cap ordering")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~memblock-check-memory-total_size
+++ a/mm/memblock.c
@@ -1687,7 +1687,7 @@ void __init memblock_cap_memory_range(ph
 	if (!size)
 		return;
 
-	if (memblock.memory.cnt <= 1) {
+	if (!memblock_memory->total_size) {
 		pr_warn("%s: No memory registered yet\n", __func__);
 		return;
 	}
_

Patches currently in -mm which might be from peng.fan@nxp.com are

memblock-check-memory-total_size.patch

