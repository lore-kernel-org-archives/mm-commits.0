Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F83EC77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjDRXgB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjDRXex (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DE9B451
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E7A6387C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B763C433EF;
        Tue, 18 Apr 2023 23:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860876;
        bh=077cZavUSfjZ4HsGTqEEHiomYR/SS/ZHxfQ7+7Vgmqk=;
        h=Date:To:From:Subject:From;
        b=z5NVBMo7LfajaTyoknOW/2cpsHNlXQzXs6jUf7ddddP2autYLYX7W2ufwiyLPNQhQ
         xc+xhKNMhc/fsmM2TiBsRpYqVJLA6RR7omMCgv8WeJluyYwzHn2jhYiVFT7+p3bxGo
         lE29O/HmUQGsrLRPWEwoeuPyqHG49McqNbMl/1j0=
Date:   Tue, 18 Apr 2023 16:34:35 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dcb314@hotmail.com, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-correct-variable-type-in-sizeof.patch removed from -mm tree
Message-Id: <20230418233436.3B763C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: use correct variable type in sizeof
has been removed from the -mm tree.  Its filename was
     maple_tree-use-correct-variable-type-in-sizeof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: use correct variable type in sizeof
Date: Tue, 11 Apr 2023 10:35:13 +0800

The type of variable pointed to by pivs is unsigned long, but the type
used in sizeof is a pointer type.  Change it to unsigned long.

This change has no runtime effect, as sizeof(ul) == sizeof(ul *).

Link: https://lkml.kernel.org/r/20230411023513.15227-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reported-by: David Binderman <dcb314@hotmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-use-correct-variable-type-in-sizeof
+++ a/lib/maple_tree.c
@@ -3258,7 +3258,7 @@ static inline void mas_destroy_rebalance
 
 		if (tmp < max_p)
 			memset(pivs + tmp, 0,
-			       sizeof(unsigned long *) * (max_p - tmp));
+			       sizeof(unsigned long) * (max_p - tmp));
 
 		if (tmp < mt_slots[mt])
 			memset(slots + tmp, 0, sizeof(void *) * (max_s - tmp));
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-a-test-case-to-check-maple_alloc.patch

