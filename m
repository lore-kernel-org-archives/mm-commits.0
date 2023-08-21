Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506E8EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjHUU1O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjHUU1O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:27:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB97DE3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8209463322
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE5BC433C7;
        Mon, 21 Aug 2023 20:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692649632;
        bh=hhXDcwtmMtmZv93N358ypYqUow9k9LNLtzYYvzt9yR8=;
        h=Date:To:From:Subject:From;
        b=Sa8XMNdIhWp9vAmfgVsQGNSlOxrEIhXjysMqT7EPYHqzaaZ9uqhjMg+HdI+TiePM5
         E+XoBUslzlJg8TCVQnxeYOK/aRWOYvno8tB5SmORuBR6Ksg0DQ2AmCKQoeZwwBjo8r
         tOvOpgj7AnhGsL/G6e6DjpjFbcZFR5Jjr449dx74=
Date:   Mon, 21 Aug 2023 13:27:11 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        willy@infradead.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-redundant-k-macro-definition-fix.patch removed from -mm tree
Message-Id: <20230821202711.DAE5BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-remove-redundant-k-macro-definition-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-k-macro-definition-fix.patch

This patch was dropped because it was folded into mm-remove-redundant-k-macro-definition.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-redundant-k-macro-definition-fix
Date: Mon Aug  7 09:07:36 AM PDT 2023

oom_kill.c: remove "#undef K", per Kefeng

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/oom_kill.c~mm-remove-redundant-k-macro-definition-fix
+++ a/mm/oom_kill.c
@@ -992,7 +992,6 @@ static void __oom_kill_process(struct ta
 	mmdrop(mm);
 	put_task_struct(victim);
 }
-#undef K
 
 /*
  * Kill provided task unless it's secured by setting
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-remove-redundant-k-macro-definition.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch
mm-fix-get_mctgt_type-kernel-doc-fix.patch

