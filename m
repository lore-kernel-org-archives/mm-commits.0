From: akpm@linux-foundation.org
Subject: + integrity-ima-integrity_measure-support-ima-exit.patch added to -mm tree
Date: Wed, 28 Mar 2007 17:25:41 -0700
Message-ID: <200703290025.l2T0Pg39023700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXC2A0e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 20:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zohar@linux.vnet.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com


The patch titled
     integrity: ima exit
has been added to the -mm tree.  Its filename is
     integrity-ima-integrity_measure-support-ima-exit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
integrity-new-hooks-fix.patch
integrity-fs-hook-placement.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-ima-integrity_measure-support.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-ima-integrity_measure-support-ima-exit.patch
integrity-ima-identifiers.patch
integrity-tpm-internal-kernel-interface.patch
integrity-tpm-internal-kernel-interface-tidy.patch
ibac-patch.patch
integrity-ima-cleanup.patch
