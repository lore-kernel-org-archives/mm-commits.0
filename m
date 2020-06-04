From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 084/127] checkpatch: look for c99 comments in
 ctx_locate_comment
Date: Thu, 04 Jun 2020 16:50:36 -0700
Message-ID: <20200604235036.q8HClPsmV%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgFDXui (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:50:38 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, apw@canonical.com, dvyukov@google.com, elver@google.com, glider@google.com, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, paulmck@kernel.org, torvalds@linux-foundation.org, will@kernel.org

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
@@ -1676,8 +1676,16 @@ sub ctx_statement_level {
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
