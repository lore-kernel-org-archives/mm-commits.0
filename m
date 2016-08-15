From: akpm@linux-foundation.org
Subject: [obsolete]
 unicore32-use-simpler-api-for-random-address-requests-v2.patch removed from -mm tree
Date: Mon, 15 Aug 2016 16:09:13 -0700
Message-ID: <57b24b99./Tje2cTgpbZQG+sE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbcHOXJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 19:09:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32-use-simpler-api-for-random-address-requests-v2
has been removed from the -mm tree.  Its filename was
     unicore32-use-simpler-api-for-random-address-requests-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: unicore32-use-simpler-api-for-random-address-requests-v2

s/randomize_page/randomize_addr/

Link: http://lkml.kernel.org/r/20160728204730.27453-7-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/unicore32/kernel/process.c~unicore32-use-simpler-api-for-random-address-requests-v2 arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~unicore32-use-simpler-api-for-random-address-requests-v2
+++ a/arch/unicore32/kernel/process.c
@@ -295,7 +295,7 @@ unsigned long get_wchan(struct task_stru
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	return randomize_page(mm->brk, 0x02000000);
+	return randomize_addr(mm->brk, 0x02000000);
 }
 
 /*
_

Patches currently in -mm which might be from jason@lakedaemon.net are

random-simplify-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests.patch
arm64-use-simpler-api-for-random-address-requests.patch
tile-use-simpler-api-for-random-address-requests.patch
unicore32-use-simpler-api-for-random-address-requests.patch
random-remove-unused-randomize_range.patch

