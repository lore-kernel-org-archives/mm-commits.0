Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3524C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C5061872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhKKCz6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKCz5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:55:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8332061361;
        Thu, 11 Nov 2021 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599189;
        bh=o5cft+szzSvNmlSOp+rTPBM5XKJ9Ac6dhDufiTOwHq4=;
        h=Date:From:To:Subject:From;
        b=gdGNumdxkAUk7B/6n2s7XTK/WlkOnXIFCdORz5gnopih1T3/HCuOU00CuW0DgnJMs
         k1PrsMO0bg691ffKxfM9ljfW8mBkDoETjma3254CSXUIi9TBMpN7iPIl/EFACYso4i
         0+iQlCedN2exrSF56u0WF2oLZnaOQR4Q0BD2TOyI=
Date:   Wed, 10 Nov 2021 18:53:09 -0800
From:   akpm@linux-foundation.org
To:     ahalaney@redhat.com, bp@suse.de, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rostedt@goodmis.org
Subject:  [merged]
 init-make-unknown-command-line-param-message-clearer.patch removed from -mm
 tree
Message-ID: <20211111025309.EQ-0SSTYW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: make unknown command line param message clearer
has been removed from the -mm tree.  Its filename was
     init-make-unknown-command-line-param-message-clearer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -924,7 +924,9 @@ static void __init print_unknown_bootopt
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

init-mainc-silence-some-wunused-parameter-warnings.patch

