From: akpm@linux-foundation.org
Subject: + lib-crc32-constify-crc32-lookup-table.patch added to -mm tree
Date: Tue, 06 Jan 2015 16:53:31 -0800
Message-ID: <54ac838b.5CJKXMowlHU9Kztf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbAGAxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:53:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dborkman@redhat.com, jmario@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: crc32: constify crc32 lookup table
has been added to the -mm tree.  Its filename is
     lib-crc32-constify-crc32-lookup-table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-crc32-constify-crc32-lookup-table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-crc32-constify-crc32-lookup-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Borkmann <dborkman@redhat.com>
Subject: lib: crc32: constify crc32 lookup table

Commit 8f243af42ade ("sections: fix const sections for crc32 table")
removed the compile-time generated crc32 tables from the RO sections,
because it conflicts with the definition of __cacheline_aligned which puts
all such aligned data into .data..cacheline_aligned section optimized for
wasting less space, and can cause alignment issues when used in
combination with const with some gcc versions like 4.7.0 due to a gcc bug
[1].

Given that most gcc versions should have the fix by now, we can just use
____cacheline_aligned, which only aligns the data but doesn't move it into
specific sections as opposed to __cacheline_aligned.  In case of gcc
versions having the mentioned bug, the alignment attribute will have no
effect, but the data will still be made RO.

After patch tables are in RO:

$ nm -v lib/crc32.o | grep -1 -E "crc32c?table"
0000000000000000 t arch_local_irq_enable
0000000000000000 r crc32ctable_le
0000000000000000 t crc32_exit
--
0000000000000960 t test_buf
0000000000002000 r crc32table_be
0000000000004000 r crc32table_le
000000001d1056e5 A __crc_crc32_be

  [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=52181

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gen_crc32table.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/gen_crc32table.c~lib-crc32-constify-crc32-lookup-table lib/gen_crc32table.c
--- a/lib/gen_crc32table.c~lib-crc32-constify-crc32-lookup-table
+++ a/lib/gen_crc32table.c
@@ -109,7 +109,7 @@ int main(int argc, char** argv)
 
 	if (CRC_LE_BITS > 1) {
 		crc32init_le();
-		printf("static u32 __cacheline_aligned "
+		printf("static const u32 ____cacheline_aligned "
 		       "crc32table_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32table_le, LE_TABLE_ROWS,
@@ -119,7 +119,7 @@ int main(int argc, char** argv)
 
 	if (CRC_BE_BITS > 1) {
 		crc32init_be();
-		printf("static u32 __cacheline_aligned "
+		printf("static const u32 ____cacheline_aligned "
 		       "crc32table_be[%d][%d] = {",
 		       BE_TABLE_ROWS, BE_TABLE_SIZE);
 		output_table(crc32table_be, LE_TABLE_ROWS,
@@ -128,7 +128,7 @@ int main(int argc, char** argv)
 	}
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
-		printf("static u32 __cacheline_aligned "
+		printf("static const u32 ____cacheline_aligned "
 		       "crc32ctable_le[%d][%d] = {",
 		       LE_TABLE_ROWS, LE_TABLE_SIZE);
 		output_table(crc32ctable_le, LE_TABLE_ROWS,
_

Patches currently in -mm which might be from dborkman@redhat.com are

lib-crc32-constify-crc32-lookup-table.patch

