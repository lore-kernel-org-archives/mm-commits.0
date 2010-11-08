From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-use-git-fallback-more-often.patch added to -mm tree
Date: Mon, 08 Nov 2010 14:44:27 -0800
Message-ID: <201011082244.oA8MiRmo014173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457Ab0KHWo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 17:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/get_maintainer.pl:  use --git-fallback more often
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-use-git-fallback-more-often.patch

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
Subject: scripts/get_maintainer.pl:  use --git-fallback more often
From: Joe Perches <joe@perches.com>

On Fri, 2010-11-05 at 13:50 -0700, Andrew Morton wrote:
> z:/usr/src/git26> perl scripts/get_maintainer.pl -file mm/mempolicy.c
> linux-mm@kvack.org
> linux-kernel@vger.kernel.org

Turns out this is an arguable defect in the script.

The MAINTAINERS entry for mm is:

MEMORY MANAGEMENT
L:	linux-mm@kvack.org
W:	http://www.linux-mm.org
S:	Maintained
F:	include/linux/mm.h
F:	mm/

There's a maintainer entry, but no named individual, so the script doesn't
use git history via --git-fallback.

This is also a defect for MAINTAINERS with status entries marked "Orphan"
or "Odd fixes".

The script now checks a section for any "M:" entry and that an "S:" entry
is supported or maintained.  If both those conditions are not satisified,
use --git-fallback as appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   38 +++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-use-git-fallback-more-often scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-use-git-fallback-more-often
+++ a/scripts/get_maintainer.pl
@@ -494,6 +494,40 @@ if ($web) {
 
 exit($exit);
 
+sub range_is_maintained {
+    my ($start, $end) = @_;
+
+    for (my $i = $start; $i < $end; $i++) {
+	my $line = $typevalue[$i];
+	if ($line =~ m/^(\C):\s*(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'S') {
+		if ($value =~ /(maintain|support)/i) {
+		    return 1;
+		}
+	    }
+	}
+    }
+    return 0;
+}
+
+sub range_has_maintainer {
+    my ($start, $end) = @_;
+
+    for (my $i = $start; $i < $end; $i++) {
+	my $line = $typevalue[$i];
+	if ($line =~ m/^(\C):\s*(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'M') {
+		return 1;
+	    }
+	}
+    }
+    return 0;
+}
+
 sub get_maintainers {
     %email_hash_name = ();
     %email_hash_address = ();
@@ -556,7 +590,9 @@ sub get_maintainers {
 				my $file_pd = ($file  =~ tr@/@@);
 				$value_pd++ if (substr($value,-1,1) ne "/");
 				$value_pd = -1 if ($value =~ /^\.\*/);
-				if ($value_pd >= $file_pd) {
+				if ($value_pd >= $file_pd &&
+				    range_is_maintained($start, $end) &&
+				    range_has_maintainer($start, $end)) {
 				    $exact_pattern_match_hash{$file} = 1;
 				}
 				if ($pattern_depth == 0 ||
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch
scripts-get_maintainerpl-make-rolestats-the-default.patch
scripts-get_maintainerpl-use-git-fallback-more-often.patch
maintainers-intel-gfx-is-a-subscribers-only-mailing-list.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch

