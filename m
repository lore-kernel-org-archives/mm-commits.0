Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34D4C00A5A
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 01:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjARBGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjARBGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 20:06:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDEC460A0
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 16:54:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D638B81A90
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 00:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FF7C433EF;
        Wed, 18 Jan 2023 00:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674003287;
        bh=5pECDjkxRMdAEewtz9ThNPm9JfyjAwGOUs7/7AQpJkA=;
        h=Date:To:From:Subject:From;
        b=hhqmht6/5IxvLi3WlrEgDFlJer5b1F+lH1KFQlobkY6mOkfKZcEkMIeOsgitkhW+K
         4WcMLA8X8oI9IEJrJk7iHlNg62UcHCXy/oENnC4rdmBbtjm1glfF4WCYXTfFApRvNb
         EeN6x19Dfi/7vrO6u5CvYmTyn72MV7xG8swWjfTE=
Date:   Tue, 17 Jan 2023 16:54:47 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230118005447.B4FF7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: avoid unused-function warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: zsmalloc: avoid unused-function warning
Date: Tue, 17 Jan 2023 18:04:59 +0100

obj_allocated() can be called from two places that are each inside of an
#ifdef.  When both are disabled, the compiler warns:

mm/zsmalloc.c:900:13: error: 'obj_allocated' defined but not used [-Werror=unused-function]

Rather than trying to figure out the correct #ifdef, mark the trivial
function as 'inline', which implies __maybe_unused and shuts up the
warning.

Link: https://lkml.kernel.org/r/20230117170507.2651972-1-arnd@kernel.org
Fixes: 796c71ac728e ("zsmalloc: fix a race with deferred_handles storing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-fix-a-race-with-deferred_handles-storing-fix
+++ a/mm/zsmalloc.c
@@ -937,7 +937,7 @@ static bool obj_tagged(struct page *page
 	return true;
 }
 
-static bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
+static inline bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
 {
 	return obj_tagged(page, obj, phandle, OBJ_ALLOCATED_TAG);
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

zsmalloc-fix-a-race-with-deferred_handles-storing-fix.patch

