Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA47C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 20:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiCIU6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 15:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiCIU6O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 15:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4D571EF8
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 12:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 897F3B823D6
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 20:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B64C340E8;
        Wed,  9 Mar 2022 20:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646859432;
        bh=oBBQDiU/ibIMxoftxh10WolCdcNFU2MBWCxoNjVnc38=;
        h=Date:To:From:Subject:From;
        b=JMYzsYgM9xk1Ips3AJHlJQF9VpWT1dL97fpL5s4dL2aphebeK7Qv2m/QuJg0bexHI
         jPMWnIbRqwDQ5JxBg4UxFUPA4o2qxWgWg0ZdMQPPMnFyNn6WYcb9/sWYBCStibFGtL
         TNqsqqmb1foCJgCmV68cei0Y3U0aXGhGqD/MaK3E=
Date:   Wed, 09 Mar 2022 12:57:11 -0800
To:     mm-commits@vger.kernel.org, peter.ujfalusi@linux.intel.com,
        joe@perches.com, sagarmp@cs.unc.edu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-use-python3-to-find-codespell-dictionary.patch added to -mm tree
Message-Id: <20220309205712.31B64C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use python3 to find codespell dictionary
has been added to the -mm tree.  Its filename is
     checkpatch-use-python3-to-find-codespell-dictionary.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-use-python3-to-find-codespell-dictionary.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-use-python3-to-find-codespell-dictionary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sagar Patel <sagarmp@cs.unc.edu>
Subject: checkpatch: use python3 to find codespell dictionary

Commit 0ee3e7b8893e ("checkpatch: get default codespell dictionary path
from package location") introduced the ability to search for the codespell
dictionary rather than hardcoding its path.

codespell requires Python 3.6 or above, but on some systems, the python
executable is a Python 2.7 interpreter.  In this case, searching for the
dictionary fails, subsequently making codespell fail:

No codespell typos will be found - file '/usr/share/codespell/dictionary.txt': No such file or directory

So, use python3 to remove ambiguity.

In addition, when searching for dictionary.txt, do not check if the
codespell executable exists since,

  - checkpatch.pl only uses dictionary.txt, not the codespell
    executable.
  - codespell can be installed via a Python package manager, in which
    case the codespell executable may not be present in a typical $PATH,
    but a dictionary does exist.

Link: https://lkml.kernel.org/r/20220309180048.147672-1-sagarmp@cs.unc.edu
Signed-off-by: Sagar Patel <sagarmp@cs.unc.edu>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-use-python3-to-find-codespell-dictionary
+++ a/scripts/checkpatch.pl
@@ -334,7 +334,7 @@ if ($user_codespellfile) {
 } elsif (!(-f $codespellfile)) {
 	# If /usr/share/codespell/dictionary.txt is not present, try to find it
 	# under codespell's install directory: <codespell_root>/data/dictionary.txt
-	if (($codespell || $help) && which("codespell") ne "" && which("python") ne "") {
+	if (($codespell || $help) && which("python3") ne "") {
 		my $python_codespell_dict = << "EOF";
 
 import os.path as op
@@ -344,7 +344,7 @@ codespell_file = op.join(codespell_dir,
 print(codespell_file, end='')
 EOF
 
-		my $codespell_dict = `python -c "$python_codespell_dict" 2> /dev/null`;
+		my $codespell_dict = `python3 -c "$python_codespell_dict" 2> /dev/null`;
 		$codespellfile = $codespell_dict if (-f $codespell_dict);
 	}
 }
_

Patches currently in -mm which might be from sagarmp@cs.unc.edu are

checkpatch-use-python3-to-find-codespell-dictionary.patch

