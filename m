Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C20C46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjATEgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjATEgC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:36:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1DFBC8BC
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 999E2B82757
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40618C433EF;
        Thu, 19 Jan 2023 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674163556;
        bh=BGYNVQ95sheMsR/QUk3kuYjQjOU8Z/DPeKijNpm6LVo=;
        h=Date:To:From:Subject:From;
        b=fe69igh9mbeRkO5YXoxp2VUl3KGW54FjSduSlmKQTIun16vibULeVhRsHprBjHHRD
         ra7lc8v/KxfMrH8A9YFF+KFUDJvptPvPxwBU69VDz92FO5BZeD3SgZcUMXk5WDofP9
         oFEPaA/A3APZ9JaJ/KkVnO8226UW3loS2JpXHMcc=
Date:   Thu, 19 Jan 2023 13:25:55 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch added to mm-unstable branch
Message-Id: <20230119212556.40618C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch

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
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3
Date: Thu, 19 Jan 2023 13:39:45 +0100

merge two sentences into one, per Bagas

Link: https://lkml.kernel.org/r/20230119123945.10471-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/highmem.rst~mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3
+++ a/Documentation/mm/highmem.rst
@@ -57,8 +57,8 @@ list shows them in order of preference o
   It can be invoked from any context (including interrupts) but the mappings
   can only be used in the context which acquired them.
 
-  This function should always be used. kmap_atomic() and kmap() have been
-  deprecated.
+  This function should always be used, whereas kmap_atomic() and kmap() have
+  been deprecated.
 
   These mappings are thread-local and CPU-local, meaning that the mapping
   can only be accessed from within this thread and the thread is bound to the
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch
mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch

