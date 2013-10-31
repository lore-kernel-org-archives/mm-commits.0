From: akpm@linux-foundation.org
Subject: +
 scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch
 added to -mm tree
Date: Thu, 31 Oct 2013 14:20:34 -0700
Message-ID: <5272c9a2.ix+zMCMK3L1YHdZW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3JaVUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 17:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: + scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch added to -mm tree
To: josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 14:20:34 -0700


The patch titled
     Subject: scripts/bloat-o-meter: use .startswith rather than fragile slicing
has been added to the -mm tree.  Its filename is
     scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
             # function names begin with '.' on 64-bit powerpc
             if "." in name[1:]: name = "static." + name.split(".")[0]
_

Patches currently in -mm which might be from josh@joshtriplett.org are

checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner.patch
scripts-bloat-o-meter-use-startswith-rather-than-fragile-slicing.patch
linux-next.patch

