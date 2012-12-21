From: akpm@linux-foundation.org
Subject: [merged] checkpatch-warn-on-uapi-includes-that-include-uapi.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:00 -0800
Message-ID: <20121221204001.2437A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:55627 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2LUUkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:04 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so259705lag.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: warn on uapi #includes that #include <uapi/...
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-on-uapi-includes-that-include-uapi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: warn on uapi #includes that #include <uapi/...

Avoid specifying internal uapi #include paths with uapi/...  as userspace
should not use and never see that.

Neaten message line wrapping above.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-warn-on-uapi-includes-that-include-uapi scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-warn-on-uapi-includes-that-include-uapi
+++ a/scripts/checkpatch.pl
@@ -2226,8 +2226,11 @@ sub process {
 			my $path = $1;
 			if ($path =~ m{//}) {
 				ERROR("MALFORMED_INCLUDE",
-				      "malformed #include filename\n" .
-					$herecurr);
+				      "malformed #include filename\n" . $herecurr);
+			}
+			if ($path =~ "^uapi/" && $realfile =~ m@\binclude/uapi/@) {
+				ERROR("UAPI_INCLUDE",
+				      "No #include in ...include/uapi/... should use a uapi/ path prefix\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

