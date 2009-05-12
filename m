From: akpm@linux-foundation.org
Subject: + ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch added to -mm tree
Date: Mon, 11 May 2009 17:03:58 -0700
Message-ID: <200905120003.n4C03wIh005826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112AbZELAFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 20:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de


The patch titled
     ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
has been added to the -mm tree.  Its filename is
     ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch

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
Subject: ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
From: Arnd Bergmann <arnd@arndb.de>

The definition of ipc_parse_version depends on
__ARCH_WANT_IPC_PARSE_VERSION, but the header file declares it
conditionally based on the architecture.

Use the macro consistently to make it easier to add new architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

linux-next.patch
time-move-pit_tick_rate-to-linux-timexh.patch
mb862xxfb-use-config_of-instead-of-config_ppc_of.patch
ipc-use-__arch_want_ipc_parse_version-in-ipc-utilh.patch

