From: akpm@linux-foundation.org
Subject: [withdrawn]
 lib-test_firmware-add-header-to-prevent-build-errors.patch removed from -mm tree
Date: Fri, 16 Feb 2018 16:05:48 -0800
Message-ID: <5a8771dc.oXX/TE9Xd2BgZ3DK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbeBQAFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:05:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, akpm@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, mpe@ellerman.id.au, weiyongjun1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_firmware: add header to prevent build errors
has been removed from the -mm tree.  Its filename was
     lib-test_firmware-add-header-to-prevent-build-errors.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/test_firmware: add header to prevent build errors

lib/test_firmware.c has build errors on some $ARCHes due to a
missing header file, so add it.

  lib/test_firmware.c:134:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
  lib/test_firmware.c:620:25: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]

Link: http://lkml.kernel.org/r/d33eacf8-3440-3ebb-12bd-53c50ba07935@infradead.org
Link: http://kisskb.ellerman.id.au/kisskb/head/13396/
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_firmware.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/test_firmware.c~lib-test_firmware-add-header-to-prevent-build-errors lib/test_firmware.c
--- a/lib/test_firmware.c~lib-test_firmware-add-header-to-prevent-build-errors
+++ a/lib/test_firmware.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/vmalloc.h>
 
 #define TEST_FIRMWARE_NAME	"test-firmware.bin"
 #define TEST_FIRMWARE_NUM_REQS	4
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-swap_slots-use-conditional-compilation-for-swap_slotsc.patch

