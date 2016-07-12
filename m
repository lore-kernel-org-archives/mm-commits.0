From: akpm@linux-foundation.org
Subject: [failures] cflags-add-wunused-but-set-parameter.patch removed
 from -mm tree
Date: Tue, 12 Jul 2016 14:26:10 -0700
Message-ID: <57856072.lifrmvdz+g41Prj9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcGLV0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 17:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: CFLAGS: add -Wunused-but-set-parameter
has been removed from the -mm tree.  Its filename was
     cflags-add-wunused-but-set-parameter.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: CFLAGS: add -Wunused-but-set-parameter

-Wunused-but-set-parameter is finding stuff with current allmodconfig:

drivers/misc/mic/scif/scif_dma.c:118:27: warning: parameter 'ep' set but not used [-Wunused-but-set-parameter]
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:2156:8: warning: parameter 'function' set but not used [-Wunused-but-set-parameter]
drivers/net/ethernet/ti/tlan.c:1647:59: warning: parameter 'host_int' set but not used [-Wunused-but-set-parameter]
drivers/usb/gadget/udc/pxa27x_udc.c:1828:74: warning: parameter 'driver' set but not used [-Wunused-but-set-parameter]

and judging by changelogs, people were using it before,
but were too scared to touch top level Makefile.

Link: http://lkml.kernel.org/r/20160707214306.GB31678@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN Makefile~cflags-add-wunused-but-set-parameter Makefile
--- a/Makefile~cflags-add-wunused-but-set-parameter
+++ a/Makefile
@@ -399,6 +399,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstric
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
 		   -std=gnu89
+KBUILD_CFLAGS += -Wunused-but-set-parameter
 
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
_

Patches currently in -mm which might be from adobriyan@gmail.com are

mm-faster-kmalloc_array-kcalloc.patch
ban-config_localversion_auto-with-allmodconfig.patch
ipc-delete-nr_ipc_ns.patch

