Return-Path: <SRS0=nxWc=B6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0F0C433E1
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EC46208DB
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 20:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597956924;
	bh=sI8FgSX5Q9pJ5l2DGbqYpG4lunGLzKC1VRj+bg26uwk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1liwxp3PcATGAIdB9rHaBZFTVrqhGiAC5lFs6WxKuaemJSTt7rGgcROUE24rVUHWr
	 yrSBRHXWXquWeOa+/DaG70Y7FTKpHpHoWVc67emjEQxi8CPT7Phj1XMV/Q/m30CQxX
	 P2uHB2+sbeF6gO5wKIw9DWD9maUecQNGL48kdxTs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgHTUzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 16:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgHTUzW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 16:55:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EAA2208B3;
        Thu, 20 Aug 2020 20:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597956921;
        bh=sI8FgSX5Q9pJ5l2DGbqYpG4lunGLzKC1VRj+bg26uwk=;
        h=Date:From:To:Subject:From;
        b=0DMO5HDZoWbkCdWj5lNaCi/6vCgzHEVouh88Ne3HplvqpoHxcmLgHL1raqXvZs+ch
         zWGFxP1Bev2SiJMAsGeyMAgphWlW7wZAshMdMSG7R9Uq+Wf86whh0Uwkjl40m2pI/f
         9BlDdNTtTZz6jdXHGUQQmTb3ZYBMAUQAqZBLWY6s=
Date:   Thu, 20 Aug 2020 13:55:21 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, sfr@canb.auug.org.au,
        song.bao.hua@hisilicon.com
Subject:  +
 =?US-ASCII?Q?mm-gup-dont-permit-users-to-call-get=5Fuser=5Fpages-with-fol?=
 =?US-ASCII?Q?l=5Flongterm-fix.patch?= added to -mm tree
Message-ID: <20200820205521.uBKOuKPSR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix
has been added to the -mm tree.  Its filename is
     mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix

fix CONFIG_MMU=n build

Link: https://lkml.kernel.org/r/CA+G9fYuNS3k0DVT62twfV746pfNhCSrk5sVMcOcQ1PGGnEseyw@mail.gmail.com
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/gup.c~mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix
+++ a/mm/gup.c
@@ -1759,6 +1759,25 @@ static __always_inline long __gup_longte
 }
 #endif /* CONFIG_FS_DAX || CONFIG_CMA */
 
+static bool is_valid_gup_flags(unsigned int gup_flags)
+{
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
+	 * never directly by the caller, so enforce that with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return false;
+	/*
+	 * FOLL_PIN is a prerequisite to FOLL_LONGTERM. Another way of saying
+	 * that is, FOLL_LONGTERM is a specific case, more restrictive case of
+	 * FOLL_PIN.
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_MMU
 static long __get_user_pages_remote(struct mm_struct *mm,
 				    unsigned long start, unsigned long nr_pages,
@@ -1789,25 +1808,6 @@ static long __get_user_pages_remote(stru
 				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
 
-static bool is_valid_gup_flags(unsigned int gup_flags)
-{
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that with an assertion:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
-		return false;
-	/*
-	 * FOLL_PIN is a prerequisite to FOLL_LONGTERM. Another way of saying
-	 * that is, FOLL_LONGTERM is a specific case, more restrictive case of
-	 * FOLL_PIN.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return false;
-
-	return true;
-}
-
 /**
  * get_user_pages_remote() - pin user pages in memory
  * @mm:		mm_struct of target mm
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

