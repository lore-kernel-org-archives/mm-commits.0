From: akpm@linux-foundation.org
Subject: [merged] checkpatch-update-the-fsf-gpl-address-check.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:57 -0800
Message-ID: <52e2b8a5.n6lGkIxO9eF0CPEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaAXTB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, josh@joshtriplett.org, apw@canonical.com, joe@perches.com

Subject: [merged] checkpatch-update-the-fsf-gpl-address-check.patch removed from -mm tree
To: joe@perches.com,apw@canonical.com,josh@joshtriplett.org,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:57 -0800


The patch titled
     Subject: checkpatch: update the FSF/GPL address check
has been removed from the -mm tree.  Its filename was
     checkpatch-update-the-fsf-gpl-address-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: update the FSF/GPL address check

The FSF address check is a bit too verbose looking for the GPL text. 
Quiet it a bit by requiring --strict for the GPL bit.

Also make the address tests match a few uses of abbreviations for street
names and make it case insensitive.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-update-the-fsf-gpl-address-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-update-the-fsf-gpl-address-check
+++ a/scripts/checkpatch.pl
@@ -1970,15 +1970,16 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /You should have received a copy/ ||
-		    $rawline =~ /write to the Free Software/ ||
-		    $rawline =~ /59 Temple Place/ ||
-		    $rawline =~ /51 Franklin Street/) {
+		if ($rawline =~ /\bYou should have received a copy/i ||
+		    $rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
+		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
+			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
-				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
 
 # check for Kconfig help text having a real description
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

