Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28A7C77B73
	for <mm-commits@archiver.kernel.org>; Thu, 20 Apr 2023 22:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjDTWha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Apr 2023 18:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjDTWh1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2023 18:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256BB13E
        for <mm-commits@vger.kernel.org>; Thu, 20 Apr 2023 15:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6312F64C60
        for <mm-commits@vger.kernel.org>; Thu, 20 Apr 2023 22:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9E4C433EF;
        Thu, 20 Apr 2023 22:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682030243;
        bh=4qZQgGtSf7KDj8YNH7yaqYLO5o+cjrSVrI27AY4QgM8=;
        h=Date:To:From:Subject:From;
        b=yc2bQgEf3IaRqHx86CGlMHzjGpXh86hn5hS669Tsd1wOuYJ34xcZaGPjyMvDn3zO2
         +QP4vE+3y2UmiGWOBEAosW5+Tc3xl/XiHIveW8g80w7AJc7D40YkNEqNGM/z0Z0HQN
         2YvX6YmkOzUPAc3Qstj5TrZ9Ka6d4SAuSVq/U5lQ=
Date:   Thu, 20 Apr 2023 15:37:23 -0700
To:     mm-commits@vger.kernel.org, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparse-remove-unnecessary-0-values-from-rc.patch added to mm-unstable branch
Message-Id: <20230420223723.BA9E4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: : sparse: remove unnecessary 0 values from rc
has been added to the -mm mm-unstable branch.  Its filename is
     sparse-remove-unnecessary-0-values-from-rc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparse-remove-unnecessary-0-values-from-rc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: : sparse: remove unnecessary 0 values from rc
Date: Sat, 22 Apr 2023 05:47:33 +0800

rc is assigned first, so it does not need to initialize the
assignment.

Link: https://lkml.kernel.org/r/20230421214733.2909-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~sparse-remove-unnecessary-0-values-from-rc
+++ a/mm/sparse.c
@@ -832,7 +832,7 @@ static struct page * __meminit section_a
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	int rc = 0;
+	int rc;
 
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
_

Patches currently in -mm which might be from zeming@nfschina.com are

sparse-remove-unnecessary-0-values-from-rc.patch

