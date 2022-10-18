Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738E1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJRAeg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJRAed (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:34:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5032710D2
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E2660C66
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D423C433D6;
        Tue, 18 Oct 2022 00:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666052601;
        bh=tClS9R1ZVKHlvy6/qIWIOF4ToOBm1ZIz8xGiPHh+iAw=;
        h=Date:To:From:Subject:From;
        b=wiNJzLWLJTqdHhTPjmYQhclVyOQ20dMIpkaLELqfaQaHK/MKz/fsLC9ooHNccBDIe
         IzhIB9NisRAUvV16Jc2vblcQPoKKy88avcSYHaYwAnbBIkfdww6ed1BahQIgGxjTPu
         32rDDmoEqQJOKmlYYXHBvTiUoADWB8jgxUGLWF9Y=
Date:   Mon, 17 Oct 2022 17:23:20 -0700
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typo-in-struct-vm_operations_struct-comments.patch added to mm-unstable branch
Message-Id: <20221018002321.6D423C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typo in struct vm_operations_struct comments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-typo-in-struct-vm_operations_struct-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typo-in-struct-vm_operations_struct-comments.patch

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
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: fix typo in struct vm_operations_struct comments
Date: Fri, 07 Oct 2022 13:37:41 +0200

There is no eprotect(), so I assume this is about mprotect().

Link: https://lkml.kernel.org/r/2385684.8vm7BOzihM@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-fix-typo-in-struct-vm_operations_struct-comments
+++ a/include/linux/mm.h
@@ -549,7 +549,7 @@ struct vm_operations_struct {
 	/*
 	 * Called by mprotect() to make driver-specific permission
 	 * checks before mprotect() is finalised.   The VMA must not
-	 * be modified.  Returns 0 if eprotect() can proceed.
+	 * be modified.  Returns 0 if mprotect() can proceed.
 	 */
 	int (*mprotect)(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, unsigned long newflags);
_

Patches currently in -mm which might be from eb@emlix.com are

mm-fix-typo-in-struct-vm_operations_struct-comments.patch

