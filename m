Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E941C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiAVBQn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:16:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35782 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBQm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:16:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAF9EB8213B
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADE7C340E1;
        Sat, 22 Jan 2022 01:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814200;
        bh=W6JoYNGBkA5Rw4ru0BYMTdtZ9HjG8eYsoQXvobrfk/8=;
        h=Date:From:To:Subject:From;
        b=NuPP4iWgAOcSBw99IgP7DLNld0dttzW1/ptSxsNoJ+TRQNs9cu8U1YL6plJpgYmLu
         mSRrT/n0hStpOqehg/IoZdHrQSCgsifIt6LpuZ60PesQt9CK44CUn3g2VHXoagE7kd
         J0piVYgh+QRopvpgDZXUgVP7Dmw9Z0nGBU0SSae8=
Date:   Fri, 21 Jan 2022 17:16:39 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 fs-move-inode-sysctls-to-its-own-file-fix.patch removed from -mm tree
Message-ID: <20220122011639.Jy2xxVm3Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/inode: avoid unused-variable warning
has been removed from the -mm tree.  Its filename was
     fs-move-inode-sysctls-to-its-own-file-fix.patch

This patch was dropped because it was folded into fs-move-inode-sysctls-to-its-own-file.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fs/inode: avoid unused-variable warning

Now that 'inodes_stat' is marked 'static', it causes a harmless warning
whenever it is unused:

fs/inode.c:73:29: error: 'inodes_stat' defined but not used [-Werror=unused-variable]
   73 | static struct inodes_stat_t inodes_stat;

Move it into the #ifdef that guards its only references.

Link: https://lkml.kernel.org/r/20211203190123.874239-1-arnd@kernel.org
Fixes: 245314851782 ("fs: move inode sysctls to its own file")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/inode.c~fs-move-inode-sysctls-to-its-own-file-fix
+++ a/fs/inode.c
@@ -67,11 +67,6 @@ const struct address_space_operations em
 };
 EXPORT_SYMBOL(empty_aops);
 
-/*
- * Statistics gathering..
- */
-static struct inodes_stat_t inodes_stat;
-
 static DEFINE_PER_CPU(unsigned long, nr_inodes);
 static DEFINE_PER_CPU(unsigned long, nr_unused);
 
@@ -106,6 +101,11 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
+/*
+ * Statistics gathering..
+ */
+static struct inodes_stat_t inodes_stat;
+
 static int proc_nr_inodes(struct ctl_table *table, int write, void *buffer,
 			  size_t *lenp, loff_t *ppos)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

fs-move-inode-sysctls-to-its-own-file.patch
fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

