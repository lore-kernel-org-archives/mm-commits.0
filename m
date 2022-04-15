Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1018C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 01:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbiDOCAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245404AbiDOCAF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:00:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A890B18A0
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 18:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D204B82BE8
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 01:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6ABC385A7;
        Fri, 15 Apr 2022 01:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649987856;
        bh=O0HZ7uzyausOhMQF9MuNy9xSaIDnmGiFqEFzgWhuwPc=;
        h=Date:To:From:Subject:From;
        b=M2E3ly/Bw5neGC9po90P4ou9Tlmq80CUvQiD1L2an+IMNwErUtZUqBOPG7new5xjs
         qLUISvHRNRy+Yhf5uSf0oC3xJQ7h89mPoVYe39JU7qRi4IevNp4JISrGIoMq9xkzb4
         XWQM7J/7A76U6dmXz9HkXzNVpHoCrxjtkz/E2sEI=
Date:   Thu, 14 Apr 2022 18:57:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch removed from -mm tree
Message-Id: <20220415015736.9B6ABC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2
has been removed from the -mm tree.  Its filename was
     mm-secretmem-fix-panic-when-growing-a-memfd_secret-v2.patch

This patch was dropped because it was folded into mm-secretmem-fix-panic-when-growing-a-memfd_secret.patch

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

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

