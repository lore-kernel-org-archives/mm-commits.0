From: akpm@linux-foundation.org
Subject: + lib-add-size-unit-t-p-e-to-memparse.patch added to -mm tree
Date: Tue, 17 Jun 2014 15:11:22 -0700
Message-ID: <53a0bd0a.CaA2z3sXESaSloOD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965302AbaFQWLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 18:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, guihc.fnst@cn.fujitsu.com


The patch titled
     Subject: lib/cmdline.c: add size unit t/p/e to memparse
has been added to the -mm tree.  Its filename is
     lib-add-size-unit-t-p-e-to-memparse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-size-unit-t-p-e-to-memparse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-size-unit-t-p-e-to-memparse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: lib/cmdline.c: add size unit t/p/e to memparse

For modern filesystems such as btrfs, t/p/e size level operations are
common.  add size unit t/p/e parsing to memparse

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
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

lib-add-size-unit-t-p-e-to-memparse.patch

