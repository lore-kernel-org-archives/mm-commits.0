Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF891C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiAVBRS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBRS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:17:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C486C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 279D2B82161
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999E5C340E1;
        Sat, 22 Jan 2022 01:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814234;
        bh=nsC1zRgdsoqglUJZIL5DhXpWm7QnVTQGJ6K4DkrMTAU=;
        h=Date:From:To:Subject:From;
        b=Q2akk3keWIKcVaXYOe7ENDjRgMJmbGPcnyuftcOyU2eE71oSd8NC7CNVzmSWHAFTE
         /rJIUDwOKsP4CX+PaG3WVsybntlWKS6vcZA2wJUVqxwd9oMnzkmTy44QcsjMrkbF4M
         xOgXLXJwm+LTKe0Jiq5lFC4Xv6pKluExOVgxqgOI=
Date:   Fri, 21 Jan 2022 17:17:14 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 fs-move-dcache-sysctls-to-its-own-file-fix-2.patch removed from -mm tree
Message-ID: <20220122011714.mn7XI3ns0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dcache: avoid unused-function warning
has been removed from the -mm tree.  Its filename was
     fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

This patch was dropped because it was folded into fs-move-dcache-sysctls-to-its-own-file.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fs/dcache: avoid unused-function warning

Now that 'dentry_stat' is marked 'static', we can run into this warning:

fs/dcache.c:128:29: error: 'dentry_stat' defined but not used [-Werror=unused-variable]
  128 | static struct dentry_stat_t dentry_stat = {

Hide it in the same #ifdef as its only references.

Link: https://lkml.kernel.org/r/20211203190123.874239-2-arnd@kernel.org
Fixes: f0eea17ca8da ("fs: move dcache sysctls to its own file")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/dcache.c~fs-move-dcache-sysctls-to-its-own-file-fix-2
+++ a/fs/dcache.c
@@ -124,16 +124,15 @@ struct dentry_stat_t {
 	long dummy;		/* Reserved for future use */
 };
 
-/* Statistics gathering. */
-static struct dentry_stat_t dentry_stat = {
-	.age_limit = 45,
-};
-
 static DEFINE_PER_CPU(long, nr_dentry);
 static DEFINE_PER_CPU(long, nr_dentry_unused);
 static DEFINE_PER_CPU(long, nr_dentry_negative);
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+/* Statistics gathering. */
+static struct dentry_stat_t dentry_stat = {
+	.age_limit = 45,
+};
 
 /*
  * Here we resort to our own counters instead of using generic per-cpu counters
_

Patches currently in -mm which might be from arnd@arndb.de are

fs-move-dcache-sysctls-to-its-own-file.patch

