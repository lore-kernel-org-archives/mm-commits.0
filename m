From: akpm@linux-foundation.org
Subject: +
 partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
 added to -mm tree
Date: Wed, 04 Dec 2013 15:23:02 -0800
Message-ID: <529fb956.97/RihacTmXCDdiw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3LDXXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 18:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, matt.fleming@intel.com, bugzilla@colorremedies.com, aswin@hp.com, Matt_Domsch@dell.com, davidlohr@hp.com

Subject: + partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch added to -mm tree
To: davidlohr@hp.com,Matt_Domsch@dell.com,aswin@hp.com,bugzilla@colorremedies.com,matt.fleming@intel.com
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 15:23:02 -0800


The patch titled
     Subject: partitions/efi: complete documentation of gpt kernel param purpose
has been added to the -mm tree.  Its filename is
     partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: partitions/efi: complete documentation of gpt kernel param purpose

The usage of the 'gpt' kernel parameter is twofold: (i) skip any mbr
integrity checks and (ii) enable the backup GPT header to be used in
situations where the primary one is corrupted.  This last "feature" is not
obvious and needs to be properly documented in the kernel-parameters
document.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=63591

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: "Chandramouleeswaran,Aswin" <aswin@hp.com>
Cc: Chris Murphy <bugzilla@colorremedies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~partitions-efi-complete-documentation-of-gpt-kernel-param-purpose Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~partitions-efi-complete-documentation-of-gpt-kernel-param-purpose
+++ a/Documentation/kernel-parameters.txt
@@ -1013,7 +1013,9 @@ bytes respectively. Such letter suffixes
 			debugfs files are removed at module unload time.
 
 	gpt		[EFI] Forces disk with valid GPT signature but
-			invalid Protective MBR to be treated as GPT.
+			invalid Protective MBR to be treated as GPT. If the
+			primary GPT is corrupted, it enables the backup/alternate
+			GPT to be used instead.
 
 	grcan.enable0=	[HW] Configuration of physical interface 0. Determines
 			the "Enable 0" bit of the configuration register.
_

Patches currently in -mm which might be from davidlohr@hp.com are

mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch

