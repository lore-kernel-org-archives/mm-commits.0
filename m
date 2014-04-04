From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-vendor-compatible-with-dashes.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:16 -0700
Message-ID: <533f0938.dDWm5Xw5wkY7d4c+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaDDTeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh@kernel.org, joe@perches.com, florian.vaussard@epfl.ch

Subject: [merged] checkpatch-check-vendor-compatible-with-dashes.patch removed from -mm tree
To: florian.vaussard@epfl.ch,joe@perches.com,robh@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:16 -0700


The patch titled
     Subject: checkpatch: check vendor compatible with dashes
has been removed from the -mm tree.  Its filename was
     checkpatch-check-vendor-compatible-with-dashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Vaussard <florian.vaussard@epfl.ch>
Subject: checkpatch: check vendor compatible with dashes

The current vendor compatible check will not match vendors with
dashes, like:

compatible="asahi-kasei"

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Reported-by: Joe Perches <joe@perches.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-vendor-compatible-with-dashes scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-vendor-compatible-with-dashes
+++ a/scripts/checkpatch.pl
@@ -2091,7 +2091,7 @@ sub process {
 				my $vendor = $compat;
 				my $vendor_path = $dt_path . "vendor-prefixes.txt";
 				next if (! -f $vendor_path);
-				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
+				$vendor =~ s/^([a-zA-Z0-9\-]+)\,.*/$1/;
 				`grep -Eq "$vendor" $vendor_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
_

Patches currently in -mm which might be from florian.vaussard@epfl.ch are

origin.patch
linux-next.patch

