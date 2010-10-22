From: akpm@linux-foundation.org
Subject: + nfs-include-ratelimith-fix-nfs4state-build-error.patch added to -mm tree
Date: Fri, 22 Oct 2010 16:24:01 -0700
Message-ID: <201010222324.o9MNO1P4013562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab0JVXY4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 19:24:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, Trond.Myklebust@netapp.com


The patch titled
     nfs: include ratelimit.h, fix nfs4state build error
has been added to the -mm tree.  Its filename is
     nfs-include-ratelimith-fix-nfs4state-build-error.patch

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
Subject: nfs: include ratelimit.h, fix nfs4state build error
From: Randy Dunlap <randy.dunlap@oracle.com>

nfs4state.c uses interfaces from ratelimit.h.  It needs to include
that header file to fix build errors:

fs/nfs/nfs4state.c:1195: warning: type defaults to 'int' in declaration of 'DEFINE_RATELIMIT_STATE'
fs/nfs/nfs4state.c:1195: warning: parameter names (without types) in function declaration
fs/nfs/nfs4state.c:1195: error: invalid storage class for function 'DEFINE_RATELIMIT_STATE'
fs/nfs/nfs4state.c:1195: error: implicit declaration of function '__ratelimit'
fs/nfs/nfs4state.c:1195: error: '_rs' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4state.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nfs/nfs4state.c~nfs-include-ratelimith-fix-nfs4state-build-error fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~nfs-include-ratelimith-fix-nfs4state-build-error
+++ a/fs/nfs/nfs4state.c
@@ -46,6 +46,7 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/ratelimit.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kfifo-disable-__kfifo_must_check_helper.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
ibm_rtl-fix-printk-format-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
nfs-include-ratelimith-fix-nfs4state-build-error.patch
fs-move-exportfs-since-it-is-not-a-networking-filesystem.patch
misc-devices-do-not-enable-by-default.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
kfifo-fix-kfifo_alloc-to-return-a-signed-int-value.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

