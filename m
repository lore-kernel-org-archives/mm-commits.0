Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22B1C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 17:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiD0R2o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 13:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244004AbiD0R2o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 13:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EAA5A099
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 10:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4277B826BD
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 17:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71463C385A9;
        Wed, 27 Apr 2022 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651080329;
        bh=XX6fda4sYhZjlVwt2gNnpLLIigxo52I1TDDLXOf0sTc=;
        h=Date:To:From:Subject:From;
        b=rMtEljnFQL+qBjILwiFehYARkBmU2a1sT75lgP55R0dMMjOO/N3j37Bv71scswrF6
         VqdDCZ6F6moNBc0DTpZw5XQlkt+QIDs3yIfbRc+clRrOvZD0/ktr81EB2/ZfkUZ8Q4
         xCkQqNsLJt0xZ+uJD9pMrmuZUbrvn4OvFVrWE+CE=
Date:   Wed, 27 Apr 2022 10:25:28 -0700
To:     mm-commits@vger.kernel.org, seakeel@gmail.com,
        hanshenghong2019@email.szu.edu.cn, corbet@lwn.net,
        baihaowen@meizu.com, akiyks@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-vm-page_owner-use-literal-blocks-for-param-description.patch added to -mm tree
Message-Id: <20220427172529.71463C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: vm/page_owner: Use literal blocks for param description
has been added to the -mm tree.  Its filename is
     docs-vm-page_owner-use-literal-blocks-for-param-description.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-page_owner-use-literal-blocks-for-param-description.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-page_owner-use-literal-blocks-for-param-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akira Yokosawa <akiyks@gmail.com>
Subject: docs: vm/page_owner: Use literal blocks for param description

Sphinx generates hard-to-read lists of parameters at the bottom of the
page.  Fix them by putting literal-block markers of "::" in front of them.

Link: https://lkml.kernel.org/r/cfd3bcc0-b51d-0c68-c065-ca1c4c202447@gmail.com
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 57f2b54a9379 ("Documentation/vm/page_owner.rst: update the documentation")
Cc: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alex Shi <seakeel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-page_owner-use-literal-blocks-for-param-description
+++ a/Documentation/vm/page_owner.rst
@@ -110,7 +110,7 @@ Usage
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
    The detailed parameters are:
 
-   fundamental function:
+   fundamental function::
 
 	Sort:
 		-a		Sort by memory allocation time.
@@ -122,7 +122,7 @@ Usage
 		-s		Sort by stack trace.
 		-t		Sort by times (default).
 
-   additional function:
+   additional function::
 
 	Cull:
 		--cull <rules>
@@ -153,6 +153,7 @@ Usage
 
 STANDARD FORMAT SPECIFIERS
 ==========================
+::
 
 	KEY		LONG		DESCRIPTION
 	p		pid		process ID
_

Patches currently in -mm which might be from akiyks@gmail.com are

docs-vm-page_owner-use-literal-blocks-for-param-description.patch

