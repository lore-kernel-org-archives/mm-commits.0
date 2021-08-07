Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA20C4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6ED60F6D
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhHGTbk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhHGTbk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE8CC6024A;
        Sat,  7 Aug 2021 19:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628364681;
        bh=zfhYkPItWaMJwK7+hyZmefOqBJL5Yj8aO8gv/4Ek2Oo=;
        h=Date:From:To:Subject:From;
        b=IHBQKUzKOsuvHu1IMVX2TxdeGhcLK25qW2RTt/jjv5yyVGrA9VGaaUdawDQ+kFy8i
         SO65Hfp7WUxdz/+QthUhgLDSlkXMgmAHGC9Z9/6LYBfU7YWYMenTYJ3S7JGe1idQhq
         jL4Kkv8pm2xPCnvDhmSC0pA/bVQKnAHHOfzA0DbM=
Date:   Sat, 07 Aug 2021 12:31:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hughd@google.com,
        zhansayabagdaulet@gmail.com
Subject:  + mm-ksm-fix-data-type.patch added to -mm tree
Message-ID: <20210807193121.2ZqG-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: KSM: fix data type
has been added to the -mm tree.  Its filename is
     mm-ksm-fix-data-type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-fix-data-type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-fix-data-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Subject: mm: KSM: fix data type

ksm_stable_node_chains_prune_millisecs is declared as int, but in
stable__node_chains_prune_millisecs_store(), it can store values up to
UINT_MAX.  Change its type to unsigned int.

Link: https://lkml.kernel.org/r/20210806111351.GA71845@asus
Signed-off-by: Zhansaya Bagdauletkyzy <zhansayabagdaulet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-data-type
+++ a/mm/ksm.c
@@ -259,7 +259,7 @@ static unsigned long ksm_stable_node_cha
 static unsigned long ksm_stable_node_dups;
 
 /* Delay in pruning stale stable_node_dups in the stable_node_chains */
-static int ksm_stable_node_chains_prune_millisecs = 2000;
+static unsigned int ksm_stable_node_chains_prune_millisecs = 2000;
 
 /* Maximum number of page slots sharing a stable node */
 static int ksm_max_page_sharing = 256;
@@ -3105,11 +3105,11 @@ stable_node_chains_prune_millisecs_store
 					 struct kobj_attribute *attr,
 					 const char *buf, size_t count)
 {
-	unsigned long msecs;
+	unsigned int msecs;
 	int err;
 
-	err = kstrtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
+	err = kstrtouint(buf, 10, &msecs);
+	if (err)
 		return -EINVAL;
 
 	ksm_stable_node_chains_prune_millisecs = msecs;
_

Patches currently in -mm which might be from zhansayabagdaulet@gmail.com are

selftests-vm-add-ksm-merge-test.patch
selftests-vm-add-ksm-unmerge-test.patch
selftests-vm-add-ksm-zero-page-merging-test.patch
selftests-vm-add-ksm-merging-across-nodes-test.patch
selftests-vm-add-ksm-merging-time-test.patch
selftests-vm-add-cow-time-test-for-ksm-pages.patch
mm-ksm-fix-data-type.patch

