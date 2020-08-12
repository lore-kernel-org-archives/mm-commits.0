Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FA4C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D872080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266289;
	bh=h2I2MH8RPbuIgm/gR/OsbaP7VL92EtVHpbCOoWFedf0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KpFdNIBXOvJd5glrpZ8pu6+ZHrWTQZgfKdW+NLnRqSttjL+DkZsKgGxDEVPulKBRp
	 e5wkYBI6cOs+P+kyBf2TYuP9ZoL02Hi2nMln558WTUsXFVnvEidJuaGtRyHd5UGcmn
	 AI6533S5WuKkOOqAycYBrAR3Xoney9YZVRuXHZug=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHLVEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgHLVEs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74604207F7;
        Wed, 12 Aug 2020 21:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266288;
        bh=h2I2MH8RPbuIgm/gR/OsbaP7VL92EtVHpbCOoWFedf0=;
        h=Date:From:To:Subject:From;
        b=0PsWRoiZ9AHZWSYaZWmpp9xmlEazJR5PYLq6nqdYELVGKwnbWz6I2XBLPacIMy23j
         HjjXXzcxQF4nUE+3ltNgDlGqtdLq0HbbuR6Ymwx/jxYdxif5CUf6Cv3p3RthTZBzqf
         jVLF6aqqrZ/7Zwigztf2oU+fZJSR5T9ajK4n4oIY=
Date:   Wed, 12 Aug 2020 14:04:48 -0700
From:   akpm@linux-foundation.org
To:     ebiggers@google.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] nilfs2-only-call-unlock_new_inode-if-i_new.patch
 removed from -mm tree
Message-ID: <20200812210448.DUoMN2Wrs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: only call unlock_new_inode() if I_NEW
has been removed from the -mm tree.  Its filename was
     nilfs2-only-call-unlock_new_inode-if-i_new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from ebiggers@google.com are


