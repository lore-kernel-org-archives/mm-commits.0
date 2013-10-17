From: akpm@linux-foundation.org
Subject: [merged]
 block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error.patch
 removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:13 -0700
Message-ID: <526028b9.fVD2uCQ0YE8t38ty%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab3JQSNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, seanpaul@chromium.org, josh@joshtriplett.org, dedekind1@gmail.com, davidlohr@hp.com, dianders@chromium.org

Subject: [merged] block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error.patch removed from -mm tree
To: dianders@chromium.org,davidlohr@hp.com,dedekind1@gmail.com,josh@joshtriplett.org,seanpaul@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:13 -0700


The patch titled
     Subject: block/partitions/efi.c: treat size mismatch as a warning, not an error
has been removed from the -mm tree.  Its filename was
     block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Doug Anderson <dianders@chromium.org>
Subject: block/partitions/efi.c: treat size mismatch as a warning, not an error

In 27a7c64 ("partitions/efi: account for pmbr size in lba") we started
treating bad sizes in lba field of the partition that has the 0xEE (GPT
protective) as errors.  However, we may run into these "bad sizes" in the
real world if someone uses dd to copy an image from a smaller disk to a
bigger disk.  Since this case used to work (even without using force_gpt),
keep it working and treat the size mismatch as a warning instead of an
error.

Reported-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Tested-by: Artem Bityutskiy <dedekind1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN block/partitions/efi.c~block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error block/partitions/efi.c
--- a/block/partitions/efi.c~block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error
+++ a/block/partitions/efi.c
@@ -222,11 +222,16 @@ check_hybrid:
 	 * the disk size.
 	 *
 	 * Hybrid MBRs do not necessarily comply with this.
+	 *
+	 * Consider a bad value here to be a warning to support dd'ing
+	 * an image from a smaller disk to a larger disk.
 	 */
 	if (ret == GPT_MBR_PROTECTIVE) {
 		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
 		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
-			ret = 0;
+			pr_debug("GPT: mbr size in lba (%u) different than whole disk (%u).\n",
+				 sz, min_t(uint32_t,
+					   total_sectors - 1, 0xFFFFFFFF));
 	}
 done:
 	return ret;
_

Patches currently in -mm which might be from dianders@chromium.org are

origin.patch
linux-next.patch

