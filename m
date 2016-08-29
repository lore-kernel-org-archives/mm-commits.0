From: akpm@linux-foundation.org
Subject: + make-isdigit-table-lookupless.patch added to -mm tree
Date: Mon, 29 Aug 2016 14:59:18 -0700
Message-ID: <57c4b036.YGEY+2x8NdecrOWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38032 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbcH2V7T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 17:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/ctype.h: make isdigit() table lookupless
has been added to the -mm tree.  Its filename is
     make-isdigit-table-lookupless.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-isdigit-table-lookupless.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-isdigit-table-lookupless.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: include/linux/ctype.h: make isdigit() table lookupless

Make isdigit into a simple range checking inline function:

	return '0' <= c && c <= '9';

This code is 1 branch, not 2 because any reasonable compiler can
optimize this code into SUB+CMP, so the code

	while (isdigit((c = *s++)))
		...

remains 1 branch per iteration HOWEVER it suddenly doesn't do table
lookup priming cacheline nobody cares about.

Link: http://lkml.kernel.org/r/20160826190047.GA12536@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ctype.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/ctype.h~make-isdigit-table-lookupless include/linux/ctype.h
--- a/include/linux/ctype.h~make-isdigit-table-lookupless
+++ a/include/linux/ctype.h
@@ -22,7 +22,10 @@ extern const unsigned char _ctype[];
 #define isalnum(c)	((__ismask(c)&(_U|_L|_D)) != 0)
 #define isalpha(c)	((__ismask(c)&(_U|_L)) != 0)
 #define iscntrl(c)	((__ismask(c)&(_C)) != 0)
-#define isdigit(c)	((__ismask(c)&(_D)) != 0)
+static inline int isdigit(int c)
+{
+	return '0' <= c && c <= '9';
+}
 #define isgraph(c)	((__ismask(c)&(_P|_U|_L|_D)) != 0)
 #define islower(c)	((__ismask(c)&(_L)) != 0)
 #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
mm-unrig-vma-cache-hit-ratio.patch
proc-much-faster-proc-vmstat.patch
proc-faster-proc-status.patch
cred-simpler-1d-supplementary-groups.patch
make-isdigit-table-lookupless.patch

