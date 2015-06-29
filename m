From: akpm@linux-foundation.org
Subject: [merged] checkpatch-validate-module_license-content.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:57 -0700
Message-ID: <5591af39.a5SiVDYunYrnJa5y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbF2Us5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.andersson@sonymobile.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: validate MODULE_LICENSE content
has been removed from the -mm tree.  Its filename was
     checkpatch-validate-module_license-content.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: checkpatch: validate MODULE_LICENSE content

There is a well defined list of expected values for MODULE_LICENSE so warn
the user upon usage of unknown values.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-validate-module_license-content scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-validate-module_license-content
+++ a/scripts/checkpatch.pl
@@ -5626,6 +5626,24 @@ sub process {
 				}
 			}
 		}
+
+# validate content of MODULE_LICENSE against list from include/linux/module.h
+		if ($line =~ /\bMODULE_LICENSE\s*\(\s*($String)\s*\)/) {
+			my $extracted_string = get_quoted_string($line, $rawline);
+			my $valid_licenses = qr{
+						GPL|
+						GPL\ v2|
+						GPL\ and\ additional\ rights|
+						Dual\ BSD/GPL|
+						Dual\ MIT/GPL|
+						Dual\ MPL/GPL|
+						Proprietary
+					}x;
+			if ($extracted_string !~ /^"(?:$valid_licenses)"$/x) {
+				WARN("MODULE_LICENSE",
+				     "unknown module license " . $extracted_string . "\n" . $herecurr);
+			}
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from bjorn.andersson@sonymobile.com are

origin.patch
linux-next.patch

