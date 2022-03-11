Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865BEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 01:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbiCKBxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 20:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345464AbiCKBxo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 20:53:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7421AA00B
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 17:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D18461E47
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 01:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C907AC340E8;
        Fri, 11 Mar 2022 01:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646963560;
        bh=ElQDTI8JtDgLA/FRW2yw8esmW+0PDJgkMBrGrJcYNiw=;
        h=Date:To:From:Subject:From;
        b=CdaJKZXXmfBD54LFQUyqVqzsy4GsrpeiDUF7IuXyNDTE5Tha8a30PFfWWOygI53MG
         1mb2g5j2WfOoww4hU6XbTL8QNx0BDfC5YXfGkn7NritZBr3iQ0h6G3NZXKEfQH+FZc
         +we3xEZk5lMJ9SkkwcRqMeSDBG1L8WYw5uIBjE8E=
Date:   Thu, 10 Mar 2022 17:52:40 -0800
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, mst@redhat.com, corbet@lwn.net,
        bhelgaas@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-typesh-remove-unnecessary-__bitwise__.patch added to -mm tree
Message-Id: <20220311015240.C907AC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/types.h: remove unnecessary __bitwise__
has been added to the -mm tree.  Its filename is
     linux-typesh-remove-unnecessary-__bitwise__.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-typesh-remove-unnecessary-__bitwise__.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-typesh-remove-unnecessary-__bitwise__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: linux/types.h: remove unnecessary __bitwise__

There are no users of "__bitwise__" except the definition of "__bitwise". 
Remove __bitwise__ and define __bitwise directly.

This is a follow-up to 05de97003c77 ("linux/types.h: enable endian checks
for all sparse builds").

Link: https://lkml.kernel.org/r/20220310220927.245704-2-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/types.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__
+++ a/include/uapi/linux/types.h
@@ -20,11 +20,10 @@
  */
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
_

Patches currently in -mm which might be from bhelgaas@google.com are

linux-typesh-remove-unnecessary-__bitwise__.patch
documentation-sparse-add-hints-about-__checker__.patch

