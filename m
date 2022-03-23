Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB33C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345407AbiCWXHq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345394AbiCWXHk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067949025D
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7285B82181
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E217C340E8;
        Wed, 23 Mar 2022 23:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076766;
        bh=PORcXoKh9ikcpSwJrXxJv1CqfS82VJJi9nCh7sf/4tM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=AxEFl7W3eM61RYA84zTdLPfuAulmrhhfXAVxIm6V0HFdHHandFT+EOGbdYDMtDnGs
         /J//oybSi26vvwiQBZjvnDqK1Vrs210Q3Nxh5kEc68eyeR/wEOerbzAB0eK/HlNfHL
         SF1xc4xBFeM9RX85RXDUgdFtCJgKo3tOCdWLS1LE=
Date:   Wed, 23 Mar 2022 16:06:05 -0700
To:     peter.ujfalusi@linux.intel.com, joe@perches.com,
        sagarmp@cs.unc.edu, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 16/41] checkpatch: use python3 to find codespell dictionary
Message-Id: <20220323230606.4E217C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
