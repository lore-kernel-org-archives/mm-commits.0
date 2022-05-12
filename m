Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90529C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 19:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352226AbiELTTM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347472AbiELTTL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 15:19:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8056E277379
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 12:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BF3B61CF6
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61907C385B8;
        Thu, 12 May 2022 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652383149;
        bh=MSi2aego8uNhvp6v3TCuZapl4N0eW8tBekzAvXlpz6E=;
        h=Date:To:From:Subject:From;
        b=hWk1wM1gCkjfIpcH1ZHjIOIe7rEzv2R0kAkeo5Q/yDUUpai0vGfrQvN7yaNv+tuHT
         qNwM2hj2XiT1kB8JYlJU+ZIpCMr5qA9tYRtr3VQx6KAojo68qqtfFgWpLPd9Xl4Kab
         TMnCUh0Skx4ie92LPmUaPxOO5PD/TNtSeQ7otTlk=
Date:   Thu, 12 May 2022 12:19:08 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        viro@zeniv.linux.org.uk, mingo@elte.hu, mcgrof@kernel.org,
        keescook@chromium.org, jpitti@cisco.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-sysctl-make-protected_-world-readable.patch added to mm-nonmm-unstable branch
Message-Id: <20220512191909.61907C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/sysctl: make protected_* world readable
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-sysctl-make-protected_-world-readable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-sysctl-make-protected_-world-readable.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Julius Hemanth Pitti <jpitti@cisco.com>
Subject: proc/sysctl: make protected_* world readable

protected_* files have 600 permissions which prevents non-superuser from
reading them.

Container like "AWS greengrass" refuse to launch unless
protected_hardlinks and protected_symlinks are set.  When containers like
these run with "userns-remap" or "--user" mapping container's root to
non-superuser on host, they fail to run due to denied read access to these
files.

As these protections are hardly a secret, and do not possess any security
risk, making them world readable.

Though above greengrass usecase needs read access to only
protected_hardlinks and protected_symlinks files, setting all other
protected_* files to 644 to keep consistency.

Link: http://lkml.kernel.org/r/20200709235115.56954-1-jpitti@cisco.com
Fixes: 800179c9b8a1 ("fs: add link restrictions")
Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/namei.c~proc-sysctl-make-protected_-world-readable
+++ a/fs/namei.c
@@ -1031,7 +1031,7 @@ static struct ctl_table namei_sysctls[]
 		.procname	= "protected_symlinks",
 		.data		= &sysctl_protected_symlinks,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
@@ -1040,7 +1040,7 @@ static struct ctl_table namei_sysctls[]
 		.procname	= "protected_hardlinks",
 		.data		= &sysctl_protected_hardlinks,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
@@ -1049,7 +1049,7 @@ static struct ctl_table namei_sysctls[]
 		.procname	= "protected_fifos",
 		.data		= &sysctl_protected_fifos,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
@@ -1058,7 +1058,7 @@ static struct ctl_table namei_sysctls[]
 		.procname	= "protected_regular",
 		.data		= &sysctl_protected_regular,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
_

Patches currently in -mm which might be from jpitti@cisco.com are

proc-sysctl-make-protected_-world-readable.patch

