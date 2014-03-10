From: akpm@linux-foundation.org
Subject: + checkpatch-check-vendor-compatible-with-dashes.patch added to
 -mm tree
Date: Mon, 10 Mar 2014 12:09:23 -0700
Message-ID: <531e0de3.hartJxg+KhGxFlBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaCJTJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh@kernel.org, joe@perches.com, florian.vaussard@epfl.ch

Subject: + checkpatch-check-vendor-compatible-with-dashes.patch added to -mm tree
To: florian.vaussard@epfl.ch,joe@perches.com,robh@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:09:23 -0700


The patch titled
     Subject: checkpatch: check vendor compatible with dashes
has been added to the -mm tree.  Its filename is
     checkpatch-check-vendor-compatible-with-dashes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-vendor-compatible-with-dashes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-vendor-compatible-with-dashes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2084,7 +2084,7 @@ sub process {
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

checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
linux-next.patch

