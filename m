From: akpm@linux-foundation.org
Subject: - firmware-allow-release-specific-firmware-dir.patch removed from -mm tree
Date: Wed, 10 Sep 2008 16:16:55 -0700
Message-ID: <200809102316.m8ANGuCe031749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbYIJXRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 19:17:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, dwmw2@infradead.org, greg@kroah.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     firmware: allow release-specific firmware dir
has been removed from the -mm tree.  Its filename was
     firmware-allow-release-specific-firmware-dir.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware: allow release-specific firmware dir
From: Jeff Mahoney <jeffm@suse.com>

Every kernel package trying to provide files under /lib/firmware runs into
problems really quickly with multiple kernels installed, especially with
respect to distribution package tracking of the files.

This patch moves them to /lib/firmware/$KERNELRELEASE.  udev v127's
firmware.sh looks there first before falling back to /lib/firmware.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~firmware-allow-release-specific-firmware-dir Makefile
--- a/Makefile~firmware-allow-release-specific-firmware-dir
+++ a/Makefile
@@ -1026,7 +1026,7 @@ depend dep:
 
 # ---------------------------------------------------------------------------
 # Firmware install
-INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
+INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware/$(KERNELRELEASE)
 export INSTALL_FW_PATH
 
 PHONY += firmware_install
_

Patches currently in -mm which might be from jeffm@suse.com are

firmware-allow-release-specific-firmware-dir.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

