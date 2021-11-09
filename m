Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25678C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F05B61288
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbhKIChN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhKIChN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D006961208;
        Tue,  9 Nov 2021 02:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425268;
        bh=OKdmbgZHg3U10cBTLK0231EdB0xD/wqywqcJSwnKgbA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LLzmqeJ6kj9MXICZpP8DkC+gVJSw5EZjMFccc//VWeJwclrJO+q08uR1ibJYunmSl
         153O3X9x9yXBOl8+Avovygzb8DTyc0IbU8QoUoM1aMCKiIm+vpWtrZAMcRD8Q3Xujw
         gK8wqKE5LDvgCS1LNHWMhNMnqS4ovqjDnz3HSkUA=
Date:   Mon, 08 Nov 2021 18:34:27 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ahalaney@redhat.com, akpm@linux-foundation.org, bp@suse.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org
Subject:  [patch 56/87] init: make unknown command line param
 message clearer
Message-ID: <20211109023427.MwfRSiD2I%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
