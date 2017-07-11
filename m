From: akpm@linux-foundation.org
Subject: [merged] kstrtox-use-unsigned-int-more.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:26:31 -0700
Message-ID: <20170711192631.dqx1vQ6d6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932973AbdGKT0c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kstrtox.c: use "unsigned int" more
has been removed from the -mm tree.  Its filename was
     kstrtox-use-unsigned-int-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib/kstrtox.c: use "unsigned int" more

gcc does generates stupid code sign extending data back and forth.  Help
by using "unsigned int".

	add/remove: 0/0 grow/shrink: 0/3 up/down: 0/-61 (-61)
	function                                     old     new   delta
	_parse_integer                               128     123      -5

It _still_ does generate useless MOVSX but I don't know how to delete it:

0000000000000070 <_parse_integer>:
			...
  a0:   89 c2                   mov    edx,eax
  a2:   83 e8 30                sub    eax,0x30
  a5:   83 f8 09                cmp    eax,0x9
  a8:   76 11                   jbe    bb <_parse_integer+0x4b>
  aa:   83 ca 20                or     edx,0x20
  ad:   0f be c2      ===>      movsx  eax,dl         <===
			useless
  b0:   8d 50 9f                lea    edx,[rax-0x61]
  b3:   83 fa 05                cmp    edx,0x5

Patch also helps on embedded archs which generally only like "int".
On arm "and 0xff" is generated which is waste because all values used in
comparisons are positive.

Link: http://lkml.kernel.org/r/20170514194720.GB32563@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN lib/kstrtox.c~kstrtox-use-unsigned-int-more lib/kstrtox.c
--- a/lib/kstrtox.c~kstrtox-use-unsigned-int-more
+++ a/lib/kstrtox.c
@@ -52,12 +52,14 @@ unsigned int _parse_integer(const char *
 	res = 0;
 	rv = 0;
 	while (1) {
+		unsigned int c = *s;
+		unsigned int lc = c | 0x20; /* don't tolower() this line */
 		unsigned int val;
 
-		if ('0' <= *s && *s <= '9')
-			val = *s - '0';
-		else if ('a' <= _tolower(*s) && _tolower(*s) <= 'f')
-			val = _tolower(*s) - 'a' + 10;
+		if ('0' <= c && c <= '9')
+			val = c - '0';
+		else if ('a' <= lc && lc <= 'f')
+			val = lc - 'a' + 10;
 		else
 			break;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

seq_file-delete-small-value-optimization.patch

