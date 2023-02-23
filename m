Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAD2C64ED8
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 21:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBWVCI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBWVCH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 16:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141321554F
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 13:02:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B901B81B2D
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 21:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13722C4339B;
        Thu, 23 Feb 2023 21:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677186123;
        bh=WT8aT808LbI7FeMVQGQIJ68gxO3S4Wx6eBBdmlN2EYs=;
        h=Date:To:From:Subject:From;
        b=DS3z0VeXyEteDPkgC8Fe0T9axW+8iZNvMd3FOR/KtayhdUNZHXeNQKAJ34Q6r12ZB
         BxiGOz5Sy3hQmxrhLdNv9MRkX+ZqsPVROvE/L5Ze5ny5QoaWyuN/i0u4H7kIWeLNKm
         xyouJhGEbC8bn5dJJnnrRHDErI3m1CDog4czmom0=
Date:   Thu, 23 Feb 2023 13:02:02 -0800
To:     mm-commits@vger.kernel.org, wedsonaf@google.com,
        gregkh@linuxfoundation.org, linux@weissschuh.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-make-kobj_type-structure-constant.patch added to mm-unstable branch
Message-Id: <20230223210203.13722C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: make kobj_type structure constant
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-make-kobj_type-structure-constant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-make-kobj_type-structure-constant.patch

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
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: mm: cma: make kobj_type structure constant
Date: Mon, 20 Feb 2023 23:23:31 +0000

Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.") the
driver core allows the usage of const struct kobj_type.

Take advantage of this to constify the structure definition to prevent
modification at runtime.

Link: https://lkml.kernel.org/r/20230220-kobj_type-mm-cma-v1-1-45996cff1a81@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Wedson Almeida Filho <wedsonaf@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma_sysfs.c~mm-cma-make-kobj_type-structure-constant
+++ a/mm/cma_sysfs.c
@@ -64,7 +64,7 @@ static struct attribute *cma_attrs[] = {
 };
 ATTRIBUTE_GROUPS(cma);
 
-static struct kobj_type cma_ktype = {
+static const struct kobj_type cma_ktype = {
 	.release = cma_kobj_release,
 	.sysfs_ops = &kobj_sysfs_ops,
 	.default_groups = cma_groups,
_

Patches currently in -mm which might be from linux@weissschuh.net are

mm-cma-make-kobj_type-structure-constant.patch

