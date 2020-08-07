Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238F2C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFACA2086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779059;
	bh=K5GsZGmXlCsrWlXE8ePcOHEmNmK/SoEdcYaKCMEcrEc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iL2AwcWoL6ino4YIBjbrv4gwvhZAHdrFo3qlJ8HL+96zhTWZIr+1WOHpOsXw62Yv1
	 +TYK5xE/v+1h7sgZHBA51Lu9Ju5geo2Yuz6ufJ/YcZZ0Ce1hwP89jL9ysAe42nW3YI
	 K5tMQtWfPjZck806pQVXmkeZoDvp8ettotVFtHlk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGFoS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFoS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:44:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFB4320855;
        Fri,  7 Aug 2020 05:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779058;
        bh=K5GsZGmXlCsrWlXE8ePcOHEmNmK/SoEdcYaKCMEcrEc=;
        h=Date:From:To:Subject:From;
        b=Yl8h8Y67iDAWggJHfexorO1ydyEE6OGExCRpirJWSIjYDJw4xhv0f12MViSahvjGU
         IzomtVFJGdIjivs8CrjtawJdnEv30ow/TSnmxNqPoWoOyxNGV2+z8sw0mEmUDSk9p2
         y9+FMroQ2L0wSghtwD9WX9E+6CW3MGu5fJNHEqpY=
Date:   Thu, 06 Aug 2020 22:44:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, longman@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch removed from -mm
 tree
Message-ID: <20200807054417.KQR6cfCBf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-treewide-rename-kzfree-to-kfree_sensitive-fix
has been removed from the -mm tree.  Its filename was
     mm-treewide-rename-kzfree-to-kfree_sensitive-fix.patch

This patch was dropped because it was folded into mm-treewide-rename-kzfree-to-kfree_sensitive.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-treewide-rename-kzfree-to-kfree_sensitive-fix

fs/crypto/inline_crypt.c needs linux/slab.h

Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/crypto/inline_crypt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/crypto/inline_crypt.c~mm-treewide-rename-kzfree-to-kfree_sensitive-fix
+++ a/fs/crypto/inline_crypt.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
+#include <linux/slab.h>
 
 #include "fscrypt_private.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-treewide-rename-kzfree-to-kfree_sensitive.patch
mm-treewide-rename-kzfree-to-kfree_sensitive-fix-fix.patch
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

