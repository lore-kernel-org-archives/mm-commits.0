Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DA6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 19:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiDLT74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 15:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiDLT7s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 15:59:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA53D6E545
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 12:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 569C9B81FFB
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 19:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E896EC385A5;
        Tue, 12 Apr 2022 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649793116;
        bh=0D91pw8wV4HyHagM8V9D3rzLYE0qZvR6FlHmC8GwZPQ=;
        h=Date:To:From:Subject:From;
        b=sWqiwWUVViMqzVTaKkUA7Is3gzQrBqHSnCQhYgZpuneVCOR2Hb04yhX8mpjaX8RJk
         FXF7pwTHLXsfbXz7drVO2108eAIolLyRGZ4l+FnHB+3BiT6lrlhzjmhLq6M96eHInc
         7PwCHnz5ffbUF2eZJfCCP76OylN00Lco71oGm2Xk=
Date:   Tue, 12 Apr 2022 12:51:55 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch added to -mm tree
Message-Id: <20220412195155.E896EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2
has been added to the -mm tree.  Its filename is
     mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2

return EINVAL

Link: https://lkml.kernel.org/r/20220412193023.279320-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/secretmem.c~mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2
+++ a/mm/secretmem.c
@@ -165,7 +165,7 @@ static int secretmem_setattr(struct user
 	unsigned int ia_valid = iattr->ia_valid;
 
 	if ((ia_valid & ATTR_SIZE) && inode->i_size)
-		return -EOPNOTSUPP;
+		return -EINVAL;
 
 	return simple_setattr(mnt_userns, dentry, iattr);
 }
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-secretmem-fix-panic-when-growing-a-memfd_secret.patch
mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch

