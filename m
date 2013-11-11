From: akpm@linux-foundation.org
Subject: [merged]
 scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner.patch
 removed from -mm tree
Date: Mon, 11 Nov 2013 10:44:00 -0800
Message-ID: <52812570.SmvsU+q933sBxyeT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:44:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: [merged] scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner.patch removed from -mm tree
To: josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:44:00 -0800


The patch titled
     Subject: scripts/bloat-o-meter: ignore changes in the size of linux_banner
has been removed from the -mm tree.  Its filename was
     scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: scripts/bloat-o-meter: ignore changes in the size of linux_banner

linux_banner can change size due to changes in the compiler, build number,
or the user@host the system was compiled on; ignore size changes in
linux_banner entirely.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-ignore-changes-in-the-size-of-linux_banner
+++ a/scripts/bloat-o-meter
@@ -20,6 +20,7 @@ def getsizes(file):
         if type in "tTdDbBrR":
             # strip generated symbols
             if name[:6] == "__mod_": continue
+            if name == "linux_banner": continue
             # statics and some other optimizations adds random .NUMBER
             name = re.sub(r'\.[0-9]+', '', name)
             sym[name] = sym.get(name, 0) + int(size, 16)
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
documentation-abi-document-the-non-abi-status-of-kconfig-and-symbols.patch
linux-next.patch

