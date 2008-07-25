From: akpm@linux-foundation.org
Subject: - fix-checkstackpl-arch-detection.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:13 -0700
Message-ID: <200807252254.m6PMsDaE002794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbYGYWyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix checkstack.pl arch detection
has been removed from the -mm tree.  Its filename was
     fix-checkstackpl-arch-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix checkstack.pl arch detection
From: Eric Sandeen <sandeen@redhat.com>

uname -m was leaving a newline in $arch, and not passing the tests.

Also, printing the unknown arch on failure is probably helpful.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkstack.pl~fix-checkstackpl-arch-detection scripts/checkstack.pl
--- a/scripts/checkstack.pl~fix-checkstackpl-arch-detection
+++ a/scripts/checkstack.pl
@@ -36,6 +36,7 @@ my (@stack, $re, $dre, $x, $xs);
 	my $arch = shift;
 	if ($arch eq "") {
 		$arch = `uname -m`;
+		chomp($arch);
 	}
 
 	$x	= "[0-9a-f]";	# hex character
@@ -91,7 +92,7 @@ my (@stack, $re, $dre, $x, $xs);
 		#   0:   00 e8 38 01     LINK 0x4e0;
 		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
 	} else {
-		print("wrong or unknown architecture\n");
+		print("wrong or unknown architecture \"$arch\"\n");
 		exit
 	}
 }
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
linux-next.patch

