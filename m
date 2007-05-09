From: akpm@linux-foundation.org
Subject: - integrity-ima-integrity_measure-support-ima-exit.patch removed from -mm tree
Date: Wed, 09 May 2007 03:01:06 -0700
Message-ID: <200705091001.l49A16QN020687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014AbXEIKBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: ima exit
has been removed from the -mm tree.  Its filename was
     integrity-ima-integrity_measure-support-ima-exit.patch

This patch was dropped because it was folded into integrity-ima-integrity_measure-support.patch

------------------------------------------------------
Subject: integrity: ima exit
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch corrects calling an __exit function from a non-_-exit function.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/evm/evm_integrity.h |   12 ++++++------
 security/evm/ima/ima_init.c  |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN security/evm/evm_integrity.h~integrity-ima-integrity_measure-support-ima-exit security/evm/evm_integrity.h
--- a/security/evm/evm_integrity.h~integrity-ima-integrity_measure-support-ima-exit
+++ a/security/evm/evm_integrity.h
@@ -9,21 +9,21 @@
 extern unsigned int evm_enable_ima;
 
 #ifdef CONFIG_IMA_MEASURE
-static inline int evm_ima_init(void)
+static int evm_ima_init(void)
 {
 	if (evm_enable_ima)
 		return ima_init();
 	return 0;
 }
 
-static inline void evm_ima_measure(const unsigned char *name, int hash_len,
+static void evm_ima_measure(const unsigned char *name, int hash_len,
 				   char *hash)
 {
 	if (evm_enable_ima)
 		ima_measure(name, hash_len, hash);
 }
 
-static inline void evm_ima_cleanup(void)
+static void __exit evm_ima_cleanup(void)
 {
 	if (evm_enable_ima)
 		ima_cleanup();
@@ -31,19 +31,19 @@ static inline void evm_ima_cleanup(void)
 }
 
 #else
-static inline int evm_ima_init(void)
+static int evm_ima_init(void)
 {
 	evm_enable_ima = 0;
 	return 0;
 }
 
-static inline void evm_ima_measure(const unsigned char *name, int hash_len,
+static void evm_ima_measure(const unsigned char *name, int hash_len,
 				   char *hash)
 {
 	return;
 }
 
-static inline void evm_ima_cleanup(void)
+static void __exit evm_ima_cleanup(void)
 {
 	evm_enable_ima = 0;
 }
diff -puN security/evm/ima/ima_init.c~integrity-ima-integrity_measure-support-ima-exit security/evm/ima/ima_init.c
--- a/security/evm/ima/ima_init.c~integrity-ima-integrity_measure-support-ima-exit
+++ a/security/evm/ima/ima_init.c
@@ -111,7 +111,7 @@ int ima_init(void)
 	return ima_fs_init();
 }
 
-void ima_cleanup(void)
+void __exit ima_cleanup(void)
 {
 	ima_fs_cleanup();
 }
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-service-api-and-dummy-provider-integrity_dummy_verify_metadata.patch
slim-main-lsm-getprocattr-hook-api-change.patch
slim-integrity-patch.patch
integrity-new-hooks.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-integrity_measure-support-ima-exit.patch
integrity-ima-identifiers.patch
integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch
integrity-tpm-internal-kernel-interface-tidy.patch
ibac-patch.patch
