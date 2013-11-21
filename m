From: akpm@linux-foundation.org
Subject: +
 drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch added to -mm tree
Date: Thu, 21 Nov 2013 15:58:12 -0800
Message-ID: <528e9e14.gV6ep1/32fDRatL1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3KUX6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 18:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nico@ngolde.de, keescook@google.com, fabs@goesec.de, dan.carpenter@oracle.com

Subject: + drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch added to -mm tree
To: dan.carpenter@oracle.com,fabs@goesec.de,keescook@google.com,nico@ngolde.de
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 15:58:12 -0800


The patch titled
     Subject: drivers/scsi/megaraid/megaraid_mm.c: missing bounds check in mimd_to_kioc()
has been added to the -mm tree.  Its filename is
     drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
framework-for-version-lvb-remove-some-impossible-checks.patch
drivers-scsi-megaraid-megaraid_mmc-missing-bounds-check-in-mimd_to_kioc.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
linux-next.patch

