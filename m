Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AECC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 23:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5633A61181
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 23:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhJMXMm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 19:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhJMXMk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 19:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC94961027;
        Wed, 13 Oct 2021 23:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634166637;
        bh=Ycf30QVE5TG+sSbJgjA0mFQUOd0YLH+R7wxJY7xmRU4=;
        h=Date:From:To:Subject:From;
        b=Z8ZJt1Pakc/dzDAhSYkL3HcUQbLO2mj5uPmp9a0hTeQea01mo1f7gcyOshclojbrb
         UzaJ84blCP9LkB4IaB/WihzerAgDLkHK/iAsAu3mo5SZiQo7+PtHGP+vODtUVhHflV
         FS7m5ePHx7kkqAPk1qelHDcqk1gTldw2M+nEHZYw=
Date:   Wed, 13 Oct 2021 16:10:36 -0700
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, bp@suse.de, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rostedt@goodmis.org
Subject:  +
 init-make-unknown-command-line-param-message-clearer.patch added to -mm
 tree
Message-ID: <20211013231036.Cc0ID3Oli%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: make unknown command line param message clearer
has been added to the -mm tree.  Its filename is
     init-make-unknown-command-line-param-message-clearer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-make-unknown-command-line-param-message-clearer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-make-unknown-command-line-param-message-clearer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Halaney <ahalaney@redhat.com>
Subject: init: make unknown command line param message clearer

The prior message is confusing users, which is the exact opposite of the
goal.  If the message is being seen, one of the following situations is
happening:

 1. the param is misspelled
 2. the param is not valid due to the kernel configuration
 3. the param is intended for init but isn't after the '--'
    delineator on the command line

To make that more clear to the user, explicitly mention "kernel command
line" and also note that the params are still passed to user space to
avoid causing any alarm over params intended for init.

Link: https://lkml.kernel.org/r/20211013223502.96756-1-ahalaney@redhat.com
Fixes: 86d1919a4fb0 ("init: print out unknown kernel parameters")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/init/main.c~init-make-unknown-command-line-param-message-clearer
+++ a/init/main.c
@@ -923,7 +923,9 @@ static void __init print_unknown_bootopt
 	for (p = &envp_init[2]; *p; p++)
 		end += sprintf(end, " %s", *p);
 
-	pr_notice("Unknown command line parameters:%s\n", unknown_options);
+	/* Start at unknown_options[1] to skip the initial space */
+	pr_notice("Unknown kernel command line parameters \"%s\", will be passed to user space.\n",
+		&unknown_options[1]);
 	memblock_free(unknown_options, len);
 }
 
_

Patches currently in -mm which might be from ahalaney@redhat.com are

init-make-unknown-command-line-param-message-clearer.patch
init-mainc-silence-some-wunused-parameter-warnings.patch

