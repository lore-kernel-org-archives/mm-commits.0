Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F097C636D4
	for <mm-commits@archiver.kernel.org>; Sat,  4 Feb 2023 01:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjBDBvX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 20:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjBDBvW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 20:51:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA1C19F0A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 17:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB6762047
        for <mm-commits@vger.kernel.org>; Sat,  4 Feb 2023 01:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBEDC433EF;
        Sat,  4 Feb 2023 01:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675475480;
        bh=VeolFg+zfR+/wKMI7jR1U4Fy1Fhofmt4SxbJF3O6PqM=;
        h=Date:To:From:Subject:From;
        b=yUpw7BF4vNg7QcXe7pViBOo0CZrDR9BQvO3pwpE9m9A2Jr7DU4+aprNPUNXRRJJCY
         Zd8uzXofPEZZMSAVcNkMHyE6yzz7bmYjJZ6QeZ2NbWmFNKncmDrtoDj14L0Wjnoer9
         mAdGBt768PyrXXpaec+CW/HNhhoUOqpSpMn97xiw=
Date:   Fri, 03 Feb 2023 17:51:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ruansy.fnst@fujitsu.com, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch removed from -mm tree
Message-Id: <20230204015119.DDBEDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax-dax_unshare_iter-should-return-a-valid-length-fix
has been removed from the -mm tree.  Its filename was
     fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch

This patch was dropped because it was folded into fsdax-dax_unshare_iter-should-return-a-valid-length.patch

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

fsdax-dax_unshare_iter-should-return-a-valid-length.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

