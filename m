From: akpm@linux-foundation.org
Subject: [merged]
 scripts-get_maintainerpl-deprioritize-old-fixes-addresses.patch removed
 from -mm tree
Date: Sun, 23 Feb 2020 16:44:46 -0800
Message-ID: <20200224004446.bFbqKt9Ld%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXAor (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agross@kernel.org, bjorn.andersson@linaro.org, dan.carpenter@oracle.com, dianders@chromium.org, gregkh@linuxfoundation.org, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, sboyd@kernel.org


The patch titled
     Subject: scripts/get_maintainer.pl: deprioritize old Fixes: addresses
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-deprioritize-old-fixes-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: scripts/get_maintainer.pl: deprioritize old Fixes: addresses

Recently, I found that get_maintainer was causing me to send emails to the
old addresses for maintainers.  Since I usually just trust the output of
get_maintainer to know the right email address, I didn't even look
carefully and fired off two patch series that went to the wrong place. 
Oops.

The problem was introduced recently when trying to add signatures from
Fixes.  The problem was that these email addresses were added too early in
the process of compiling our list of places to send.  Things added to the
list earlier are considered more canonical and when we later added
maintainer entries we ended up deduplicating to the old address.

Here are two examples using mainline commits (to make it easier to
replicate) for the two maintainers that I messed up recently:

$ git format-patch d8549bcd0529~..d8549bcd0529
$ ./scripts/get_maintainer.pl 0001-clk-Add-clk_hw*.patch | grep Boyd
Stephen Boyd <sboyd@codeaurora.org>...

$ git format-patch 6d1238aa3395~..6d1238aa3395
$ ./scripts/get_maintainer.pl 0001-arm64-dts-qcom-qcs404*.patch | grep Andy
Andy Gross <andy.gross@linaro.org>

Let's move the adding of addresses from Fixes: to the end since the
email addresses from these are much more likely to be older.

After this patch the above examples get the right addresses for the
two examples.

Link: http://lkml.kernel.org/r/20200127095001.1.I41fba9f33590bfd92cd01960161d8384268c6569@changeid
Fixes: 2f5bd343694e ("scripts/get_maintainer.pl: add signatures from Fixes: <badcommit> lines in commit message")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-deprioritize-old-fixes-addresses
+++ a/scripts/get_maintainer.pl
@@ -932,10 +932,6 @@ sub get_maintainers {
 	}
     }
 
-    foreach my $fix (@fixes) {
-	vcs_add_commit_signers($fix, "blamed_fixes");
-    }
