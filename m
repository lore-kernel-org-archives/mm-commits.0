From: akpm@linux-foundation.org
Subject: + fix-read-buffer-overflow-in-delta-ipc.patch added to -mm tree
Date: Thu, 21 Dec 2017 16:29:57 -0800
Message-ID: <5a3c5205.N6NEerCSl277klj8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753154AbdLVA36 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Dec 2017 19:29:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/platform/sti/delta/delta-ipc.c: fix read buffer overflow
has been added to the -mm tree.  Its filename is
     fix-read-buffer-overflow-in-delta-ipc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-read-buffer-overflow-in-delta-ipc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-read-buffer-overflow-in-delta-ipc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: drivers/media/platform/sti/delta/delta-ipc.c: fix read buffer overflow

The single caller passes a string to delta_ipc_open, which copies with a
fixed size larger than the string.  So it copies some random data after
the original string the ro segment.

If the string was at the end of a page it may fault.

Just copy the string with a normal strcpy after clearing the field.

Found by a LTO build (which errors out)
because the compiler inlines the functions and can resolve
the string sizes and triggers the compile time checks in memcpy.

In function `memcpy',
    inlined from `delta_ipc_open.constprop' at linux/drivers/media/platform/sti/delta/delta-ipc.c:178:0,
    inlined from `delta_mjpeg_ipc_open' at linux/drivers/media/platform/sti/delta/delta-mjpeg-dec.c:227:0,
    inlined from `delta_mjpeg_decode' at linux/drivers/media/platform/sti/delta/delta-mjpeg-dec.c:403:0:
/home/andi/lsrc/linux/include/linux/string.h:337:0: error: call to `__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
    __read_overflow2();

Link: http://lkml.kernel.org/r/20171222001212.1850-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/platform/sti/delta/delta-ipc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/platform/sti/delta/delta-ipc.c~fix-read-buffer-overflow-in-delta-ipc drivers/media/platform/sti/delta/delta-ipc.c
--- a/drivers/media/platform/sti/delta/delta-ipc.c~fix-read-buffer-overflow-in-delta-ipc
+++ a/drivers/media/platform/sti/delta/delta-ipc.c
@@ -175,8 +175,8 @@ int delta_ipc_open(struct delta_ctx *pct
 	msg.ipc_buf_size = ipc_buf_size;
 	msg.ipc_buf_paddr = ctx->ipc_buf->paddr;
 
-	memcpy(msg.name, name, sizeof(msg.name));
-	msg.name[sizeof(msg.name) - 1] = 0;
+	memset(msg.name, 0, sizeof(msg.name));
+	strcpy(msg.name, name);
 
 	msg.param_size = param->size;
 	memcpy(ctx->ipc_buf->vaddr, param->data, msg.param_size);
_

Patches currently in -mm which might be from ak@linux.intel.com are

fix-const-confusion-in-certs-blacklist.patch
fix-read-buffer-overflow-in-delta-ipc.patch

