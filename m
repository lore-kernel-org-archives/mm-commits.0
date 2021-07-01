Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6412AC11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E8C6146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbhGAB6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238562AbhGAB6u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B582D61418;
        Thu,  1 Jul 2021 01:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104580;
        bh=Nymilikzj/TnMBVrVhiFvZvmgWHcPO+Rl9MvzE+2fIo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g3rwObb+LFzA9X7OTSEqBYRZyg4IdF/teqtQjqSy06lnqxvvStf6rncV7dJYisv6U
         Dkpq+pQAHsXcQd2r5tQu4X41m0u/cUY2ULWgcFlmuqt1QvihsYwLhRCs8/tjOoMmh+
         0CDTQLa8T17IIF9t8VOV0GJ3Vt9nSjgHi9mwqZjE=
Date:   Wed, 30 Jun 2021 18:56:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bert@biot.com, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, linux@roeck-us.net,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 173/192] checkpatch: scripts/spdxcheck.py now
 requires python3
Message-ID: <20210701015619.3yumN4pdi%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
