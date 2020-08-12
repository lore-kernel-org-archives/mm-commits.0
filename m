Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B687C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ECBD20829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196145;
	bh=stNlpvjA4vu2pIGI844iIXj9bl5qygylqHQtnB4xqzU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AS03yYNEXreDRVI9UbobizBweS8Sy6AZ0BJMLh/FJ/DpgQwbj5HYQ2uI7zYaQNi2O
	 7Y+f27gsjBnwgxutDUmqOFoDgN/RRiTlieXppTmu3viSNGEDdQWjzx+RMjRie3G7od
	 goZs+sC+SdwdcWs4is76dsTD4E0zKbtePrNql0oQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBfo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10BFB2054F;
        Wed, 12 Aug 2020 01:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196144;
        bh=stNlpvjA4vu2pIGI844iIXj9bl5qygylqHQtnB4xqzU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WtkA3uXOw8yjWAiPy2QmcjoY07Jtm9bz1oE6XgCT6DtzYiMsxz4/FEW24EZgFhrbK
         /cWDguVr+hnOdCA0csJzEekvs4xoSLULU9gYHeyhQIo2lbQBpFhPQzVW4UH9vP+uYk
         jJ++1Lle9oWbo0ogze2EXmneHKYo/16v/u/xXAfk=
Date:   Tue, 11 Aug 2020 18:35:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiggers@google.com,
        konishi.ryusuke@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 104/165] nilfs2: only call unlock_new_inode() if
 I_NEW
Message-ID: <20200812013543.RxBpUWlQE%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>
Subject: nilfs2: only call unlock_new_inode() if I_NEW

Patch series "nilfs2 updates".


This patch (of 3):

unlock_new_inode() is only meant to be called after a new inode has
already been inserted into the hash table.  But nilfs_new_inode() can call
it even before it has inserted the inode, triggering the WARNING in
unlock_new_inode().  Fix this by only calling unlock_new_inode() if the
inode has the I_NEW flag set, indicating that it's in the table.

Link: http://lkml.kernel.org/r/1595860111-3920-1-git-send-email-konishi.ryusuke@gmail.com
Link: http://lkml.kernel.org/r/1595860111-3920-2-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c~nilfs2-only-call-unlock_new_inode-if-i_new
+++ a/fs/nilfs2/inode.c
@@ -388,7 +388,8 @@ struct inode *nilfs_new_inode(struct ino
 
  failed_after_creation:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
+	if (inode->i_state & I_NEW)
+		unlock_new_inode(inode);
 	iput(inode);  /*
 		       * raw_inode will be deleted through
 		       * nilfs_evict_inode().
_
