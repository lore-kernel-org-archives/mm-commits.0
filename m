From: akpm@linux-foundation.org
Subject: - lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:55 -0800
Message-ID: <200802070024.m170OaAN006629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935059AbYBGAon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     lib/extable.c: remove an expensive integer divide in search_extable()
has been removed from the -mm tree.  Its filename was
     lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/extable.c: remove an expensive integer divide in search_extable()
From: Eric Dumazet <dada1@cosmosbay.com>

Actual code let compiler generates idiv instruction on x86.

Using a right shift is OK here and readable as well.

Before patch
   10:   57                      push   %edi
   11:   56                      push   %esi
   12:   89 d6                   mov    %edx,%esi
   14:   53                      push   %ebx
   15:   89 c3                   mov    %eax,%ebx
   17:   eb 22                   jmp    3b <search_extable+0x2b>
   19:   89 f0                   mov    %esi,%eax
   1b:   ba 02 00 00 00          mov    $0x2,%edx
   20:   29 d8                   sub    %ebx,%eax
   22:   89 d7                   mov    %edx,%edi
   24:   c1 f8 03                sar    $0x3,%eax
   27:   99                      cltd
   28:   f7 ff                   idiv   %edi
   2a:   8d 04 c3                lea    (%ebx,%eax,8),%eax
   2d:   39 08                   cmp    %ecx,(%eax)
...

After patch

00000010 <search_extable>:
   10:   53                      push   %ebx
   11:   89 c3                   mov    %eax,%ebx
   13:   eb 18                   jmp    2d <search_extable+0x1d>
   15:   89 d0                   mov    %edx,%eax
   17:   29 d8                   sub    %ebx,%eax
   19:   c1 f8 04                sar    $0x4,%eax
   1c:   8d 04 c3                lea    (%ebx,%eax,8),%eax
   1f:   39 08                   cmp    %ecx,(%eax)
...

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/extable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/extable.c~lib-extablec-removes-an-expensive-integer-divide-in-search_extable lib/extable.c
--- a/lib/extable.c~lib-extablec-removes-an-expensive-integer-divide-in-search_extable
+++ a/lib/extable.c
@@ -57,10 +57,10 @@ search_extable(const struct exception_ta
 	while (first <= last) {
 		const struct exception_table_entry *mid;
 
-		mid = (last - first) / 2 + first;
+		mid = ((last - first) >> 1) + first;
 		/*
-		 * careful, the distance between entries can be
-		 * larger than 2GB:
+		 * careful, the distance between value and insn
+		 * can be larger than MAX_LONG:
 		 */
 		if (mid->insn < value)
 			first = mid + 1;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
