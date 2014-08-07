From: akpm@linux-foundation.org
Subject: [merged] lib-add-size-unit-t-p-e-to-memparse.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:07:45 -0700
Message-ID: <53e3dc91.TqVbpgcioPJpvx+b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:63418 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:46 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so842965iec.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guihc.fnst@cn.fujitsu.com, rientjes@google.com, takeuchi_satoru@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/cmdline.c: add size unit t/p/e to memparse
has been removed from the -mm tree.  Its filename was
     lib-add-size-unit-t-p-e-to-memparse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: lib/cmdline.c: add size unit t/p/e to memparse

For modern filesystems such as btrfs, t/p/e size level operations are
common.  add size unit t/p/e parsing to memparse

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN lib/cmdline.c~lib-add-size-unit-t-p-e-to-memparse lib/cmdline.c
--- a/lib/cmdline.c~lib-add-size-unit-t-p-e-to-memparse
+++ a/lib/cmdline.c
@@ -121,11 +121,7 @@ EXPORT_SYMBOL(get_options);
  *	@retptr: (output) Optional pointer to next char after parse completes
  *
  *	Parses a string into a number.  The number stored at @ptr is
- *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
- *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
- *	1073741824).  If the number is suffixed with K, M, or G, then
- *	the return value is the number multiplied by one kilobyte, one
- *	megabyte, or one gigabyte, respectively.
+ *	potentially suffixed with K, M, G, T, P, E.
  */
 
 unsigned long long memparse(const char *ptr, char **retptr)
@@ -135,6 +131,15 @@ unsigned long long memparse(const char *
 	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
 
 	switch (*endptr) {
+	case 'E':
+	case 'e':
+		ret <<= 10;
+	case 'P':
+	case 'p':
+		ret <<= 10;
+	case 'T':
+	case 't':
+		ret <<= 10;
 	case 'G':
 	case 'g':
 		ret <<= 10;
_

Patches currently in -mm which might be from guihc.fnst@cn.fujitsu.com are

origin.patch

