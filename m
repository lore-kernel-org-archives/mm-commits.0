Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C417AC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbjFIX22 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjFIX1s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A92C3AB4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AD2863E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE3C433EF;
        Fri,  9 Jun 2023 23:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353253;
        bh=F0Hhld/eSvvVJt9aebBNSd/4JF3fn8Q6IpbL+5Nbn50=;
        h=Date:To:From:Subject:From;
        b=gfc1KuCBUp41/H94LovCn4FGVc9AfJGwfU3x2JrZ7YFXkCyb1HlBgfjc5UlyKTdqx
         eaPjfhMGtl6SUHdMyYQRK/9s87YN0U5uN10NfJ5/4y6dyDvjLYVDkfuhePcBu97T4W
         v8iXLQbG2FzhzHTseaH2nfamfrODAwQK3zKFmfDU=
Date:   Fri, 09 Jun 2023 16:27:33 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-secretmem-make-it-on-by-default.patch removed from -mm tree
Message-Id: <20230609232733.CEAE3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/secretmem: make it on by default
has been removed from the -mm tree.  Its filename was
     mm-secretmem-make-it-on-by-default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/secretmem: make it on by default
Date: Mon, 15 May 2023 11:34:00 +0300

Following the discussion about direct map fragmentaion at LSF/MM [1], it
appears that direct map fragmentation has a negligible effect on kernel
data accesses.  Since the only reason that warranted secretmem to be
disabled by default was concern about performance regression caused by the
direct map fragmentation, it makes perfect sense to lift this restriction
and make secretmem enabled.

secretmem obeys RLIMIT_MEMBLOCK and as such it is not expected to cause
large fragmentation of the direct map or meaningfull increase in page
tables allocated during split of the large mappings in the direct map.

The secretmem.enable parameter is retained to allow system administrators
to disable secretmem at boot.

Switch the default setting of secretmem.enable parameter to 1.

Link: https://lwn.net/Articles/931406/ [1]
Link: https://lkml.kernel.org/r/20230515083400.3563974-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-make-it-on-by-default
+++ a/mm/secretmem.c
@@ -35,7 +35,7 @@
 #define SECRETMEM_MODE_MASK	(0x0)
 #define SECRETMEM_FLAGS_MASK	SECRETMEM_MODE_MASK
 
-static bool secretmem_enable __ro_after_init;
+static bool secretmem_enable __ro_after_init = 1;
 module_param_named(enable, secretmem_enable, bool, 0400);
 MODULE_PARM_DESC(secretmem_enable,
 		 "Enable secretmem and memfd_secret(2) system call");
_

Patches currently in -mm which might be from rppt@kernel.org are


