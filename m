From: akpm@linux-foundation.org
Subject: [obsolete]
 x86-use-simpler-api-for-random-address-requests-v2.patch removed from -mm
 tree
Date: Mon, 15 Aug 2016 16:09:05 -0700
Message-ID: <57b24b91.O7smtj3mIolM2xaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbcHOXJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 19:09:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-use-simpler-api-for-random-address-requests-v2
has been removed from the -mm tree.  Its filename was
     x86-use-simpler-api-for-random-address-requests-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: x86-use-simpler-api-for-random-address-requests-v2

s/randomize_page/randomize_addr/

Link: http://lkml.kernel.org/r/20160728204730.27453-3-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process.c    |    2 +-
 arch/x86/kernel/sys_x86_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/process.c~x86-use-simpler-api-for-random-address-requests-v2 arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~x86-use-simpler-api-for-random-address-requests-v2
+++ a/arch/x86/kernel/process.c
@@ -508,7 +508,7 @@ unsigned long arch_align_stack(unsigned
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	return randomize_page(mm->brk, 0x02000000);
+	return randomize_addr(mm->brk, 0x02000000);
 }
 
 /*
diff -puN arch/x86/kernel/sys_x86_64.c~x86-use-simpler-api-for-random-address-requests-v2 arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~x86-use-simpler-api-for-random-address-requests-v2
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -111,7 +111,7 @@ static void find_start_end(unsigned long
 		*begin = 0x40000000;
 		*end = 0x80000000;
 		if (current->flags & PF_RANDOMIZE) {
-			*begin = randomize_page(*begin, 0x02000000);
+			*begin = randomize_addr(*begin, 0x02000000);
 		}
 	} else {
 		*begin = current->mm->mmap_legacy_base;
_

Patches currently in -mm which might be from jason@lakedaemon.net are

random-simplify-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests-v2.patch
arm64-use-simpler-api-for-random-address-requests.patch
arm64-use-simpler-api-for-random-address-requests-v2.patch
tile-use-simpler-api-for-random-address-requests.patch
tile-use-simpler-api-for-random-address-requests-v2.patch
unicore32-use-simpler-api-for-random-address-requests.patch
unicore32-use-simpler-api-for-random-address-requests-v2.patch
random-remove-unused-randomize_range.patch

