Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED929C433E2
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 23:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C897E2077D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 23:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594423943;
	bh=uM5ZGYOu7lEt1yVVzUoat5522EfmxEeFyeGu81u4qOk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HvPOofd4giRpse5M53UlkSmYNIuXpdKPiBv2ImJh4EYIjaCbzUgtQtmgQwAHu+2Zq
	 GQll7bGZYfL+Ek8HfBtOkF4RmyYK91akrXZvi5iw1WuMtN0U6lty+3cnlB5Oaxf4l/
	 pFxJn5LYKDVkdRBqGgLKikoO89b1xaDIOD/bKqyY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgGJXcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 19:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgGJXcX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 19:32:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCFC92065F;
        Fri, 10 Jul 2020 23:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594423941;
        bh=uM5ZGYOu7lEt1yVVzUoat5522EfmxEeFyeGu81u4qOk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dIrqdq10l02YUrvKCTTzLMSCgU83yMzpXs8H0iE14igES6c7wJy9BOVPP/M3TT7s2
         71VCDx0qmJqBOrKWCCGzP5gOhZBBQWOSVWnrbJD2Yl/pvh7/JTVx6agWUkX7MKs4Av
         mSmbz5WUiZlxnJDOA/7mJgDhWZ66eQZVqq3WWEqo=
Date:   Fri, 10 Jul 2020 16:32:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jpitti@cisco.com, keescook@chromium.org, mcgrof@kernel.org,
        mingo@elte.hu, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + proc-sysctl-make-protected_-world-readable.patch added
 to -mm tree
Message-ID: <20200710233220.fzS6eFqkb%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/sysctl: make protected_* world readable
has been added to the -mm tree.  Its filename is
     proc-sysctl-make-protected_-world-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-sysctl-make-protected_-world-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-sysctl-make-protected_-world-readable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sysctl.c~proc-sysctl-make-protected_-world-readable
+++ a/kernel/sysctl.c
@@ -3232,7 +3232,7 @@ static struct ctl_table fs_table[] = {
 		.procname	= "protected_symlinks",
 		.data		= &sysctl_protected_symlinks,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
@@ -3241,7 +3241,7 @@ static struct ctl_table fs_table[] = {
 		.procname	= "protected_hardlinks",
 		.data		= &sysctl_protected_hardlinks,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
@@ -3250,7 +3250,7 @@ static struct ctl_table fs_table[] = {
 		.procname	= "protected_fifos",
 		.data		= &sysctl_protected_fifos,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
@@ -3259,7 +3259,7 @@ static struct ctl_table fs_table[] = {
 		.procname	= "protected_regular",
 		.data		= &sysctl_protected_regular,
 		.maxlen		= sizeof(int),
-		.mode		= 0600,
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
_

Patches currently in -mm which might be from jpitti@cisco.com are

proc-sysctl-make-protected_-world-readable.patch

