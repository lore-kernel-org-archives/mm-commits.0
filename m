From: akpm@linux-foundation.org
Subject: + ecryptfs-depends-on-crypto.patch added to -mm tree
Date: Mon, 28 Sep 2009 15:34:52 -0700
Message-ID: <200909282234.n8SMYrdf006822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbZI1WfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Sep 2009 18:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: depends on CRYPTO
has been added to the -mm tree.  Its filename is
     ecryptfs-depends-on-crypto.patch

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
Subject: ecryptfs: depends on CRYPTO
From: Randy Dunlap <randy.dunlap@oracle.com>

ecryptfs uses crypto APIs so it should depend on CRYPTO.
Otherwise many build errors occur. [63 lines not pasted]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/Kconfig~ecryptfs-depends-on-crypto fs/ecryptfs/Kconfig
--- a/fs/ecryptfs/Kconfig~ecryptfs-depends-on-crypto
+++ a/fs/ecryptfs/Kconfig
@@ -1,6 +1,6 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && NET
+	depends on EXPERIMENTAL && KEYS && NET && CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
ecryptfs-depends-on-crypto.patch
readahead-add-blk_run_backing_dev.patch
pcmcia-fix-controller-printk-warnings.patch
reiser4-export-remove_from_page_cache-fix.patch

