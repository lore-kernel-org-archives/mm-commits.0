From: akpm@linux-foundation.org
Subject: + lib-crc32-update-the-comments-of-crc32_bele_generic.patch added to -mm tree
Date: Fri, 19 Jul 2013 15:14:41 -0700
Message-ID: <51e9ba51.C4gVprk7Lkh9LLIw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3GSWOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 18:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, guz.fnst@cn.fujitsu.com

Subject: + lib-crc32-update-the-comments-of-crc32_bele_generic.patch added to -mm tree
To: guz.fnst@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 15:14:41 -0700


The patch titled
     Subject: lib/crc32: update the comments of, crc32_{be,le}_generic()
has been added to the -mm tree.  Its filename is
     lib-crc32-update-the-comments-of-crc32_bele_generic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-crc32-update-the-comments-of-crc32_bele_generic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-crc32-update-the-comments-of-crc32_bele_generic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: lib/crc32: update the comments of, crc32_{be,le}_generic()

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN lib/crc32.c~lib-crc32-update-the-comments-of-crc32_bele_generic lib/crc32.c
--- a/lib/crc32.c~lib-crc32-update-the-comments-of-crc32_bele_generic
+++ a/lib/crc32.c
@@ -131,11 +131,14 @@ crc32_body(u32 crc, unsigned char const
 #endif
 
 /**
- * crc32_le() - Calculate bitwise little-endian Ethernet AUTODIN II CRC32
+ * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
+ * 			CRC32/CRC32C
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
- *	other uses, or the previous crc32 value if computing incrementally.
- * @p: pointer to buffer over which CRC is run
+ *	other uses, or the previous crc32/crc32c value if computing incrementally.
+ * @p: pointer to buffer over which CRC32/CRC32C is run
  * @len: length of buffer @p
+ * @tab: little-endian Ethernet table
+ * @polynomial: CRC32/CRC32c LE polynomial
  */
 static inline u32 __pure crc32_le_generic(u32 crc, unsigned char const *p,
 					  size_t len, const u32 (*tab)[256],
@@ -201,11 +204,13 @@ EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(__crc32c_le);
 
 /**
- * crc32_be() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
+ * crc32_be_generic() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
  * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
  *	other uses, or the previous crc32 value if computing incrementally.
- * @p: pointer to buffer over which CRC is run
+ * @p: pointer to buffer over which CRC32 is run
  * @len: length of buffer @p
+ * @tab: big-endian Ethernet table
+ * @polynomial: CRC32 BE polynomial
  */
 static inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
 					  size_t len, const u32 (*tab)[256],
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic.patch
linux-next.patch

