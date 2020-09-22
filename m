Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4960C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0B62376F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600796542;
	bh=cvnlgnUIpb5/S+w2F7eNiJsxsv+iGbFyfTLZTctPaeM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=i2UJjRbug7P0g//uosWehxqcQ+hS+CoPzM8t7nlVytFVJVSiuNmoIFxV3zZC75D5c
	 CKvg0qr0g+fj1tF8yQN1YiDLu6uotZOYWgrWQJN2tfITQaIjc5HCJbsyt2qg7EgTjJ
	 SYUzxPg9dahY1sUCZvNpg9sB64SZqv5LTcermAiM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIVRmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgIVRmW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:42:22 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15EA1235FD;
        Tue, 22 Sep 2020 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796541;
        bh=cvnlgnUIpb5/S+w2F7eNiJsxsv+iGbFyfTLZTctPaeM=;
        h=Date:From:To:Subject:From;
        b=epxcsMh03nMS+CKlRGJzw6F3sFObT7dRYgoPFHb6gNLSGCeTbqlTrXNLwAvcypvL2
         uPxGxmJqlO7UIuCNvPDfm76H0XRBda74gyuuJUkVncAJRa1KU5kyCnnx4Ed7QgjXSz
         kV1RUIJsez/m4okR2jywzS8OzVoxxZ017nBxpTyo=
Date:   Tue, 22 Sep 2020 10:42:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, OSalvador@suse.com,
        n-horiguchi@ah.jp.nec.com, mateusznosek0@gmail.com
Subject:  +
 mm-page_poisonc-replace-bool-variable-with-static-key.patch added to -mm tree
Message-ID: <20200922174220.9oCTV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison.c: replace bool variable with static key
has been added to the -mm tree.  Its filename is
     mm-page_poisonc-replace-bool-variable-with-static-key.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poisonc-replace-bool-variable-with-static-key.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poisonc-replace-bool-variable-with-static-key.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slabc-clean-code-by-removing-redundant-if-condition.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-page_allocc-fix-early-params-garbage-value-accesses.patch
mm-page_allocc-clean-code-by-merging-two-functions.patch
mmzone-clean-code-by-removing-unused-macro-parameter.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch
include-linux-compactionh-clean-code-by-removing-unused-enum-value.patch
mm-page_poisonc-replace-bool-variable-with-static-key.patch

