Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B65C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJCVaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJCV3v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F005755D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25CEBCE0E6A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F19EC433D6;
        Mon,  3 Oct 2022 21:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832152;
        bh=pgJh+SSO5RTtC2KA8YLpMHav2GqZgHAUgRWBEaaCvdc=;
        h=Date:To:From:Subject:From;
        b=p/zQghu6eu5vvejDYL97WTH9Xp4pxyVs3YTldATxyubbRtPBLAHvxJHG7V4d0t2N1
         ZCnsqHLl8k1ekBGQGD025bfUptrJJynlQqXwgNaAzn7IVZ3RiEH+JAY+Rpu45iJiO2
         PcusUV9BGMx27SUDIhB02p6Vkv1HVKlyG/cW9gB8=
Date:   Mon, 03 Oct 2022 14:22:31 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        jingyuwang_vip@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-mqueue-remove-unnecessary-conditionals.patch removed from -mm tree
Message-Id: <20221003212232.7F19EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc: mqueue: remove unnecessary conditionals
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-remove-unnecessary-conditionals.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jingyu Wang <jingyuwang_vip@163.com>
Subject: ipc: mqueue: remove unnecessary conditionals
Date: Fri, 9 Sep 2022 02:54:52 +0800

iput() already handles null and non-null parameters, so there is no need
to use if().

Link: https://lkml.kernel.org/r/20220908185452.76590-1-jingyuwang_vip@163.com
Signed-off-by: Jingyu Wang <jingyuwang_vip@163.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueue-remove-unnecessary-conditionals
+++ a/ipc/mqueue.c
@@ -986,8 +986,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 
 out_unlock:
 	inode_unlock(d_inode(mnt->mnt_root));
-	if (inode)
-		iput(inode);
+	iput(inode);
 	mnt_drop_write(mnt);
 out_name:
 	putname(name);
_

Patches currently in -mm which might be from jingyuwang_vip@163.com are


