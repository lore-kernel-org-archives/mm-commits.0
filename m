Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53558C77B75
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243628AbjEOTpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243499AbjEOTpx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11BADC58
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D8BA631E6
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EAEC433EF;
        Mon, 15 May 2023 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684179950;
        bh=al7VYuWXokPVr986Dkdv8Gzd687omsh0mAWk7lLsR5Q=;
        h=Date:To:From:Subject:From;
        b=udnpt2RX9VDl7p8yZF5i4ohNWOlhHnfd0/TLpuqThutor3B9qCi0QIAVesSNMbNdw
         yv2n3D3ovSmilvBDrXlBvv6Pj3RQRjLkYAid9NPPQ33jE0z/rnytuhdS9Hoadh3nrE
         THVd7jWCFnn/DXDFN17hV766heeinVncnQu4ktVA=
Date:   Mon, 15 May 2023 12:45:49 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-make-it-on-by-default.patch added to mm-unstable branch
Message-Id: <20230515194550.C3EAEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: make it on by default
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-make-it-on-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-make-it-on-by-default.patch

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

mm-secretmem-make-it-on-by-default.patch

