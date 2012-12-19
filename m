From: akpm@linux-foundation.org
Subject: + checkpatch-warn-on-uapi-includes-that-include-uapi.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:43:54 -0800
Message-ID: <20121219224354.A3B7C82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:63158 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2LSWnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:43:55 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so295538yen.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:43:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, dhowells@redhat.com


The patch titled
     Subject: checkpatch: warn on uapi #includes that #include <uapi/...
has been added to the -mm tree.  Its filename is
     checkpatch-warn-on-uapi-includes-that-include-uapi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
checkpatch-warn-on-uapi-includes-that-include-uapi.patch

