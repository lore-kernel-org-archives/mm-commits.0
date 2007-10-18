From: akpm@linux-foundation.org
Subject: - voyager-dont-try-to-support-unprocessor-builds.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:08:03 -0700
Message-ID: <200710180708.l9I783Ut031828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759482AbXJRHIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@steeleye.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     voyager: don't try to support unprocessor builds
has been removed from the -mm tree.  Its filename was
     voyager-dont-try-to-support-unprocessor-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: voyager: don't try to support unprocessor builds
From: James Bottomley <James.Bottomley@steeleye.com>

A while ago Randy Dunlap and Adrian Bunk suggested we simply prevent UP
voyager building.  I resisted this on the grounds that the nagging was the
only thing that was going to cause me to look at this.  However, now I
think we should probably take this course.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/Kconfig~voyager-dont-try-to-support-unprocessor-builds arch/i386/Kconfig
--- a/arch/i386/Kconfig~voyager-dont-try-to-support-unprocessor-builds
+++ a/arch/i386/Kconfig
@@ -146,6 +146,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
+	select SMP if !BROKEN
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
_

Patches currently in -mm which might be from James.Bottomley@steeleye.com are

origin.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
git-scsi-misc.patch
qla2xxx-printk-fixes.patch
scsi-send-media-state-change-modification-events.patch
scsi-early-detection-of-medium-not-present-updated.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
initio-fix-conflict-when-loading-driver.patch
kill-warnings-in-mptbaseh-on-parisc64.patch
advansys-depends-on-virt_to_bus.patch
git-x86.patch
unify-dma_bit_mask-definitions-v31.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
