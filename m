From: akpm@linux-foundation.org
Subject: +
 checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch added to -mm
 tree
Date: Wed, 15 Apr 2020 21:02:34 -0700
Message-ID: <20200416040234.LRCzpc-I6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgDPECh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 00:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, apw@canonical.com, dvyukov@google.com, elver@google.com, glider@google.com, joe@perches.com, mm-commits@vger.kernel.org, paulmck@kernel.org, will@kernel.org


The patch titled
     Subject: checkpatch: look for c99 comments in ctx_locate_comment
has been added to the -mm tree.  Its filename is
     checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: look for c99 comments in ctx_locate_comment

Some checks look for comments around a specific function like
read_barrier_depends.

Extend the check to support both c89 and c90 comment styles.

	c89 /* comment */
or
	c99 // comment

For c99 comments, only look a 3 single lines, the line being scanned,
the line above and the line below the line being scanned rather than
the patch diff context.

Link: http://lkml.kernel.org/r/65cb075435d2f385a53c77571b491b2b09faaf8e.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-look-for-c99-comments-in-ctx_locate_comment
+++ a/scripts/checkpatch.pl
@@ -1674,8 +1674,16 @@ sub ctx_statement_level {
 sub ctx_locate_comment {
 	my ($first_line, $end_line) = @_;
 
+	# If c99 comment on the current line, or the line before or after
+	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@^\+.*(//.*$)@);
+	return $current_comment if (defined $current_comment);
+	($current_comment) = ($rawlines[$end_line - 2] =~ m@^[\+ ].*(//.*$)@);
+	return $current_comment if (defined $current_comment);
+	($current_comment) = ($rawlines[$end_line] =~ m@^[\+ ].*(//.*$)@);
+	return $current_comment if (defined $current_comment);
+
 	# Catch a comment on the end of the line itself.
-	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*(?:\\\s*)?$@);
+	($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*(?:\\\s*)?$@);
 	return $current_comment if (defined $current_comment);
 
 	# Look through the context and try and figure out if there is a
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-additional-maintainer-section-entry-ordering-checks.patch
checkpatch-look-for-c99-comments-in-ctx_locate_comment.patch
