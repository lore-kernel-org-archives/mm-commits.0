From: akpm@linux-foundation.org
Subject: [merged] checkpatchpl-be-silent-when-q-and-ignore-is-given.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:16 -0700
Message-ID: <20120326193016.B8715A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:56973 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2CZTaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:17 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so831473ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dedekind1@gmail.com, apw@canonical.com, artem.bityutskiy@linux.intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch.pl: be silent when -q and --ignore is given
has been removed from the -mm tree.  Its filename was
     checkpatchpl-be-silent-when-q-and-ignore-is-given.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: checkpatch.pl: be silent when -q and --ignore is given

Fix checkpatch.pl when both -q and --ignore are given and prevents it from
printing a

NOTE: Ignored message types: blah

messages.

E.g., if I use -q --ignore PREFER_PACKED,PREFER_ALIGNED, i see:

NOTE: Ignored message types: PREFER_ALIGNED PREFER_PACKED

It makes no sense to print this when -q is given.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-be-silent-when-q-and-ignore-is-given scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-be-silent-when-q-and-ignore-is-given
+++ a/scripts/checkpatch.pl
@@ -3474,13 +3474,12 @@ sub process {
 		}
 	}
 
-	if (keys %ignore_type) {
+	if ($quiet == 0 && keys %ignore_type) {
 	    print "NOTE: Ignored message types:";
 	    foreach my $ignore (sort keys %ignore_type) {
 		print " $ignore";
 	    }
-	    print "\n";
-	    print "\n" if ($quiet == 0);
+	    print "\n\n";
 	}
 
 	if ($clean == 1 && $quiet == 0) {
_

Patches currently in -mm which might be from dedekind1@gmail.com are

origin.patch
linux-next.patch

