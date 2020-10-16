Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D552AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8056221655
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881394;
	bh=cZaHfF9aO4mgdHHZ5Ddj5W2xhzlp/YmGP1qMOxtb0Z4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Yhqhna3DaoHkWlHbgxqHkyCma2ZKoro5ML7eaykNG9hsreKpKEPfTj8RneqQStRaC
	 rAzWdhqEsxjOaY3D7Ahfkw0jLnh7eNv7rfN03hrZXRinZ0in4tVL9y1npuXcxZtsgZ
	 YVEwp9jMTwDz3/ZCOrq7PdU9Q0lyqzjuqkk3iy8o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392728AbgJPUty (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUty (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E72AC214DB;
        Fri, 16 Oct 2020 20:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881393;
        bh=cZaHfF9aO4mgdHHZ5Ddj5W2xhzlp/YmGP1qMOxtb0Z4=;
        h=Date:From:To:Subject:From;
        b=cnftEqU5+MLh6mqAsn/JdXD0EuVSlkV6CBOLlDWCi0SeMyNxqLoqOtNPcsYlizEqd
         aCmBMqHoQT6cTPlNlB4VCthNZPnY9nomDt3JQ01Ed1uQ6ALtfHFdp3v6aPmtpCPpRY
         2UI9cxkyJSLmRi9JOWw3zYm0ido+8Vbdqgor2tSQ=
Date:   Fri, 16 Oct 2020 13:49:52 -0700
From:   akpm@linux-foundation.org
To:     mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, OSalvador@suse.com
Subject:  [merged]
 mm-page_poisonc-replace-bool-variable-with-static-key.patch removed from
 -mm tree
Message-ID: <20201016204952.B3gJxNcKw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison.c: replace bool variable with static key
has been removed from the -mm tree.  Its filename was
     mm-page_poisonc-replace-bool-variable-with-static-key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_poison.c: replace bool variable with static key

Variable 'want_page_poisoning' is a switch deciding if page poisoning
should be enabled.  This patch changes it to be static key.

Link: https://lkml.kernel.org/r/20200921152931.938-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oscar Salvador <OSalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/page_poison.c~mm-page_poisonc-replace-bool-variable-with-static-key
+++ a/mm/page_poison.c
@@ -8,13 +8,23 @@
 #include <linux/ratelimit.h>
 #include <linux/kasan.h>
 
-static bool want_page_poisoning __read_mostly;
+static DEFINE_STATIC_KEY_FALSE_RO(want_page_poisoning);
 
 static int __init early_page_poison_param(char *buf)
 {
-	if (!buf)
-		return -EINVAL;
-	return strtobool(buf, &want_page_poisoning);
+	int ret;
+	bool tmp;
+
+	ret = strtobool(buf, &tmp);
+	if (ret)
+		return ret;
+
+	if (tmp)
+		static_branch_enable(&want_page_poisoning);
+	else
+		static_branch_disable(&want_page_poisoning);
+
+	return 0;
 }
 early_param("page_poison", early_page_poison_param);
 
@@ -31,7 +41,7 @@ bool page_poisoning_enabled(void)
 	 * Page poisoning is debug page alloc for some arches. If
 	 * either of those options are enabled, enable poisoning.
 	 */
-	return (want_page_poisoning ||
+	return (static_branch_unlikely(&want_page_poisoning) ||
 		(!IS_ENABLED(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) &&
 		debug_pagealloc_enabled()));
 }
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are


