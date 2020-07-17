Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113D1C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 04:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82A52076A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 04:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594958796;
	bh=bXtbG+1Fh5OzneU3EdH8+GRJxVypkM2E1cDzvKnLme8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P6rxLSqm73DE0raOZOR8mmp9GEJwqnI4N1aXC7+JS1LkxW8ktiu1MwiMl4lxGUtTg
	 1Ek7rAFbt+ZP/tNdXCF7geUNIZGgU0qmscrcik6Xbam8FS2pvRttzLoUdyao9xB9Sl
	 4s2Tjl3UAuEHCRfUYHxC79mZASnEXQAKIO6sx30o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgGQEGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 00:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgGQEGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 00:06:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A398F20838;
        Fri, 17 Jul 2020 04:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594958795;
        bh=bXtbG+1Fh5OzneU3EdH8+GRJxVypkM2E1cDzvKnLme8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZD4mP6MhdVnAMGwqIZPZ0XMJ/QoQ3UfhrnRxc7cfnvAor9r2cmDFWSYuZfuA10LFu
         FiyrHUHSgfNkybnnckzw2S8Qc0C/2EO/FvqrgS+d3jUbmon0hHE0Mx3T2/1HMAsnD2
         5fdLDIeU52sLzMoET3TH6F3ENSIQn0HU/wDG+XNk=
Date:   Thu, 16 Jul 2020 21:06:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  +
 revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch added to
 -mm tree
Message-ID: <20200717040635.tLCImH5VW%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
has been added to the -mm tree.  Its filename is
     revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/squashfs/super.c~revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
+++ a/fs/squashfs/super.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/magic.h>
 #include <linux/xattr.h>
+#include <linux/blk_types.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
revert-squashfs-migrate-from-ll_rw_block-usage-to-bio.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch
revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

