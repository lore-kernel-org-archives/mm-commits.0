From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-default-to-not-include-unspecified-tags.patch added to -mm tree
Date: Wed, 12 May 2010 16:18:48 -0700
Message-ID: <201005122318.o4CNInV4026801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755803Ab0ELXTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@mickler.org, joe@perches.com, stefanr@s5r6.in-berlin.de, w.sang@pengutronix.de


The patch titled
     scripts/get_maintainer.pl: default to not include unspecified tags
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-default-to-not-include-unspecified-tags.patch

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
Subject: scripts/get_maintainer.pl: default to not include unspecified tags
From: Florian Mickler <florian@mickler.org>

This changes the default of the option --git-all-signature-types to be
disabled by default.

The effect being, that only certain (currently Signed-Off-By:, Acked-by:
and Reviewed-By:) tags are used to get adresses of potential maintainers.

Motivated is this change by the desire to not 'spam' people unnecessary: A
Tested-By or a Reported-By is not ment as a hint that those people want
to/are able to review patches to the code in question.

In a quest to find resilient statistics for this i came up with this:

I produced a list of all the tag-signers not already covered with a
signed-off/acked/reviewed tag somewhere in the last year of git history.

Those were 650 addresses of "assumed non-developers".

And to check if those "assumed non-developers" are professional
testers/reporters worth cc'ing, i then counted their total appearences
in the git log:

469 were mentioned only once.
123 were mentioned twice.
38 three times
8 four times
5 six times
5 five times
1 eight times
1 fourteen times

I believe this supports my thesis, that the ''non-maintainer-tags'' are
not actively useful for patch-review.  (except probably the guy mentioned
fourteen times...)

But of course one could also find arguments to poke holes in this
statistics, for example does this statistic not include code-locality: A
tested-by on a patch that touches some specific piece of code can be more
worth than a signed-off in another part of the tree.

But...  let's play it safe and let's err on the "safe" side meaning to not
spam those people when in doubt.  We already have the signed-off's and
Maintainers file.  So this should be ok.  And if need be, the maintainers
can always forward the patch.

[i probably could make a diploma thesis out of this changelog :)]

Signed-off-by: Florian Mickler <florian@mickler.org>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Joe Perches <joe@perches.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-default-to-not-include-unspecified-tags scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-default-to-not-include-unspecified-tags
+++ a/scripts/get_maintainer.pl
@@ -25,7 +25,7 @@ my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
 my $email_git = 1;
-my $email_git_all_signature_types = 1;
+my $email_git_all_signature_types = 0;
 my $email_git_blame = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
_

Patches currently in -mm which might be from florian@mickler.org are

linux-next.patch
scripts-get_maintainerpl-optionally-ignore-non-maintainer-signatures.patch
scripts-get_maintainerpl-add-get_maintainerconf-default-options-file.patch
scripts-get_maintainerpl-default-to-not-include-unspecified-tags.patch

