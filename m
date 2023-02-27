Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD36C64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 22:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjB0WMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjB0WMv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 17:12:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F9E1B4
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 14:12:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9696B80DC3
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 22:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B81C433D2;
        Mon, 27 Feb 2023 22:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677535967;
        bh=lsNGhRXdQt3iV6lO3RoYA8DG/AbBaXzLoZ51aotmH5c=;
        h=Date:To:From:Subject:From;
        b=KoYR7z92XC+0i/1Jd5OzMtnuC3fCdEkYrCtfG+aGXSY+pFHq+cr/+z0qDm/cIybDU
         hY7fmpyMdM3gZdyLjrPKoN4myYZXhIJZCkGLM5umP0szSrP+pVikH0wN2Wi701hFBE
         QB3M7CYutc+3sju/usW/IGk87eCZCIFoQoZwu+4g=
Date:   Mon, 27 Feb 2023 14:12:46 -0800
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        error27@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dca-delete-unnecessary-variable.patch added to mm-nonmm-unstable branch
Message-Id: <20230227221247.81B81C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dca: delete unnecessary variable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     dca-delete-unnecessary-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dca-delete-unnecessary-variable.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Dan Carpenter <error27@gmail.com>
Subject: dca: delete unnecessary variable
Date: Mon, 27 Feb 2023 13:06:12 +0300

It's more readable to just pass NULL directly instead of using a variable
for that.

Link: https://lkml.kernel.org/r/Y/yAlDytLH0ZNLNz@kili
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/dca/dca-core.c~dca-delete-unnecessary-variable
+++ a/drivers/dca/dca-core.c
@@ -294,9 +294,7 @@ EXPORT_SYMBOL_GPL(dca3_get_tag);
  */
 u8 dca_get_tag(int cpu)
 {
-	struct device *dev = NULL;
-
-	return dca_common_get_tag(dev, cpu);
+	return dca_common_get_tag(NULL, cpu);
 }
 EXPORT_SYMBOL_GPL(dca_get_tag);
 
_

Patches currently in -mm which might be from error27@gmail.com are

dca-delete-unnecessary-variable.patch

