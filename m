From: akpm@linux-foundation.org
Subject: [merged] checkpatch-match-more-world-writable-permissions.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:16:57 -0700
Message-ID: <553550a9.YXoMvIFexyG8DoKo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDTTKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hofrat@osadl.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: match more world writable permissions
has been removed from the -mm tree.  Its filename was
     checkpatch-match-more-world-writable-permissions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: match more world writable permissions

Currently checkpatch will fuss if one uses world writable settings in
debugfs files and DEVICE_ATTR uses by testing S_IWUGO but not testing
S_IWOTH, S_IRWXUGO or S_IALLUGO.

Extend the check to catch all cases exporting world writable permissions
including octal values.

[akpm@linux-foundation.org: remove stray $]
Signed-off-by: Joe Perches <joe@perches.com>
Original-patch-by: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-match-more-world-writable-permissions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-match-more-world-writable-permissions
+++ a/scripts/checkpatch.pl
@@ -443,6 +443,14 @@ foreach my $entry (@mode_permission_func
 	$mode_perms_search .= $entry->[0];
 }
 
+our $mode_perms_world_writable = qr{
+	S_IWUGO		|
+	S_IWOTH		|
+	S_IRWXUGO	|
+	S_IALLUGO	|
+	0[0-7][0-7][2367]
+}x;
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory|
@@ -5356,8 +5364,8 @@ sub process {
 			}
 		}
 
-		if ($line =~ /debugfs_create_file.*S_IWUGO/ ||
-		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
+		if ($line =~ /debugfs_create_\w+.*\b$mode_perms_world_writable\b/ ||
+		    $line =~ /DEVICE_ATTR.*\b$mode_perms_world_writable\b/) {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

