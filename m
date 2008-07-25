From: akpm@linux-foundation.org
Subject: - init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:12 -0700
Message-ID: <200807252255.m6PMtCwe002959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbYGYW40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guilak@linux.vnet.ibm.com, daniel@danielguilak.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     init/version.c: define version_string only if CONFIG_KALLSYMS is not defined
has been removed from the -mm tree.  Its filename was
     init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/version.c: define version_string only if CONFIG_KALLSYMS is not defined
From: Daniel Guilak <guilak@linux.vnet.ibm.com>

int Version_* is only used with ksymoops, which is only needed (according
to README and Documentation/Changes) if CONFIG_KALLSYMS is NOT defined. 
Therefore this patch defines version_string only if CONFIG_KALLSYMS is not
defined.

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN init/version.c~init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined init/version.c
--- a/init/version.c~init-versionc-define-version_string-only-if-config_kallsyms-is-not-defined
+++ a/init/version.c
@@ -13,11 +13,13 @@
 #include <linux/utsrelease.h>
 #include <linux/version.h>
 
+#ifndef CONFIG_KALLSYMS
 #define version(a) Version_ ## a
 #define version_string(a) version(a)
 
 extern int version_string(LINUX_VERSION_CODE);
 int version_string(LINUX_VERSION_CODE);
+#endif
 
 struct uts_namespace init_uts_ns = {
 	.kref = {
_

Patches currently in -mm which might be from guilak@linux.vnet.ibm.com are

origin.patch

