From: akpm@linux-foundation.org
Subject: + scripts-lindent-support-gnu-indent-v2210.patch added to -mm tree
Date: Tue, 25 Mar 2008 15:49:49 -0700
Message-ID: <200803252249.m2PMnn8O017576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbYCYWut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 18:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     scripts/Lindent: support gnu indent v2.2.10
has been added to the -mm tree.  Its filename is
     scripts-lindent-support-gnu-indent-v2210.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/Lindent: support gnu indent v2.2.10
From: Joe Perches <joe@perches.com>

The new version of indent supports positioning labels in column 1
using "-il0"

http://www.nabble.com/Release-2.2.10-of-GNU-Indent-td15990700.html

Add "-il0" if indent version >= 2.2.10

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Lindent |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN scripts/Lindent~scripts-lindent-support-gnu-indent-v2210 scripts/Lindent
--- a/scripts/Lindent~scripts-lindent-support-gnu-indent-v2210
+++ a/scripts/Lindent
@@ -1,2 +1,18 @@
 #!/bin/sh
-indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1 "$@"
+PARAM="-npro -kr -i8 -ts8 -sob -l80 -ss -ncs -cp1"
+RES=`indent --version`
+V1=`echo $RES | cut -d' ' -f3 | cut -d'.' -f1`
+V2=`echo $RES | cut -d' ' -f3 | cut -d'.' -f2`
+V3=`echo $RES | cut -d' ' -f3 | cut -d'.' -f3`
+if [ $V1 -gt 2 ]; then
+  PARAM="$PARAM -il0"
+elif [ $V1 -eq 2 ]; then
+  if [ $V2 -gt 2 ]; then
+    PARAM="$PARAM -il0";
+  elif [ $V2 -eq 2 ]; then
+    if [ $V3 -ge 10 ]; then
+      PARAM="$PARAM -il0"
+    fi
+  fi
+fi
+indent $PARAM "$@"
_

Patches currently in -mm which might be from joe@perches.com are

git-kvm.patch
git-net.patch
git-unionfs.patch
synclink-drivers-bool-conversion.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
scripts-lindent-support-gnu-indent-v2210.patch

