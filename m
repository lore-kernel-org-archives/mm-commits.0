Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29063C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiGRAV5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiGRAUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D122B2
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B591B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2147C341C0;
        Mon, 18 Jul 2022 00:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103521;
        bh=RvkDKfBOjhgwjdvJEv7uAcUa3lZ8pg9CtXGioRNdVHM=;
        h=Date:To:From:Subject:From;
        b=R86GSECefrmezUvV6yGVxemSYnAdnoRra6+DEE3o1tSrhlKeucjGUo7jdJvUCJly/
         dB8QByAwEFD+2xh2+RwRcjA/jPeqrP+80geutDmOo1spvxSdYWGPQpQQD35W5TMZgV
         Vxfc+K0gLgcbocEWhAyPE7KI0IMRwP2Y6Cvv8Gi4=
Date:   Sun, 17 Jul 2022 17:18:41 -0700
To:     mm-commits@vger.kernel.org, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-remove-the-redundant-initialization-for-error.patch removed from -mm tree
Message-Id: <20220718001841.C2147C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: remove the redundant initialization for error
has been removed from the -mm tree.  Its filename was
     mm-mprotect-remove-the-redundant-initialization-for-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/mprotect: remove the redundant initialization for error
Date: Mon, 4 Jul 2022 19:41:12 +0800

The variable error will be assigned correctly before it is used, the
initialization is redundant, so remove it.

Link: https://lkml.kernel.org/r/20220704114112.163112-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-remove-the-redundant-initialization-for-error
+++ a/mm/mprotect.c
@@ -663,7 +663,7 @@ static int do_mprotect_pkey(unsigned lon
 {
 	unsigned long nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
-	int error = -EINVAL;
+	int error;
 	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
 	const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
 				(prot & PROT_READ);
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

writeback-cleanup-inode_to_wb_is_valid.patch

