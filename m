From: akpm@linux-foundation.org
Subject: + ramoops-add-has_iomem-dependency.patch added to -mm tree
Date: Fri, 28 May 2010 09:58:09 -0700
Message-ID: <201005281658.o4SGw7qc001192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712Ab0E1Q6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 12:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, marco.stornelli@gmail.com


The patch titled
     ramoops: add HAS_IOMEM dependency
has been added to the -mm tree.  Its filename is
     ramoops-add-has_iomem-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramoops: add HAS_IOMEM dependency
From: Heiko Carstens <heiko.carstens@de.ibm.com>

The driver fails to compile on s390:

drivers/char/ramoops.c: In function 'ramoops_init':
drivers/char/ramoops.c:122: error: implicit declaration of function 'ioremap'

Since we won't make use of the driver anyway on s390 just let it depend on
HAS_IOMEM.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/Kconfig~ramoops-add-has_iomem-dependency drivers/char/Kconfig
--- a/drivers/char/Kconfig~ramoops-add-has_iomem-dependency
+++ a/drivers/char/Kconfig
@@ -1123,6 +1123,7 @@ source "drivers/s390/char/Kconfig"
 
 config RAMOOPS
 	tristate "Log panic/oops to a RAM buffer"
+	depends on HAS_IOMEM
 	default n
 	help
 	  This enables panic and oops messages to be logged to a circular
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call.patch
ramoops-add-has_iomem-dependency.patch
linux-next.patch
drivers-s390-net-use-memdup_user.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

