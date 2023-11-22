Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAAFC61D97
	for <mm-commits@archiver.kernel.org>; Wed, 22 Nov 2023 18:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjKVSar (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Nov 2023 13:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343790AbjKVSal (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Nov 2023 13:30:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD86D1AE
        for <mm-commits@vger.kernel.org>; Wed, 22 Nov 2023 10:30:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C7BC433C7;
        Wed, 22 Nov 2023 18:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700677837;
        bh=H6f800SRwTEuAGOt2UMRqCqxBnnrJV/YlKQGQ7cDba8=;
        h=Date:To:From:Subject:From;
        b=ZK8DYgV0HEe1cLeuvDp84qY0PXISy5CUj/DSEM3EBNCRIkt5T8Vc6QJomT8hveVS1
         9tiIoFN+JYLljpo7Kuz1MfX3OV6rnUoeiWw9Ka8h37sfDsBEruE1GJIxUVkRr+iElA
         Mi4TePdbWOfpDTuZkebkGIQTmv1WFurcGsla2qdg=
Date:   Wed, 22 Nov 2023 10:30:36 -0800
To:     mm-commits@vger.kernel.org, fancer.lancer@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-extend-init-unavailable-range-doc-info.patch added to mm-unstable branch
Message-Id: <20231122183037.33C7BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: extend init unavailable range doc info
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-extend-init-unavailable-range-doc-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-extend-init-unavailable-range-doc-info.patch

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
From: Serge Semin <fancer.lancer@gmail.com>
Subject: mm/mm_init.c: extend init unavailable range doc info
Date: Wed, 22 Nov 2023 21:24:03 +0300

Besides of the already described reasons the pages backended memory holes
might be persistent due to having memory mapped IO spaces behind those
ranges in the framework of flatmem kernel config.  Add such note to the
init_unavailable_range() method kdoc in order to point out to one more
reason of having the function executed for such regions.

Link: https://lkml.kernel.org/r/20231122182419.30633-6-fancer.lancer@gmail.com
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mm_init.c~mm-mm_initc-extend-init-unavailable-range-doc-info
+++ a/mm/mm_init.c
@@ -796,6 +796,7 @@ overlap_memmap_init(unsigned long zone,
  * - physical memory bank size is not necessarily the exact multiple of the
  *   arbitrary section size
  * - early reserved memory may not be listed in memblock.memory
+ * - memory mapped IO space
  * - memory layouts defined with memmap= kernel parameter may not align
  *   nicely with memmap sections
  *
_

Patches currently in -mm which might be from fancer.lancer@gmail.com are

mm-mm_initc-extend-init-unavailable-range-doc-info.patch
mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

