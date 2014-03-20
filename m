From: akpm@linux-foundation.org
Subject: [merged]
 drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch removed from -mm tree
Date: Thu, 20 Mar 2014 12:42:38 -0700
Message-ID: <532b44ae.cOKnUM5Ma5PnKaTu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780AbaCTTmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 15:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nico@ngolde.de, keescook@google.com, fabs@goesec.de, dan.carpenter@oracle.com

Subject: [merged] drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch removed from -mm tree
To: dan.carpenter@oracle.com,fabs@goesec.de,keescook@google.com,nico@ngolde.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 12:42:38 -0700


The patch titled
     Subject: drivers/scsi/megaraid/megaraid_mm.c: missing bounds check in mimd_to_kioc()
has been removed from the -mm tree.  Its filename was
     drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/scsi/megaraid/megaraid_mm.c: missing bounds check in mimd_to_kioc()

pthru32->dataxferlen comes from the user so we need to check that it's not
too large so we don't overflow the buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kees Cook <keescook@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_mm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_mm.c~drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc drivers/scsi/megaraid/megaraid_mm.c
--- a/drivers/scsi/megaraid/megaraid_mm.c~drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc
+++ a/drivers/scsi/megaraid/megaraid_mm.c
@@ -486,6 +486,8 @@ mimd_to_kioc(mimd_t __user *umimd, mraid
 
 	pthru32->dataxferaddr	= kioc->buf_paddr;
 	if (kioc->data_dir & UIOC_WR) {
+		if (pthru32->dataxferlen > kioc->xferlen)
+			return -EINVAL;
 		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
 						pthru32->dataxferlen)) {
 			return (-EFAULT);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

direct-io-remove-some-left-over-checks.patch
ncpfs-cleanup-indenting-in-ncp_lookup.patch
drivers-misc-sgi-gru-grukdumpc-cleanup-gru_dump_context-a-little.patch
linux-next.patch

