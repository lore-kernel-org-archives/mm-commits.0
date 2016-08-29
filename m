From: akpm@linux-foundation.org
Subject: + kstrtox-smaller-_parse_integer.patch added to -mm tree
Date: Mon, 29 Aug 2016 14:59:57 -0700
Message-ID: <57c4b05d.hfZkHmweCsHLAxak%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38177 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755942AbcH2V77 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 17:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kstrtox.c: smaller _parse_integer()
has been added to the -mm tree.  Its filename is
     kstrtox-smaller-_parse_integer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kstrtox-smaller-_parse_integer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kstrtox-smaller-_parse_integer.patch

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

Patches currently in -mm which might be from adobriyan@gmail.com are

kbuild-simpler-generation-of-assembly-constants.patch
mm-unrig-vma-cache-hit-ratio.patch
proc-much-faster-proc-vmstat.patch
proc-faster-proc-status.patch
cred-simpler-1d-supplementary-groups.patch
make-isdigit-table-lookupless.patch
kstrtox-smaller-_parse_integer.patch

