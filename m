Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F06AC43217
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiK1WoA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbiK1Wn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:43:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2030629354
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB1DB8102B
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D239C433D6;
        Mon, 28 Nov 2022 22:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669675436;
        bh=9SWgCRQFBWVu6RTRUWuGWKLfNzDBTRErYS/WMYjwYY4=;
        h=Date:To:From:Subject:From;
        b=nk4XAXbFVQcGIV9vqzSTO6NkQcYeZ5eMJUVB4cPz7Pwl51phcwlBkBZEfDMfToIvY
         9BdxTeDmLKsjInwCV1nPvmVrEZuDTRL/UyFV3V+LYIkXHTiLZ9SqwjBwF0KttwXRd3
         5AoolHgu6mINGZ3cOJqjvenSflbycOQybQSoKm/s=
Date:   Mon, 28 Nov 2022 14:43:55 -0800
To:     mm-commits@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + io-mapping-move-some-code-within-the-include-guarded-section.patch added to mm-nonmm-unstable branch
Message-Id: <20221128224356.6D239C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: io-mapping: move some code within the include guarded section
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     io-mapping-move-some-code-within-the-include-guarded-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/io-mapping-move-some-code-within-the-include-guarded-section.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: io-mapping: move some code within the include guarded section
Date: Sun, 27 Nov 2022 17:07:32 +0100

It is spurious to have some code out-side the include guard in a .h file. 
Fix it.

Link: https://lkml.kernel.org/r/4dbaf427d4300edba6c6bbfaf4d57493b9bec6ee.1669565241.git.christophe.jaillet@wanadoo.fr
Fixes: 1fbaf8fc12a0 ("mm: add a io_mapping_map_user helper")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/io-mapping.h~io-mapping-move-some-code-within-the-include-guarded-section
+++ a/include/linux/io-mapping.h
@@ -213,7 +213,7 @@ io_mapping_free(struct io_mapping *iomap
 	kfree(iomap);
 }
 
-#endif /* _LINUX_IO_MAPPING_H */
-
 int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, unsigned long size);
+
+#endif /* _LINUX_IO_MAPPING_H */
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

mm-damon-use-kstrtobool-instead-of-strtobool.patch
mm-use-kstrtobool-instead-of-strtobool.patch
io-mapping-move-some-code-within-the-include-guarded-section.patch

