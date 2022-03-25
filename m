Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1CEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345878AbiCYBhH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357500AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2915E340D5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9FB560A66
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA77C340EE;
        Fri, 25 Mar 2022 01:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172035;
        bh=SudPwQkYZaKRMHxbj3cu4vYVgj66fwWm8p9530e4EX0=;
        h=Date:To:From:Subject:From;
        b=W7GfyuZMEWKAIgMuzUoHv1/Qq8VPNKf0sXjW8wSuvJnf/PT4mi2rp9g/hrhsDzFaM
         0pHG97mufKnAigwY25n3qTghFmsYsHC3nZwXV1B/9BmSozCxBmQJ0PjUahtvCM9wZP
         Y2eGxXn3jxWjfJB2ZtLoyJ/Y3o+wYCXDN5vv+/14=
Date:   Thu, 24 Mar 2022 18:33:54 -0700
To:     mm-commits@vger.kernel.org, peter.ujfalusi@linux.intel.com,
        joe@perches.com, sagarmp@cs.unc.edu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] checkpatch-use-python3-to-find-codespell-dictionary.patch removed from -mm tree
Message-Id: <20220325013355.1CA77C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use python3 to find codespell dictionary
has been removed from the -mm tree.  Its filename was
     checkpatch-use-python3-to-find-codespell-dictionary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


