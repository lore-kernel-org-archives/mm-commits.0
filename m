From: akpm@linux-foundation.org
Subject: [patch 011/102] lib/kstrtox.c: smaller _parse_integer()
Date: Tue, 11 Oct 2016 13:51:32 -0700
Message-ID: <57fd50d4.fYS01VqndZrODxvm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcJKUwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib/kstrtox.c: smaller _parse_integer()

Set "overflow" bit upon encountering it instead of postponing to the end
of the conversion. Somehow gcc unwedges itself and generates better code:

	$ ./scripts/bloat-o-meter ../vmlinux-000 ../obj/vmlinux
	_parse_integer                      177     139     -38

Inspired by patch from Zhaoxiu Zeng.

Link: http://lkml.kernel.org/r/20160826221920.GA1909@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN lib/kstrtox.c~kstrtox-smaller-_parse_integer lib/kstrtox.c
--- a/lib/kstrtox.c~kstrtox-smaller-_parse_integer
+++ a/lib/kstrtox.c
@@ -48,11 +48,9 @@ unsigned int _parse_integer(const char *
 {
 	unsigned long long res;
 	unsigned int rv;
-	int overflow;
 
 	res = 0;
 	rv = 0;
-	overflow = 0;
 	while (*s) {
 		unsigned int val;
 
@@ -71,15 +69,13 @@ unsigned int _parse_integer(const char *
 		 */
 		if (unlikely(res & (~0ull << 60))) {
 			if (res > div_u64(ULLONG_MAX - val, base))
-				overflow = 1;
+				rv |= KSTRTOX_OVERFLOW;
 		}
 		res = res * base + val;
 		rv++;
 		s++;
 	}
 	*p = res;
-	if (overflow)
-		rv |= KSTRTOX_OVERFLOW;
 	return rv;
 }
 
_
