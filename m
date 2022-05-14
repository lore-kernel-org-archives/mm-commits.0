Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE53AC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbiENTxR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiENTxP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:53:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B29377EB
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FB0BB80AF9
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155EDC340EE;
        Sat, 14 May 2022 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652557991;
        bh=hpN66AyDQfUFYgm3rlzpYqhsc0gOZVTBaNcr9gSFBaA=;
        h=Date:To:From:Subject:From;
        b=zoXXzxFfWIabtJyKYUxRrMAUwSnlkLGuXY0h1e7KVAotU1fkXtw00Kvze7QldrRnR
         8ts3QqWuljsNiBdEhTuxZG/iHSdRQ5fZg4LgCRjs6/cedb9PL1iQmFVT3yt30UwQan
         Wtc/pyZVtUXthxoGqNc10qu82G+w0iCNvV5hm9us=
Date:   Sat, 14 May 2022 12:53:10 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        viro@zeniv.linux.org.uk, mingo@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, jpitti@cisco.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-sysctl-make-protected_-world-readable.patch removed from -mm tree
Message-Id: <20220514195311.155EDC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/sysctl: make protected_* world readable
has been removed from the -mm tree.  Its filename was
     proc-sysctl-make-protected_-world-readable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ingo Molnar <mingo@kernel.org>
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


