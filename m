From: akpm@linux-foundation.org
Subject: [merged] drivers-acpi-videoc-remove-unneeded-memsets.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:18:54 -0700
Message-ID: <200908312118.n7VLIsTP018797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbZHaVUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rui.zhang@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/video.c: remove unneeded memsets
has been removed from the -mm tree.  Its filename was
     drivers-acpi-videoc-remove-unneeded-memsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/acpi/video.c: remove unneeded memsets
From: Zhang Rui <rui.zhang@intel.com>

device->cap and video->cap are zeroed initially so we don't need to clear
them again.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/acpi/video.c~drivers-acpi-videoc-remove-unneeded-memsets drivers/acpi/video.c
--- a/drivers/acpi/video.c~drivers-acpi-videoc-remove-unneeded-memsets
+++ a/drivers/acpi/video.c
@@ -936,9 +936,6 @@ static void acpi_video_device_find_cap(s
 {
 	acpi_handle h_dummy1;
 
-
-	memset(&device->cap, 0, sizeof(device->cap));
