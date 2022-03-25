Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1397C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356865AbiCYBNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357199AbiCYBNk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C40EBD2DE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5C061874
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89DAC340EC;
        Fri, 25 Mar 2022 01:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170726;
        bh=Xs1D3PFLU/IARaxItNCGnqLP9ch4kXt8V+08dZ6BZ9c=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mxyagqCAik+JOPVW2U6U++KRroqD0EJBsYhUjSa32pescmybEuU0mrtrAulMkwzrd
         QeZN/5NeSAL4DGjWXFdIoCzWAD0NmF+N8x+EnlGYa2arBwXlNw0G4LyOmTJepFDwI8
         5XaBX59+p8t5bsppeRX1fqnzMgDNzHZvaYKLV7Go=
Date:   Thu, 24 Mar 2022 18:12:05 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, tangmeng@uniontech.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 070/114] mm/kasan: remove unnecessary CONFIG_KASAN option
Message-Id: <20220325011205.E89DAC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: tangmeng <tangmeng@uniontech.com>
Subject: mm/kasan: remove unnecessary CONFIG_KASAN option

In mm/Makefile has:
obj-$(CONFIG_KASAN)     += kasan/

So that we don't need 'obj-$(CONFIG_KASAN) :=' in mm/kasan/Makefile,
delete it from mm/kasan/Makefile.

Link: https://lkml.kernel.org/r/20220221065421.20689-1-tangmeng@uniontech.com
Signed-off-by: tangmeng <tangmeng@uniontech.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/Makefile~mm-kasan-remove-unnecessary-config_kasan-option
+++ a/mm/kasan/Makefile
@@ -35,7 +35,7 @@ CFLAGS_shadow.o := $(CC_FLAGS_KASAN_RUNT
 CFLAGS_hw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_sw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 
-obj-$(CONFIG_KASAN) := common.o report.o
+obj-y := common.o report.o
 obj-$(CONFIG_KASAN_GENERIC) += init.o generic.o report_generic.o shadow.o quarantine.o
 obj-$(CONFIG_KASAN_HW_TAGS) += hw_tags.o report_hw_tags.o tags.o report_tags.o
 obj-$(CONFIG_KASAN_SW_TAGS) += init.o report_sw_tags.o shadow.o sw_tags.o tags.o report_tags.o
_
