From: akpm@linux-foundation.org
Subject: +
 mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch added to
 -mm tree
Date: Fri, 11 Sep 2015 14:27:11 -0700
Message-ID: <55f3472f.3uMNjmd4hVHSaAtz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbIKV1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: don't use kasan shadow pointer in generic functions
has been added to the -mm tree.  Its filename is
     mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-dont-use-kasan-shadow-pointer-in-generic-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
