Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C40C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5417061CAB
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhGFTZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229879AbhGFTZg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 904C061C9E;
        Tue,  6 Jul 2021 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599376;
        bh=kiPQn2jkHIQ9qayhRMqbCsuKCOYAdbkke01Rh+FZ0Mw=;
        h=Date:From:To:Subject:From;
        b=BBpHarA6w/Kwc/9LxWLSC4II1LPZkf/RTVC0tsS4+8iSY75Ua1L7IUkh9vYhd+eC5
         TwnEj3XGaaPUz37HD+nBjdzThJmCvqKOB/04Y4t5EZV5dwluQu2ByedjBnzAoF5nkS
         4WRlOK0p8ABkzDyJ8MtgeCjasdghv6rO9zp1z/n0=
Date:   Tue, 06 Jul 2021 12:22:56 -0700
From:   akpm@linux-foundation.org
To:     bert@biot.com, dwaipayanray1@gmail.com, joe@perches.com,
        linux@roeck-us.net, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-scripts-spdxcheckpy-now-requires-python3.patch removed from -mm
 tree
Message-ID: <20210706192256.dMh5usemP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: scripts/spdxcheck.py now requires python3
has been removed from the -mm tree.  Its filename was
     checkpatch-scripts-spdxcheckpy-now-requires-python3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


