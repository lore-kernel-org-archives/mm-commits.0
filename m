From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:19 -0800
Message-ID: <54e2504f.DXK+DX3UKdxxTIrs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbBPURz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add ability to coalesce commit descriptions on multiple lines
has been removed from the -mm tree.  Its filename was
     checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add ability to coalesce commit descriptions on multiple lines

If a git commit description is split on consecutive lines, coalesce it
before testing.

This allows:

  commit <foo> ("some long
  description")

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines
+++ a/scripts/checkpatch.pl
@@ -2198,6 +2198,13 @@ sub process {
 				 defined $rawlines[$linenr] &&
 				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
 				$orig_desc = $1;
+			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("[^"]+$/i &&
+				 defined $rawlines[$linenr] &&
+				 $rawlines[$linenr] =~ /^\s*[^"]+"\)/) {
+				$line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)$/i;
+				$orig_desc = $1;
+				$rawlines[$linenr] =~ /^\s*([^"]+)"\)/;
+				$orig_desc .= " " . $1;
 			}
 
 			($id, $description) = git_commit_info($orig_commit,
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

