From: akpm@linux-foundation.org
Subject: + fix-const-confusion-in-intel-mid-x86-platform-drivers.patch
 added to -mm tree
Date: Thu, 21 Dec 2017 16:30:34 -0800
Message-ID: <5a3c522a.6HiUWCiE/hOzqieT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbdLVAaf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Dec 2017 19:30:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/platform/intel-mid/device_libs/platform_bt.c: fix const confusion
has been added to the -mm tree.  Its filename is
     fix-const-confusion-in-intel-mid-x86-platform-drivers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-const-confusion-in-intel-mid-x86-platform-drivers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-const-confusion-in-intel-mid-x86-platform-drivers.patch

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
Subject: arch/x86/platform/intel-mid/device_libs/platform_bt.c: fix const confusion

const must be marked __initconst, not __initdata

Link: http://lkml.kernel.org/r/20171222001443.2067-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/intel-mid/device_libs/platform_bt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/intel-mid/device_libs/platform_bt.c~fix-const-confusion-in-intel-mid-x86-platform-drivers arch/x86/platform/intel-mid/device_libs/platform_bt.c
--- a/arch/x86/platform/intel-mid/device_libs/platform_bt.c~fix-const-confusion-in-intel-mid-x86-platform-drivers
+++ a/arch/x86/platform/intel-mid/device_libs/platform_bt.c
@@ -60,7 +60,7 @@ static int __init tng_bt_sfi_setup(struc
 	return 0;
 }
 
-static const struct bt_sfi_data tng_bt_sfi_data __initdata = {
+static const struct bt_sfi_data tng_bt_sfi_data __initconst = {
 	.setup	= tng_bt_sfi_setup,
 };
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

fix-const-confusion-in-certs-blacklist.patch
fix-read-buffer-overflow-in-delta-ipc.patch
fix-const-confusion-in-intel-mid-x86-platform-drivers.patch

