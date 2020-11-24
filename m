Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04756C56201
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 04:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C602085B
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 04:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nn12wRsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgKXEGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:06:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgKXEGm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 23:06:42 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBDF720857;
        Tue, 24 Nov 2020 04:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606190802;
        bh=W0jB2uMmOVJF+WYrdu1ZZxFp7R8wJN0evuAlQbU756Q=;
        h=Date:From:To:Subject:From;
        b=Nn12wRszKy+1ObVJL9V+D0xW/0yPtRZ7uVfA3llXOor9cviNR/zLXYKGTsTajAJBg
         lcKIJeM9ErGo+Unc2jta8JQzF0443zXzTZln+Sfp1OeeQ4V3RnxfYhAiKX9BSJQo8m
         40lIy1ugDfRR5GTtptnQ+bOQXcxbquZ9GweMeIkI=
Date:   Mon, 23 Nov 2020 20:06:41 -0800
From:   akpm@linux-foundation.org
To:     dong.menglong@zte.com.cn, jwilk@jwilk.net,
        mm-commits@vger.kernel.org, nhorman@tuxdriver.com,
        pabs3@bonedaddy.net, stable@vger.kernel.org
Subject:  + coredump-fix-core_pattern-parse-error.patch added to
 -mm tree
Message-ID: <20201124040641.i-uZVI7PN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: fix core_pattern parse error
has been added to the -mm tree.  Its filename is
     coredump-fix-core_pattern-parse-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/coredump-fix-core_pattern-parse-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/coredump-fix-core_pattern-parse-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Menglong Dong <dong.menglong@zte.com.cn>
Subject: coredump: fix core_pattern parse error

'format_corename()' will splite 'core_pattern' on spaces when it is in
pipe mode, and take helper_argv[0] as the path to usermode executable.

It works fine in most cases. However, if there is a space between
'|' and '/file/path', such as
'| /usr/lib/systemd/systemd-coredump %P %u %g',
helper_argv[0] will be parsed as '', and users will get a
'Core dump to | disabled'.

It is not friendly to users, as the pattern above was valid previously. 
Fix this by ignoring the spaces between '|' and '/file/path'.

Link: https://lkml.kernel.org/r/5fb62870.1c69fb81.8ef5d.af76@mx.google.com
Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coredump.c~coredump-fix-core_pattern-parse-error
+++ a/fs/coredump.c
@@ -229,7 +229,8 @@ static int format_corename(struct core_n
 		 */
 		if (ispipe) {
 			if (isspace(*pat_ptr)) {
-				was_space = true;
+				if (cn->used != 0)
+					was_space = true;
 				pat_ptr++;
 				continue;
 			} else if (was_space) {
_

Patches currently in -mm which might be from dong.menglong@zte.com.cn are

coredump-fix-core_pattern-parse-error.patch

