Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4452BC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiLLDbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiLLDbP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040A6D136
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E4A60ED6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED089C433F0;
        Mon, 12 Dec 2022 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815873;
        bh=d33rUAT/wlBZ+1akcQrwBKskgBjUXujps7OD6LDzcn0=;
        h=Date:To:From:Subject:From;
        b=yKlU1M+P5KXAnFqUtKK6F3jr39dtMoejXtlLkUGpTFqb7iMEiPqP42xkdDYGT7V4A
         h1hrYklnAqNB8flBPebhakCmczE7kKCiN0q88X4vquqxx52wfaL5JRe8+o1CHx6kcN
         akVHu7aGa1bZjbDAU23UMcrk1yq0Sti251KePjQs=
Date:   Sun, 11 Dec 2022 19:31:12 -0800
To:     mm-commits@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] io-mapping-move-some-code-within-the-include-guarded-section.patch removed from -mm tree
Message-Id: <20221212033112.ED089C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: io-mapping: move some code within the include guarded section
has been removed from the -mm tree.  Its filename was
     io-mapping-move-some-code-within-the-include-guarded-section.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


