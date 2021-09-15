Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3539C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D9261242
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhIODft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhIODft (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B00DE61216;
        Wed, 15 Sep 2021 03:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631676870;
        bh=Q6WH+c49S22egmi3FXEZR60MPBFwkaZguj2JIuCtDnQ=;
        h=Date:From:To:Subject:From;
        b=ELcCfeEk/g2DaZ05wmx49wNOfbpkAdtbjiKgvDqrYQvP2HibdrgjVIRBc6OP/Cu2e
         ILXmbURObQKbC18eBBSiwppxJmFJfH167gwSnJr34ALWL/oX5qY5Gc0wIeXEkgselA
         Ajnuw4/e1WOJpHUqHjT3NCXg/xbp0p7FrZ5ijkqM=
Date:   Tue, 14 Sep 2021 20:34:30 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, tangyizhou@huawei.com
Subject:  +
 mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch added
 to -mm tree
Message-ID: <20210915033430.PRtbKCa-C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: add static qualifier for online_policy_to_str()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Yizhou <tangyizhou@huawei.com>
Subject: mm/memory_hotplug: add static qualifier for online_policy_to_str()

online_policy_to_str is only used in memory_hotplug.c and should be
defined as static.

Link: https://lkml.kernel.org/r/20210913024534.26161-1-tangyizhou@huawei.com
Signed-off-by: Tang Yizhou <tangyizhou@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str
+++ a/mm/memory_hotplug.c
@@ -57,7 +57,7 @@ enum {
 	ONLINE_POLICY_AUTO_MOVABLE,
 };
 
-const char *online_policy_to_str[] = {
+static const char * const online_policy_to_str[] = {
 	[ONLINE_POLICY_CONTIG_ZONES] = "contig-zones",
 	[ONLINE_POLICY_AUTO_MOVABLE] = "auto-movable",
 };
_

Patches currently in -mm which might be from tangyizhou@huawei.com are

mm-memory_hotplug-add-static-qualifier-for-online_policy_to_str.patch

