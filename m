Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FD7C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 01:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244265AbiDOCAF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 22:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241271AbiDOCAE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 22:00:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A30B1894
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 18:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7CB2B82B23
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 01:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1BBC385A5;
        Fri, 15 Apr 2022 01:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649987855;
        bh=iFGoFGhaUzOMZDvDHYWxK1is14Itl29Hc0RbdcZKnXE=;
        h=Date:To:From:Subject:From;
        b=emvNJVrO03mdUIqCbqK2YTs5lHXRk79Zi7SHkmntPboW/7htZhCVTP2lce63GShpV
         isn/NJ2drJDLDMOOkD9s1CZoT/fGRKJ265N3kX4JtpzvklrgRkcuhDnq8sSwBvWytR
         PA+4Js3XViQL5xjU5Ki2dz3hxdrCgX6wJDGlTXig=
Date:   Thu, 14 Apr 2022 18:57:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        axelrasmussen@google.com, lkp@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch removed from -mm tree
Message-Id: <20220415015735.7F1BBC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: secretmem_iops can be static
has been removed from the -mm tree.  Its filename was
     mm-secretmem-fix-panic-when-growing-a-memfd_secret-fix.patch

This patch was dropped because it was folded into mm-secretmem-fix-panic-when-growing-a-memfd_secret.patch

------------------------------------------------------
From: kernel test robot <lkp@intel.com>
Subject: mm/secretmem: secretmem_iops can be static

mm/secretmem.c:173:31: warning: symbol 'secretmem_iops' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/YkXc0RjJYQoGZZ8A@57de4820519d
Fixes: 24209f2f4d62 ("mm/secretmem: fix panic when growing a memfd_secret")
Signed-off-by: kernel test robot <lkp@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
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

mm-secretmem-fix-panic-when-growing-a-memfd_secret.patch
mm-shmem-handle-uffd-wp-during-fork-fix.patch

