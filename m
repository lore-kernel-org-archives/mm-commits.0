From: akpm@linux-foundation.org
Subject: [merged] bloat-o-meter-include-read-only-data-section-in-report.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:21 -0700
Message-ID: <201103232044.p2NKiv0C029140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933502Ab1CWUpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, andi@firstfloor.org, ntl@pobox.com, mm-commits@vger.kernel.org


The patch titled
     bloat-o-meter: include read-only data section in report
has been removed from the -mm tree.  Its filename was
     bloat-o-meter-include-read-only-data-section-in-report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bloat-o-meter: include read-only data section in report
From: Jean Delvare <khali@linux-fr.org>

I'm not sure why the read-only data section is excluded from the report,
it seems as relevant as the other data sections (b and d).

I've stripped the symbols starting with __mod_ as they can have their
names dynamically generated and thus comparison between binaries is not
possible.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: Nathan Lynch <ntl@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/bloat-o-meter~bloat-o-meter-include-read-only-data-section-in-report scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~bloat-o-meter-include-read-only-data-section-in-report
+++ a/scripts/bloat-o-meter
@@ -17,7 +17,9 @@ def getsizes(file):
     sym = {}
     for l in os.popen("nm --size-sort " + file).readlines():
         size, type, name = l[:-1].split()
-        if type in "tTdDbB":
+        if type in "tTdDbBrR":
+            # strip generated symbols
+            if name[:6] == "__mod_": continue
             # function names begin with '.' on 64-bit powerpc
             if "." in name[1:]: name = "static." + name.split(".")[0]
             sym[name] = sym.get(name, 0) + int(size, 16)
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch

