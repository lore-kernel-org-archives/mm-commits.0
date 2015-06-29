From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-emit-longer-section-headers.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:37 -0700
Message-ID: <5591aee9.Ng52/UJ5A8t9EFmi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbbF2Url (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: emit longer section headers
has been removed from the -mm tree.  Its filename was
     get_maintainer-emit-longer-section-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: emit longer section headers

Section headers can be quite long and some are very long and duplicated
for many initial characters.

The current maximum length emitted for a section header is 20 bytes (or 17
bytes then ...  when the section header length is > 20).

Change that length to 50 so more of the section is shown.

Example new output:
$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/broadcom/bnx2x/
Ariel Elior <ariel.elior@qlogic.com> (supporter:BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER)
netdev@vger.kernel.org (open list:BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER)
linux-kernel@vger.kernel.org (open list)

Old:
$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/broadcom/bnx2x/
Ariel Elior <ariel.elior@qlogic.com> (supporter:BROADCOM BNX2X 10...)
netdev@vger.kernel.org (open list:BROADCOM BNX2X 10...)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-emit-longer-section-headers scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-emit-longer-section-headers
+++ a/scripts/get_maintainer.pl
@@ -42,6 +42,7 @@ my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
 my $output_rolestats = 1;
+my $output_section_maxlen = 50;
 my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
@@ -978,8 +979,8 @@ sub get_maintainer_role {
 
     my $role = "unknown";
     my $subsystem = $typevalue[$start];
-    if (length($subsystem) > 20) {
-	$subsystem = substr($subsystem, 0, 17);
+    if ($output_section_maxlen && length($subsystem) > $output_section_maxlen) {
+	$subsystem = substr($subsystem, 0, $output_section_maxlen - 3);
 	$subsystem =~ s/\s*$//;
 	$subsystem = $subsystem . "...";
     }
@@ -1021,8 +1022,8 @@ sub get_list_role {
     my $end = find_ending_index($index);
 
     my $subsystem = $typevalue[$start];
-    if (length($subsystem) > 20) {
-	$subsystem = substr($subsystem, 0, 17);
+    if ($output_section_maxlen && length($subsystem) > $output_section_maxlen) {
+	$subsystem = substr($subsystem, 0, $output_section_maxlen - 3);
 	$subsystem =~ s/\s*$//;
 	$subsystem = $subsystem . "...";
     }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

