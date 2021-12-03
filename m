Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD4AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 20:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhLCUSB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Dec 2021 15:18:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353691AbhLCUR6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Dec 2021 15:17:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C774B82946
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 20:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83F3C53FCD;
        Fri,  3 Dec 2021 20:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638562472;
        bh=Yi+eye666u7i11qy9zuoF8N8sUDoZtFDuUt8ErWKOms=;
        h=Date:From:To:Subject:From;
        b=BAOm07Qil+DQ96M5e/MfT3L6bzZqQmi7Qivtsz43jFlaltAKhcvHxNqr6ixcHtfOu
         lQ+GChtvyZliNwD6KH2Q/XwErNengNp6dLbFPeb69yg7cZ3G/h/BeFuDfxOZCIVPSZ
         w5LeEBW0liS9GvIk5YotocihmVUpnejpNsBZF+PQ=
Date:   Fri, 03 Dec 2021 12:14:31 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  + fs-move-dcache-sysctls-to-its-own-file-fix-2.patch
 added to -mm tree
Message-ID: <20211203201431.NcZXDMsVP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dcache: avoid unused-function warning
has been added to the -mm tree.  Its filename is
     fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-dcache-sysctls-to-its-own-file-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

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

fs-move-inode-sysctls-to-its-own-file-fix.patch
fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

