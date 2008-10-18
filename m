From: akpm@linux-foundation.org
Subject: - checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:34 -0700
Message-ID: <200810182313.m9INDYtd028210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416AbYJRXNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: %Lx tests should hand %% as a literal
has been removed from the -mm tree.  Its filename was
     checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: %Lx tests should hand %% as a literal
From: Andy Whitcroft <apw@shadowen.org>

Ensure that we handle literal %'s correctly when adjacent to a %Lx.

	%Lx	bad
	%%Lx	good
	%%%Lx	bad

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-%lx-tests-should-hand-%%-as-a-literal scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-%lx-tests-should-hand-%%-as-a-literal
+++ a/scripts/checkpatch.pl
@@ -2392,6 +2392,7 @@ sub process {
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
 			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			$string =~ s/%%/__/g;
 			if ($string =~ /(?<!%)%L[udi]/) {
 				WARN("\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
 				last;
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

