Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797BEC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 00:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjBCAXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 19:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBCAXr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 19:23:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A258E81B2B
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 16:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2835761D11
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 00:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BC5C433D2;
        Fri,  3 Feb 2023 00:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675383824;
        bh=cAUQRl4M7mTUZpKH/54gPku1AxukNWU/jgJaSpG7FpY=;
        h=Date:To:From:Subject:From;
        b=rgmFwAu1A+fXBaC7JcV6gOW2YYJsk5VaQ/R6UZD08u/6xt8+gQJ0Fydkn9iPUDxze
         8YD2OTHGOFd9PyFNpVLo7FEkbxDWM8xnild9ztnzKOjT1doBRWvHNJWiFiISHNS2cc
         I3O8+HQHQXBOKCwcuY1onuxTYhHLI/wzm59HD/Mo=
Date:   Thu, 02 Feb 2023 16:23:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ruansy.fnst@fujitsu.com, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230203002344.73BC5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax-dax_unshare_iter-should-return-a-valid-length-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fsdax-dax_unshare_iter-should-return-a-valid-length-fix
Date: Thu Feb  2 04:15:00 PM PST 2023

don't mess up `ret', per Matthew

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/dax.c~fsdax-dax_unshare_iter-should-return-a-valid-length-fix
+++ a/fs/dax.c
@@ -1271,10 +1271,10 @@ static s64 dax_unshare_iter(struct iomap
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = copy_mc_to_kernel(daddr, saddr, length);
-	if (ret)
+	if (copy_mc_to_kernel(daddr, saddr, length) == 0)
+		ret = length;
+	else
 		ret = -EIO;
-	ret = length;
 
 out_unlock:
 	dax_read_unlock(id);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

