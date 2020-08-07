Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1858DC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03E42086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779062;
	bh=+otwkpchMgEGXNJUcotB8nK2VcCPDYGybJzjjyVar5Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lim74/yCdVb6XbKqHc9dn9ck8ugk4mp/zUF43SS/sYFlc/b+lM3JF7fNUle0H7/AB
	 5gpJN/AsM2ERinmFPVcBw1lOo3+vu0afc/iR7bSblC/juS5Tw2Bk5QBbrK/Ux9ggbf
	 fjJutloJGZIrnmnaeqRCDMQ70xMTjj8dVNJZ1WnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGFoV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFoV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:44:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A7B220855;
        Fri,  7 Aug 2020 05:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779060;
        bh=+otwkpchMgEGXNJUcotB8nK2VcCPDYGybJzjjyVar5Q=;
        h=Date:From:To:Subject:From;
        b=uovcwX6nDuVAcrBKRP74hxgcLe2F090wKbFFgLfghEM8IvXTwuIvow3fIDnSFpuBp
         Sl7zTyTxMh6i4MXG6KqtLAgwd17G95ANmEx/wYKOj4zNmBvchvNJtsbCH2cB3fmNcw
         1nCUK4GqGqLnEBP7w3JcSzNGhGKT6QfYWCgWXors=
Date:   Thu, 06 Aug 2020 22:44:20 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, longman@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix.patch removed from -mm
 tree
Message-ID: <20200807054420.T4hE2D4m0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix.patch

This patch was dropped because it was folded into mm-treewide-rename-kzfree-to-kfree_sensitive.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix

fix fs/crypto/inline_crypt.c some more

Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/crypto/inline_crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/crypto/inline_crypt.c~mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix
+++ a/fs/crypto/inline_crypt.c
@@ -188,7 +188,7 @@ int fscrypt_prepare_inline_crypt_key(str
 fail:
 	for (i = 0; i < queue_refs; i++)
 		blk_put_queue(blk_key->devs[i]);
-	kzfree_sensitive(blk_key);
+	kfree_sensitive(blk_key);
 	return err;
 }
 
@@ -202,7 +202,7 @@ void fscrypt_destroy_inline_crypt_key(st
 			blk_crypto_evict_key(blk_key->devs[i], &blk_key->base);
 			blk_put_queue(blk_key->devs[i]);
 		}
-		kzfree_sensitive(blk_key);
+		kfree_sensitive(blk_key);
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-treewide-rename-kzfree-to-kfree_sensitive.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-hugetlb-add-mempolicy-check-in-the-reservation-routine-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

