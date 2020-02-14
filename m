From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-support-base-commit-format.patch added to
 -mm tree
Date: Thu, 13 Feb 2020 21:10:04 -0800
Message-ID: <20200214051004.YOoVBjhtO%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgBNFKG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:10:06 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, corbet@lwn.net, jhubbard@nvidia.com, joe@perches.com, konstantin@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: support "base-commit:" format
has been added to the -mm tree.  Its filename is
     checkpatch-support-base-commit-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-support-base-commit-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-support-base-commit-format.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: checkpatch: support "base-commit:" format

In order to support the get-lore-mbox.py tool described in [1], I ran:

    git format-patch --base=<commit> --cover-letter <revrange>

...  which generated a "base-commit: <commit-hash>" tag at the end of the
cover letter.  However, checkpatch.pl generated an error upon encounting
"base-commit:" in the cover letter:

    "ERROR: Please use git commit description style..."

...  because it found the "commit" keyword, and failed to recognize that
it was part of the "base-commit" phrase, and as such, should not be
subjected to the same commit description style rules.

Update checkpatch.pl to include a special case for "base-commit:" (at the
start of the line, possibly with some leading whitespace) so that that tag
no longer generates a checkpatch error.

[1] https://lwn.net/Articles/811528/ "Better tools for kernel
    developers"

Link: http://lkml.kernel.org/r/20200213055004.69235-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-support-base-commit-format
+++ a/scripts/checkpatch.pl
@@ -2794,7 +2794,7 @@ sub process {
 
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
-		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink):/i &&
+		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
 		    $line !~ /^This reverts commit [0-9a-f]{7,40}/ &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
 		     ($line =~ /(?:\s|^)[0-9a-f]{12,40}(?:[\s"'\(\[]|$)/i &&
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-split-get_user_pages_remote-into-two-routines.patch
mm-gup-pass-a-flags-arg-to-__gup_device_-functions.patch
mm-introduce-page_ref_sub_return.patch
mm-gup-pass-gup-flags-to-two-more-routines.patch
mm-gup-require-foll_get-for-get_user_pages_fast.patch
mm-gup-track-foll_pin-pages.patch
mm-gup-page-hpage_pinned_refcount-exact-pin-counts-for-huge-pages.patch
mm-gup-proc-vmstat-pin_user_pages-foll_pin-reporting.patch
mm-gup_benchmark-support-pin_user_pages-and-related-calls.patch
selftests-vm-run_vmtests-invoke-gup_benchmark-with-basic-foll_pin-coverage.patch
mm-dump_page-additional-diagnostics-for-huge-pinned-pages.patch
checkpatch-support-base-commit-format.patch
