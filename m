From: akpm@linux-foundation.org
Subject: + get_maintainerspl-follow-renames-when-looking-up-commit-signers.patch added to -mm tree
Date: Mon, 14 Nov 2011 16:06:57 -0800
Message-ID: <201111150007.pAF06v7r010407@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46029 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1KOAHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 19:07:05 -0500
Received: by vcbfy13 with SMTP id fy13so557295vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 16:07:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Ian.Campbell@citrix.com, joe@perches.com


The patch titled
     Subject: get_maintainers.pl: follow renames when looking up commit signers
has been added to the -mm tree.  Its filename is
     get_maintainerspl-follow-renames-when-looking-up-commit-signers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ian Campbell <Ian.Campbell@citrix.com>
Subject: get_maintainers.pl: follow renames when looking up commit signers

I happen to have had a commit to various network drivers since the big
renaming/reorg which happened to drivers/net recently.  This means that I
now appear to be in the top few commit signers (by %age) for many of them
so am getting sent all sorts of stuff and people who are involved with the
driver are not.  e.g.  (to pick one at random):

        $ ./scripts/get_maintainer.pl -f drivers/net/ethernet/nvidia/forcedeth.c
        "David S. Miller" <davem@davemloft.net> (commit_signer:5/7=71%)
        Ian Campbell <ian.campbell@citrix.com> (commit_signer:2/7=29%)
        Eric Dumazet <eric.dumazet@gmail.com> (commit_signer:1/7=14%)
        Jeff Kirsher <jeffrey.t.kirsher@intel.com> (commit_signer:1/7=14%)
        Jiri Pirko <jpirko@redhat.com> (commit_signer:1/7=14%)
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
        linux-kernel@vger.kernel.org (open list)

With the following patch the renames are followed and the result appears
much more sensible:

        $ ./scripts/get_maintainer.pl -f drivers/net/ethernet/nvidia/forcedeth.c
        "David S. Miller" <davem@davemloft.net> (commit_signer:31/34=91%)
        Joe Perches <joe@perches.com> (commit_signer:11/34=32%)
        Szymon Janc <szymon@janc.net.pl> (commit_signer:5/34=15%)
        Jiri Pirko <jpirko@redhat.com> (commit_signer:3/34=9%)
        Paul <paul.gortmaker@windriver.com> (commit_signer:2/34=6%)
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
        linux-kernel@vger.kernel.org (open list)

Signed-off-by: Ian Campbell <Ian.Campbell@citrix.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainerspl-follow-renames-when-looking-up-commit-signers scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainerspl-follow-renames-when-looking-up-commit-signers
+++ a/scripts/get_maintainer.pl
@@ -95,7 +95,7 @@ my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
     "find_signers_cmd" =>
-	"git log --no-color --since=\$email_git_since " .
+	"git log --no-color --follow --since=\$email_git_since " .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
_
Subject: Subject: get_maintainers.pl: follow renames when looking up commit signers

Patches currently in -mm which might be from Ian.Campbell@citrix.com are

get_maintainerspl-follow-renames-when-looking-up-commit-signers.patch

