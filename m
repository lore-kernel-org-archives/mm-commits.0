From: akpm@linux-foundation.org
Subject: [merged] ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:14 -0700
Message-ID: <200906182247.n5IMlEWS006334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757197AbZFRW5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
has been removed from the -mm tree.  Its filename was
     ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
From: Arnd Bergmann <arnd@arndb.de>

The definition of ipc_parse_version depends on
__ARCH_WANT_IPC_PARSE_VERSION, but the header file declares it
conditionally based on the architecture.

Use the macro consistently to make it easier to add new architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/util.h~ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh ipc/util.h
--- a/ipc/util.h~ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh
+++ a/ipc/util.h
@@ -128,7 +128,7 @@ void ipc_update_perm(struct ipc64_perm *
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
 
-#if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
+#ifndef __ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch

