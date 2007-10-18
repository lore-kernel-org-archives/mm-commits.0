From: akpm@linux-foundation.org
Subject: - do-not-export-usr-include-scsi-in-make-headers_install.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:42 -0700
Message-ID: <200710180655.l9I6tgM8030636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760847AbXJRH0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olh@suse.de, James.Bottomley@steeleye.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     do not export /usr/include/scsi in make headers_install
has been removed from the -mm tree.  Its filename was
     do-not-export-usr-include-scsi-in-make-headers_install.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do not export /usr/include/scsi in make headers_install
From: Olaf Hering <olh@suse.de>

/usr/include/scsi is provided by glibc.
Remove the scsi export from make headers_install target.

Signed-off-by: Olaf Hering <olh@suse.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/Kbuild      |    1 -
 include/scsi/Kbuild |    4 ----
 2 files changed, 5 deletions(-)

diff -puN include/Kbuild~do-not-export-usr-include-scsi-in-make-headers_install include/Kbuild
--- a/include/Kbuild~do-not-export-usr-include-scsi-in-make-headers_install
+++ a/include/Kbuild
@@ -1,6 +1,5 @@
 header-y += asm-generic/
 header-y += linux/
-header-y += scsi/
 header-y += sound/
 header-y += mtd/
 header-y += rdma/
diff -puN include/scsi/Kbuild~do-not-export-usr-include-scsi-in-make-headers_install /dev/null
--- a/include/scsi/Kbuild
+++ /dev/null
@@ -1,4 +0,0 @@
-header-y += scsi.h
-
-unifdef-y += scsi_ioctl.h
-unifdef-y += sg.h
_

Patches currently in -mm which might be from olh@suse.de are

origin.patch
