From: akpm@linux-foundation.org
Subject: [merged]
 scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch
 removed from -mm tree
Date: Mon, 11 Nov 2013 10:44:02 -0800
Message-ID: <52812572.j+/cjDmCk0OGNpwj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSoC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:44:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: [merged] scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch removed from -mm tree
To: josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:44:02 -0800


The patch titled
     Subject: scripts/bloat-o-meter: use .startswith rather than fragile slicing
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: scripts/bloat-o-meter: use .startswith rather than fragile slicing

str.startswith has existed since at least Python 2.0, in 2000; use it
rather than a fragile comparison against an initial slice of a string,
which requires hard-coding the length of the string to compare against.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing
+++ a/scripts/bloat-o-meter
@@ -19,7 +19,7 @@ def getsizes(file):
         size, type, name = l[:-1].split()
         if type in "tTdDbBrR":
             # strip generated symbols
-            if name[:6] == "__mod_": continue
+            if name.startswith("__mod_"): continue
             if name == "linux_banner": continue
             # statics and some other optimizations adds random .NUMBER
             name = re.sub(r'\.[0-9]+', '', name)
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch
linux-next.patch

