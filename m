Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F04CC43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DBD620770
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600296221;
	bh=NsLrvLo0wFnVS5HNSE9CIl4M/4Wnd+GHbwUU96657vk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uOGpgYOur9DB2X5+zwfgmzVrsrTSgMeGN9akGzIj+VsBnA2yOBAcHZjDeHzfwp9x5
	 yzj/8S3GZos1Zxs2RrZysnI/7mWzMKIFwsj5j2nZVsJNdMmqVq/6XFJRMOlA/8VKYS
	 msBY+3VUw13HFmQA5utTRxasKXi4we+G+0u0JhC0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgIPWnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgIPWnk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:43:40 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CAE220770;
        Wed, 16 Sep 2020 22:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600296219;
        bh=NsLrvLo0wFnVS5HNSE9CIl4M/4Wnd+GHbwUU96657vk=;
        h=Date:From:To:Subject:From;
        b=cEWnHP9dFVs93LmS4I+bRAcbQMXMk0JS2MfDVbekxr9EjqQyIVspOGfEhtdKjhAgQ
         tu0TTbN8OjRlIxOnM+6qS/nL12VbtOXJS7sTpTfnHnijbMlFzqW99zE7jMDzfugM/W
         vk0OF04XX0tMLhbmyeyifo2YntioSnqgEvEf+JPA=
Date:   Wed, 16 Sep 2020 15:43:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        mateusznosek0@gmail.com
Subject:  +
 mm-page_allocc-fix-early-params-garbage-value-accesses.patch added to -mm
 tree
Message-ID: <20200916224338.h89qI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix early params garbage value accesses
has been added to the -mm tree.  Its filename is
     mm-page_allocc-fix-early-params-garbage-value-accesses.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-fix-early-params-garbage-value-accesses.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-fix-early-params-garbage-value-accesses.patch

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
Subject: mm/page_alloc.c: fix early params garbage value accesses

Previously in '__init early_init_on_alloc' and '__init early_init_on_free'
the return values from 'kstrtobool' were not handled properly.  That
caused potential garbage value read from variable 'bool_result'. 
Introduced patch fixes error handling.

Link: https://lkml.kernel.org/r/20200916214125.28271-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-fix-early-params-garbage-value-accesses
+++ a/mm/page_alloc.c
@@ -155,16 +155,16 @@ static int __init early_init_on_alloc(ch
 	int ret;
 	bool bool_result;
 
-	if (!buf)
-		return -EINVAL;
 	ret = kstrtobool(buf, &bool_result);
+	if (ret)
+		return ret;
 	if (bool_result && page_poisoning_enabled())
 		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, will take precedence over init_on_alloc\n");
 	if (bool_result)
 		static_branch_enable(&init_on_alloc);
 	else
 		static_branch_disable(&init_on_alloc);
-	return ret;
+	return 0;
 }
 early_param("init_on_alloc", early_init_on_alloc);
 
@@ -173,16 +173,16 @@ static int __init early_init_on_free(cha
 	int ret;
 	bool bool_result;
 
-	if (!buf)
-		return -EINVAL;
 	ret = kstrtobool(buf, &bool_result);
+	if (ret)
+		return ret;
 	if (bool_result && page_poisoning_enabled())
 		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, will take precedence over init_on_free\n");
 	if (bool_result)
 		static_branch_enable(&init_on_free);
 	else
 		static_branch_disable(&init_on_free);
-	return ret;
+	return 0;
 }
 early_param("init_on_free", early_init_on_free);
 
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-slabc-clean-code-by-removing-redundant-if-condition.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
mm-page_allocc-micro-optimization-remove-unnecessary-branch.patch
mm-page_allocc-fix-early-params-garbage-value-accesses.patch
mm-compactionc-micro-optimization-remove-unnecessary-branch.patch

