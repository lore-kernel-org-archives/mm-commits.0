From: akpm@linux-foundation.org
Subject: + byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:12:54 -0700
Message-ID: <200810212012.m9LKCslc009944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbYJUUM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:12:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     byteorder: remove direct includes of linux/byteorder/swab[b].h
has been added to the -mm tree.  Its filename is
     byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: remove direct includes of linux/byteorder/swab[b].h
From: Harvey Harrison <harvey.harrison@gmail.com>

A consolidated implementation will provide this generically through
asm/byteorder, remove direct includes to avoid breakage when the
changeover to the new implementation occurs.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcutorture.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh kernel/rcutorture.c
--- a/kernel/rcutorture.c~byteorder-remove-direct-includes-of-linux-byteorder-swabh
+++ a/kernel/rcutorture.c
@@ -42,10 +42,10 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
byteorder-remove-direct-includes-of-linux-byteorder-swabh.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

