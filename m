Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740D5C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjASBUf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjASBS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416EE6C579
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4DF61AC3
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62FCC433F0;
        Thu, 19 Jan 2023 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090970;
        bh=6zsP5F7XHB+0/gwZjzM80DmxfBEnS8FvEc+R0/Xncdo=;
        h=Date:To:From:Subject:From;
        b=FrAXLPisUW8klSqq3Pc7jPemtmhG8G//dnENp+92/moZYKFzuIJftcR+qIqQjEAbI
         caYDFGCZ+Yb3kqFoSjyWge/WNwSSjKrG1nQwg+J5xz5pdPLVD2mNTLW59/kKFCUpa1
         IHS1Z5jSI9lZdzaOiMxu78hcoqrcMEbudGLyZ3mk=
Date:   Wed, 18 Jan 2023 17:16:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-two-spelling-mistakes-in-highmemh.patch removed from -mm tree
Message-Id: <20230119011610.B62FCC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix spelling mistake in highmem.h
has been removed from the -mm tree.  Its filename was
     mm-fix-two-spelling-mistakes-in-highmemh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm: fix spelling mistake in highmem.h
Date: Thu, 5 Jan 2023 13:13:05 +0100

Substitute "higmem" with "highmem" in highmem.h.

Link: https://lkml.kernel.org/r/20230105121305.30714-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-fix-two-spelling-mistakes-in-highmemh
+++ a/include/linux/highmem.h
@@ -86,8 +86,8 @@ static inline void kmap_flush_unused(voi
  * virtual address of the direct mapping. Only real highmem pages are
  * temporarily mapped.
  *
- * While it is significantly faster than kmap() for the higmem case it
- * comes with restrictions about the pointer validity.
+ * While kmap_local_page() is significantly faster than kmap() for the highmem
+ * case it comes with restrictions about the pointer validity.
  *
  * On HIGHMEM enabled systems mapping a highmem page has the side effect of
  * disabling migration in order to keep the virtual address stable across
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

