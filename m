Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE41C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6CC613DD
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEIDZQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhEIDZQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:25:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34BA6137D;
        Sun,  9 May 2021 03:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620530654;
        bh=KIumy8B6OSWLeAfF5zgLeEMAauqAMTyrYht4DTnWp0E=;
        h=Date:From:To:Subject:From;
        b=LvxhQChQqN7aQN+V4taGw+63nras4S93h9lQbboymclWyoCwhjVQIgX3vsu1lCUEc
         qqVQjDKbJMsktk+I1F4kB6TA2Infl+P9z6+J9Br4+eN1Vx9zwwWQD7JcMlQEu3CP98
         jz3kq+7F7RS9adgg2xsmhVBLEpByTeqhhvTbotZA=
Date:   Sat, 08 May 2021 20:24:13 -0700
From:   akpm@linux-foundation.org
To:     bert@biot.com, dwaipayanray1@gmail.com, joe@perches.com,
        linux@roeck-us.net, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  +
 checkpatch-scripts-spdxcheckpy-now-requires-python3.patch added to -mm tree
Message-ID: <20210509032413.mb6qKQBmz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: scripts/spdxcheck.py now requires python3
has been added to the -mm tree.  Its filename is
     checkpatch-scripts-spdxcheckpy-now-requires-python3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-scripts-spdxcheckpy-now-requires-python3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-scripts-spdxcheckpy-now-requires-python3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: checkpatch: scripts/spdxcheck.py now requires python3

Since commit d0259c42abff ("spdxcheck.py: Use Python 3"), spdxcheck.py
explicitly expects to run as python3 script.  If "python" still points to
python v2.7 and the script is executed with "python scripts/spdxcheck.py",
the following error may be seen even if git-python is installed for
python3.

Traceback (most recent call last):
  File "scripts/spdxcheck.py", line 10, in <module>
    import git
ImportError: No module named git

To fix the problem, check for the existence of python3, check if
the script is executable and not just for its existence, and execute
it directly.

Link: https://lkml.kernel.org/r/20210505211720.447111-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Joe Perches <joe@perches.com>
Cc: Bert Vermeulen <bert@biot.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Bert Vermeulen <bert@biot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-scripts-spdxcheckpy-now-requires-python3
+++ a/scripts/checkpatch.pl
@@ -1084,10 +1084,10 @@ sub is_maintained_obsolete {
 sub is_SPDX_License_valid {
 	my ($license) = @_;
 
-	return 1 if (!$tree || which("python") eq "" || !(-e "$root/scripts/spdxcheck.py") || !(-e "$gitroot"));
+	return 1 if (!$tree || which("python3") eq "" || !(-x "$root/scripts/spdxcheck.py") || !(-e "$gitroot"));
 
 	my $root_path = abs_path($root);
-	my $status = `cd "$root_path"; echo "$license" | python scripts/spdxcheck.py -`;
+	my $status = `cd "$root_path"; echo "$license" | scripts/spdxcheck.py -`;
 	return 0 if ($status ne "");
 	return 1;
 }
_

Patches currently in -mm which might be from linux@roeck-us.net are

checkpatch-scripts-spdxcheckpy-now-requires-python3.patch

