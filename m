From: akpm@linux-foundation.org
Subject: - scripts-lindent-support-gnu-indent-v2210.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:57 -0700
Message-ID: <200804300540.m3U5ev3a029014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757020AbYD3FmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     scripts/Lindent: support gnu indent v2.2.10
has been removed from the -mm tree.  Its filename was
     scripts-lindent-support-gnu-indent-v2210.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/Lindent: support gnu indent v2.2.10
From: Joe Perches <joe@perches.com>

The new version of indent supports positioning labels in column 1
using "-il0"

http://www.nabble.com/Release-2.2.10-of-GNU-Indent-td15990700.html

Add "-il0" if indent version >= 2.2.10

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Alan Cox <alan@redhat.com>
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

origin.patch
git-cifs.patch
git-kvm.patch
git-unionfs.patch

