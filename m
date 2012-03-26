From: akpm@linux-foundation.org
Subject: [merged] checkpatch-handle-string-concatenation-in-simple-defines.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:22 -0700
Message-ID: <20120326193022.57A7DA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:55314 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2CZTaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:24 -0400
Received: by wgbdt11 with SMTP id dt11so210331wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: handle string concatenation in simple #defines
has been removed from the -mm tree.  Its filename was
     checkpatch-handle-string-concatenation-in-simple-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: handle string concatenation in simple #defines

Adjacent strings indicate concatentation, therefore look at identifiers
directly adjacent to literal strings as strings too.  This allows us to
better detect the form below and accept it as a simple constant:

    #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-handle-string-concatenation-in-simple-defines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-string-concatenation-in-simple-defines
+++ a/scripts/checkpatch.pl
@@ -2894,6 +2894,12 @@ sub process {
 			{
 			}
 
+			# Flatten any obvious string concatentation.
+			while ($dstat =~ s/("X*")\s*$Ident/$1/ ||
+			       $dstat =~ s/$Ident\s*("X*")/$1/)
+			{
+			}
+
 			my $exceptions = qr{
 				$Declare|
 				module_param_named|
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

