Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF344C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 22:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiCaWfY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242500AbiCaWfX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 18:35:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D44BE66
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 15:33:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB7DC61146
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 22:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4B4C340ED;
        Thu, 31 Mar 2022 22:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648766014;
        bh=W0+N3s4Q5DRlPC2oK8UfDjY0Pm3xBKrFbhxdltQ7JzY=;
        h=Date:To:From:Subject:From;
        b=QPmlCN38FKa++Ps52hVH5HeHz+zctsmBTdR+LFbkVNYIqQ/Mq8KyG8VBrqMQYKVUC
         vRMm63CJAlUoHF7AXjGmc0Jtm5KHJEMQVHia3rZh/P7MaGH7hssODMYn6eQUxZ7IFR
         83dt210AUkl7x/aaBfsubtc5d2Xe+bBuTRnP8pSU=
Date:   Thu, 31 Mar 2022 15:33:33 -0700
To:     mm-commits@vger.kernel.org, axelrasmussen@google.com,
        lkp@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch added to -mm tree
Message-Id: <20220331223334.3E4B4C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: secretmem_iops can be static
has been added to the -mm tree.  Its filename is
     mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: kernel test robot <lkp@intel.com>
Subject: mm/secretmem: secretmem_iops can be static

mm/secretmem.c:173:31: warning: symbol 'secretmem_iops' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/YkXc0RjJYQoGZZ8A@57de4820519d
Fixes: 24209f2f4d62 ("mm/secretmem: fix panic when growing a memfd_secret")
Signed-off-by: kernel test robot <lkp@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix
+++ a/mm/secretmem.c
@@ -170,7 +170,7 @@ static int secretmem_setattr(struct user
 	return simple_setattr(mnt_userns, dentry, iattr);
 }
 
-const struct inode_operations secretmem_iops = {
+static const struct inode_operations secretmem_iops = {
 	.setattr = secretmem_setattr,
 };
 
_

Patches currently in -mm which might be from lkp@intel.com are

mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch

