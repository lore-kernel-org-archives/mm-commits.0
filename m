From: akpm@linux-foundation.org
Subject: [merged] mwave-fix-info-leak-in-mwave_ioctl.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:22:01 -0700
Message-ID: <51dc9b19.laz6szJGGlITU1sM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3GIXWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jkosina@suse.cz, greg@kroah.com, dan.carpenter@oracle.com

Subject: [merged] mwave-fix-info-leak-in-mwave_ioctl.patch removed from -mm tree
To: dan.carpenter@oracle.com,greg@kroah.com,jkosina@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:01 -0700


The patch titled
     Subject: mwave: fix info leak in mwave_ioctl()
has been removed from the -mm tree.  Its filename was
     mwave-fix-info-leak-in-mwave_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mwave: fix info leak in mwave_ioctl()

Smatch complains that on 64 bit systems, there is a hole in the
MW_ABILITIES struct between ->component_count and ->component_list[].  It
leaks stack information from the mwave_ioctl() function.

I've added a memset() to initialize the struct to zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/tp3780i.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/mwave/tp3780i.c~mwave-fix-info-leak-in-mwave_ioctl drivers/char/mwave/tp3780i.c
--- a/drivers/char/mwave/tp3780i.c~mwave-fix-info-leak-in-mwave_ioctl
+++ a/drivers/char/mwave/tp3780i.c
@@ -479,6 +479,7 @@ int tp3780I_QueryAbilities(THINKPAD_BD_D
 	PRINTK_2(TRACE_TP3780I,
 		"tp3780i::tp3780I_QueryAbilities entry pBDData %p\n", pBDData);
 
+	memset(pAbilities, 0, sizeof(*pAbilities));
 	/* fill out standard constant fields */
 	pAbilities->instr_per_sec = pBDData->rDspSettings.uIps;
 	pAbilities->data_size = pBDData->rDspSettings.uDStoreSize;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

