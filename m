From: akpm@linux-foundation.org
Subject: + lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:01:09 -0800
Message-ID: <200712182201.lBIM19aX024017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54372 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbXLRWBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     lib/extable.c: remove an expensive integer divide in search_extable()
has been added to the -mm tree.  Its filename is
     lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch
git-net.patch
git-sched.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch
