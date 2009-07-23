From: akpm@linux-foundation.org
Subject: + atlx-strncpy-does-not-null-terminate-string.patch added to -mm tree
Date: Thu, 23 Jul 2009 13:53:13 -0700
Message-ID: <200907232053.n6NKrDgo004759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbZGWUxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 16:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, csnook@redhat.com, jcliburn@gmail.com, jie.yang@atheros.com


The patch titled
     atlx: strncpy does not null terminate string
has been added to the -mm tree.  Its filename is
     atlx-strncpy-does-not-null-terminate-string.patch

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
Subject: atlx: strncpy does not null terminate string
From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <csnook@redhat.com>
Cc: Jie Yang <jie.yang@atheros.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1c/atl1c_ethtool.c |    8 ++++----
 drivers/net/atlx/atl1.c           |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/net/atl1c/atl1c_ethtool.c~atlx-strncpy-does-not-null-terminate-string drivers/net/atl1c/atl1c_ethtool.c
--- a/drivers/net/atl1c/atl1c_ethtool.c~atlx-strncpy-does-not-null-terminate-string
+++ a/drivers/net/atl1c/atl1c_ethtool.c
@@ -232,11 +232,11 @@ static void atl1c_get_drvinfo(struct net
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
-	strncpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
-	strncpy(drvinfo->version, atl1c_driver_version,
+	strlcpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, atl1c_driver_version,
 		sizeof(drvinfo->version));
-	strncpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strncpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->n_stats = 0;
 	drvinfo->testinfo_len = 0;
diff -puN drivers/net/atlx/atl1.c~atlx-strncpy-does-not-null-terminate-string drivers/net/atlx/atl1.c
--- a/drivers/net/atlx/atl1.c~atlx-strncpy-does-not-null-terminate-string
+++ a/drivers/net/atlx/atl1.c
@@ -3378,11 +3378,11 @@ static void atl1_get_drvinfo(struct net_
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 
-	strncpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
-	strncpy(drvinfo->version, ATLX_DRIVER_VERSION,
+	strlcpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, ATLX_DRIVER_VERSION,
 		sizeof(drvinfo->version));
-	strncpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
-	strncpy(drvinfo->bus_info, pci_name(adapter->pdev),
+	strlcpy(drvinfo->fw_version, "N/A", sizeof(drvinfo->fw_version));
+	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 	drvinfo->eedump_len = ATL1_EEDUMP_LEN;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
media-strncpy-does-not-null-terminate-string.patch
ipath-strncpy-does-not-null-terminate-string.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

