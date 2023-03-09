Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05E7C678D5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 01:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCIBxW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 20:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCIBxV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 20:53:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E965709B
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 17:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6442C619FF
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 01:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F07C433D2;
        Thu,  9 Mar 2023 01:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678326796;
        bh=QtstZkQvyZuZVn7tSPGdazstWIWlr8U0bVQf45Pbc2k=;
        h=Date:To:From:Subject:From;
        b=evVMZ/CDJ8YvKsB2kKUgPlsb/hrCC4y/GAtneV2IkEu0EBaTrbT809ZrxqVaftuBn
         +7qrZFF8zkB8D7pKxoM7NGJC93knNSNCT8exkOGC7OioYP02hvPEbUtwDyWJLqrKxs
         DZPWHaWn00Thyt7JHJdTybS4Wyn4W9xll4SvfsO4=
Date:   Wed, 08 Mar 2023 17:53:16 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dakr@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-export-symbol-mas_preallocate.patch added to mm-unstable branch
Message-Id: <20230309015316.B4F07C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: export symbol mas_preallocate()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-export-symbol-mas_preallocate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-export-symbol-mas_preallocate.patch

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
From: Danilo Krummrich <dakr@redhat.com>
Subject: maple_tree: export symbol mas_preallocate()
Date: Thu, 2 Mar 2023 02:10:35 +0100

Fix missing EXPORT_SYMBOL_GPL() statement for mas_preallocate().

It isn't actually used by anything yet, but mas_preallocate() is part of
the maple tree's 'Advanced API'.  All other functions of this API are
exported already.

Link: https://lkml.kernel.org/r/20230302011035.4928-1-dakr@redhat.com
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-export-symbol-mas_preallocate
+++ a/lib/maple_tree.c
@@ -5825,6 +5825,7 @@ int mas_preallocate(struct ma_state *mas
 	mas_reset(mas);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mas_preallocate);
 
 /*
  * mas_destroy() - destroy a maple state.
_

Patches currently in -mm which might be from dakr@redhat.com are

maple_tree-export-symbol-mas_preallocate.patch

