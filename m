From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 scripts-get_maintainerpl-deprioritize-old-fixes-addresses.patch added to
 -mm tree
Date: Sun, 09 Feb 2020 20:37:40 -0800
Message-ID: <20200210043740.RN2WpXaLa%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgBJEhm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 23:37:42 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agross@kernel.org, bjorn.andersson@linaro.org, dan.carpenter@oracle.com, dianders@chromium.org, gregkh@linuxfoundation.org, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, sboyd@kernel.org


The patch titled
     Subject: scripts/get_maintainer.pl: deprioritize old Fixes: addresses
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-deprioritize-old-fixes-addresses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-get_maintainerpl-deprioritize-old-fixes-addresses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-get_maintainerpl-deprioritize-old-fixes-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
