Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEEEC38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjARVPT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjARVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88993611C9
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2225861997
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBB9C433D2;
        Wed, 18 Jan 2023 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076440;
        bh=I5ySkwkss19n+++1VPEWg58ZmJW+shjgn5FNPXuJxag=;
        h=Date:To:From:Subject:From;
        b=mcAsG0Jvi0DWAC7zcd1bBooO2zEG05MiFaXp/GKzDy/5Qy4xHzW3NL7sRfkW0neg/
         8HGZlkzaCWcpHkvgu1BrYmHLSzZbjNv26zjS33Co+oSlVExU9rrvVICWViKve4dHSx
         PFnrVt62bt+ordlM46qd7fjZcFuLD3pFvZojtIic=
Date:   Wed, 18 Jan 2023 13:13:59 -0800
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch added to mm-unstable branch
Message-Id: <20230118211400.7EBB9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2
Date: Wed, 18 Jan 2023 15:52:51 +0000

fix build with CONFIG_PAGE_EXTENSION=n

Link: https://lkml.kernel.org/r/20230118155251.2522985-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/page_ext.h~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2
+++ a/include/linux/page_ext.h
@@ -29,6 +29,8 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
+extern bool deferred_struct_pages;
+
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
@@ -54,7 +56,6 @@ struct page_ext {
 	unsigned long flags;
 };
 
-extern bool deferred_struct_pages;
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch
mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed-v4.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch

