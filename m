Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D641FC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbjDFCtG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbjDFCsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2870A241
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2C5A642AA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A3C433EF;
        Thu,  6 Apr 2023 02:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749142;
        bh=Bfwknkv5v8WrhVc9UcvmLtmVeZwGnp9SFf99PkYgOgk=;
        h=Date:To:From:Subject:From;
        b=kEYpu7afmzIE7WfRmV8hLj09MEhZSvTKXHZXGxK3cnBuTxDoShLksu46J5yxY9pxa
         8aNESLnJClasrb5JkOsuGdzyjftlVQDpiO78UzsY1fUevW7NAR8TVoE+iK21CWbkzq
         NR/IHPuImt1s5RVN5nBw7HCUdB4413N4RSBDWUdM=
Date:   Wed, 05 Apr 2023 19:45:41 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        jschoenh@amazon.de, david@redhat.com, krckatom@amazon.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-be-less-noisy-during-memory-hotplug.patch removed from -mm tree
Message-Id: <20230406024542.429A3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: be less noisy during memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-be-less-noisy-during-memory-hotplug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tomas Krcka <krckatom@amazon.de>
Subject: mm: be less noisy during memory hotplug
Date: Thu, 23 Mar 2023 17:43:49 +0000

Turn a pr_info() into a pr_debug() to prevent dmesg spamming on systems
where memory hotplug is a frequent operation.

Link: https://lkml.kernel.org/r/20230323174349.35990-1-krckatom@amazon.de
Signed-off-by: Tomas Krcka <krckatom@amazon.de>
Suggested-by: Jan H. Schönherr <jschoenh@amazon.de>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-be-less-noisy-during-memory-hotplug
+++ a/mm/mm_init.c
@@ -1086,7 +1086,7 @@ void __ref memmap_init_zone_device(struc
 				     compound_nr_pages(altmap, pfns_per_compound));
 	}
 
-	pr_info("%s initialised %lu pages in %ums\n", __func__,
+	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
 #endif
_

Patches currently in -mm which might be from krckatom@amazon.de are


