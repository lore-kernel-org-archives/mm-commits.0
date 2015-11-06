From: akpm@linux-foundation.org
Subject: [merged]
 mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:17:31 -0800
Message-ID: <563d0adb.rarPzIOJTapELHkR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162871AbbKFURb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: don't use kasan shadow pointer in generic functions
has been removed from the -mm tree.  Its filename was
     mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/kasan: don't use kasan shadow pointer in generic functions

We can't use generic functions like print_hex_dump to access kasan shadow
region.  This require us to setup another kasan shadow region for the
address passed (kasan shadow address).  Some architectures won't be able
to do that.  Hence make a copy of the shadow region row and pass that to
generic functions.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/kasan/report.c~mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions
+++ a/mm/kasan/report.c
@@ -164,14 +164,20 @@ static void print_shadow_for_address(con
 	for (i = -SHADOW_ROWS_AROUND_ADDR; i <= SHADOW_ROWS_AROUND_ADDR; i++) {
 		const void *kaddr = kasan_shadow_to_mem(shadow_row);
 		char buffer[4 + (BITS_PER_LONG/8)*2];
+		char shadow_buf[SHADOW_BYTES_PER_ROW];
 
 		snprintf(buffer, sizeof(buffer),
 			(i == 0) ? ">%p: " : " %p: ", kaddr);
