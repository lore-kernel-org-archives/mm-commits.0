From: akpm@linux-foundation.org
Subject: [patch 014/142] scripts/checkincludes.pl: add exit message for no duplicates found
Date: Wed, 22 Feb 2017 15:40:26 -0800
Message-ID: <58ae216a.RyxhjYCXKSKNUpaV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934166AbdBVXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, thrust73@gmail.com

From: Cheah Kok Cheong <thrust73@gmail.com>
Subject: scripts/checkincludes.pl: add exit message for no duplicates found

If no duplicates found, inform user.

Link: http://lkml.kernel.org/r/1486391275-2843-1-git-send-email-thrust73@gmail.com
Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkincludes.pl~scripts-checkincludes-add-exit-message-for-no-duplicates-found scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~scripts-checkincludes-add-exit-message-for-no-duplicates-found
+++ a/scripts/checkincludes.pl
@@ -37,6 +37,8 @@ if ($#ARGV >= 1) {
 	}
 }
 
+my $dup_counter = 0;
+
 foreach my $file (@ARGV) {
 	open(my $f, '<', $file)
 	    or die "Cannot open $file: $!.\n";
@@ -57,6 +59,7 @@ foreach my $file (@ARGV) {
 		foreach my $filename (keys %includedfiles) {
 			if ($includedfiles{$filename} > 1) {
 				print "$file: $filename is included more than once.\n";
+				++$dup_counter;
 			}
 		}
 		next;
@@ -73,6 +76,7 @@ foreach my $file (@ARGV) {
 					if ($includedfiles{$filename} > 1) {
 						$includedfiles{$filename}--;
 						$dups++;
+						++$dup_counter;
 					} else {
 						print {$f} $_;
 					}
@@ -87,3 +91,7 @@ foreach my $file (@ARGV) {
 	}
 	close($f);
 }
+
+if ($dup_counter == 0) {
+	print "No duplicate includes found.\n";
+}
_
