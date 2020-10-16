Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D68C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8580B2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817656;
	bh=xpXPDpeE3/rHojd9mUjsMMSFe4tvsjCi+aVLTbie/hk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gvL7R993gm3c+Vn5OqIYp69XwifZr7NauONXL9iZjFhE2bp/o/CtIR+D6V75Xl80P
	 7l6cbtVmFgFC3mcWLgsNwPko0IWxSZS6wxWumxB3b5EgDQUWz8GWMlaSfLtBTStRr/
	 jOLYrYCoy6SHMLqZuVQ2hCFnB/WAlHhJhhp41OlM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgJPDHg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDHg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:07:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF65720789;
        Fri, 16 Oct 2020 03:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817654;
        bh=xpXPDpeE3/rHojd9mUjsMMSFe4tvsjCi+aVLTbie/hk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sbCi0TaFQNkuq+hmnrDaiA0YZFEz4uvlMQ30gMyq3QHTqExZMIcmwO6s3f4CJd1pB
         gBjKHzOatJV66ueaiF4reYGNBxm20qFsTMSYZI6NM7svumlrS0epN6V/VEjqcfERBG
         rYdeC17J/KXizX34zFtV3+J6c/LON6JCxYZeWp8M=
Date:   Thu, 15 Oct 2020 20:07:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        OSalvador@suse.com, torvalds@linux-foundation.org
Subject:  [patch 055/156] mm/page_poison.c: replace bool variable
 with static key
Message-ID: <20201016030733.VvmHVrV38%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
