Return-Path: <SRS0=IHg8=AU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C53C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jul 2020 20:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA9B6207FB
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jul 2020 20:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594327344;
	bh=vpCi1modSFDnipJ0cOl931m9ohowJ2vlqV9+7acuAhE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VRr+hLcShILULwqTC7XGqbe8s/W3SL5ZKkLMGhHA0ArYJ35HlCA2PrFcqvXrYrtj7
	 OhifqaB3YNjWPDuLDcCInwJosrXwx0GHjgvAnk67wi9Dimcnm8QZHCel0n16PQP34E
	 N0CTuNRdrCfRAhw0LAsA+EjN98byZEtHehlxk6gY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGIUmY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jul 2020 16:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgGIUmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 16:42:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91480207F9;
        Thu,  9 Jul 2020 20:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594327343;
        bh=vpCi1modSFDnipJ0cOl931m9ohowJ2vlqV9+7acuAhE=;
        h=Date:From:To:Subject:From;
        b=yMhUWle5dPuTuUkM8TDeR5dLAoiIHmef0o3+7JtWFA+mP+HHtk0ma+wEXcO5zdj+Y
         IJYAJ4Xlr8tyGKHZKOBPYfkV+waQXHOw3ijFpMDC6JDB8c7c7VLOa0Hwof9fEpsu3X
         314uvDkmrZ607aM23eAZIDyHKLF9WOvQf3rCJ85c=
Date:   Thu, 09 Jul 2020 13:42:23 -0700
From:   akpm@linux-foundation.org
To:     amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com,
        dalias@libc.org, geert+renesas@glider.be,
        glaubitz@physik.fu-berlin.de, krzk@kernel.org,
        kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org,
        romain.naour@gmail.com, sam@ravnborg.org,
        ysato@users.sourceforge.jp
Subject:  [merged]
 sh-remove-call-to-memset-after-dma_alloc_coherent.patch removed from -mm
 tree
Message-ID: <20200709204223.UusBwCPjr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200709204223.uz9xZzNAN0Qz_71aiw8KyoVnHZm3ddA3B60bS_lkIu0@z>


The patch titled
     Subject: sh: remove call to memset after dma_alloc_coherent
has been removed from the -mm tree.  Its filename was
     sh-remove-call-to-memset-after-dma_alloc_coherent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Zhou <chenzhou10@huawei.com>
Subject: sh: remove call to memset after dma_alloc_coherent

Function dma_alloc_coherent use in buf already zeroes out memory,
so memset is not needed.

Link: https://marc.info/?l=linux-sh&m=157793031102356
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/consistent.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/sh/mm/consistent.c~sh-remove-call-to-memset-after-dma_alloc_coherent
+++ a/arch/sh/mm/consistent.c
@@ -57,8 +57,6 @@ int __init platform_resource_setup_memor
 		return -ENOMEM;
 	}
 
-	memset(buf, 0, memsize);
-
 	r->flags = IORESOURCE_MEM;
 	r->start = dma_handle;
 	r->end = r->start + memsize - 1;
_

Patches currently in -mm which might be from chenzhou10@huawei.com are


