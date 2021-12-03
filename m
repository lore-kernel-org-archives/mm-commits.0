Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE0BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 20:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357736AbhLCUR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Dec 2021 15:17:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35028 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhLCURz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Dec 2021 15:17:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3965C62CCD
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 20:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F2AC53FAD;
        Fri,  3 Dec 2021 20:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638562469;
        bh=qGhOa+Yo+Bkga/zoT832aUiCqY9wmv9ssOe/Vusz2Hg=;
        h=Date:From:To:Subject:From;
        b=gpTyEAm14LlIFZDevQKmwo1wyi9zBu8tL0BtywK+AffnkZ3PSYwQxp7SXJZir1wYb
         BFS9J6eB9X3i+C48aG1C85+7wsOERAMj8RHaji28POEJfmNIratsAU8i3qJmDNR8+r
         wnsedMIbTZS3BusbeywvDJiYtN2EtcFh/CG9+Ww0=
Date:   Fri, 03 Dec 2021 12:14:28 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  + fs-move-inode-sysctls-to-its-own-file-fix.patch added
 to -mm tree
Message-ID: <20211203201428.fw2v7ABAc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/inode: avoid unused-variable warning
has been added to the -mm tree.  Its filename is
     fs-move-inode-sysctls-to-its-own-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-inode-sysctls-to-its-own-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-inode-sysctls-to-its-own-file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-move-inode-sysctls-to-its-own-file-fix.patch
fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

