Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC63C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 17:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbiHQRKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiHQRKA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 13:10:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B832D3DF04
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 10:09:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5138B61226
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 17:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9264FC433D6;
        Wed, 17 Aug 2022 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660756198;
        bh=f7M8EwIPdD4v9W9xSZkFfW+p3RvAzTcC2e/5vmqcp8M=;
        h=Date:To:From:Subject:From;
        b=0PFtLvgL40w94eJt5doqdRV/NnH5EUXJl8pFJUO5s6FAUhBCacXy9HnaOPtYzZ1wS
         gIckHlzIy8gjcOdbYyDOprbKuKYXGx14BY2W8I/c+21ndaZyiAKw65KERnigBfQ3PW
         H60RAUm/UGgYlC0wLyCKD1aaUSTE4vphcgon0/Pk=
Date:   Wed, 17 Aug 2022 10:09:57 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, kaleshsingh@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-add-path-to-proc-pid-fdinfo-fix.patch added to mm-unstable branch
Message-Id: <20220817170958.9264FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-path-to-proc-pid-fdinfo-fix
has been added to the -mm mm-unstable branch.  Its filename is
     procfs-add-path-to-proc-pid-fdinfo-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-add-path-to-proc-pid-fdinfo-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-add-path-to-proc-pid-fdinfo-fix
Date: Wed Aug 17 10:04:52 AM PDT 2022

warning: Local variable 'anon_aops' shadows outer variable

Reported-by: kernel test robot <lkp@intel.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/libfs.c~procfs-add-path-to-proc-pid-fdinfo-fix
+++ a/fs/libfs.c
@@ -1228,7 +1228,7 @@ bool is_anon_inode(struct inode *inode)
 
 struct inode *alloc_anon_inode(struct super_block *s)
 {
-	static const struct address_space_operations anon_aops = {
+	static const struct address_space_operations aops = {
 		.dirty_folio	= noop_dirty_folio,
 	};
 	struct inode *inode = new_inode_pseudo(s);
@@ -1237,7 +1237,7 @@ struct inode *alloc_anon_inode(struct su
 		return ERR_PTR(-ENOMEM);
 
 	inode->i_ino = get_next_ino();
-	inode->i_mapping->a_ops = &anon_aops;
+	inode->i_mapping->a_ops = &aops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch

