From: akpm@linux-foundation.org
Subject: +
 scripts-checkincludes-add-exit-message-for-no-duplicates-found.patch added
 to -mm tree
Date: Mon, 06 Feb 2017 15:31:45 -0800
Message-ID: <58990761.1Twtj5MQ2lytXWt9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdBFXbq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:31:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thrust73@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkincludes.pl: add exit message for no duplicates found
has been added to the -mm tree.  Its filename is
     scripts-checkincludes-add-exit-message-for-no-duplicates-found.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-checkincludes-add-exit-message-for-no-duplicates-found.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-checkincludes-add-exit-message-for-no-duplicates-found.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from thrust73@gmail.com are

scripts-checkincludes-add-exit-message-for-no-duplicates-found.patch

