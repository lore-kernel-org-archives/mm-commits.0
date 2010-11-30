From: akpm@linux-foundation.org
Subject: + headers_check-better-search-for-functions-in-headers.patch added to -mm tree
Date: Tue, 30 Nov 2010 13:51:13 -0800
Message-ID: <201011302151.oAULpDfM012220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0K3Vvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Nov 2010 16:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: virtuoso@slind.org, amwang@redhat.com, mmarek@suse.cz, randy.dunlap@oracle.com, shemminger@vyatta.com


The patch titled
     headers_check: better search for functions in headers
has been added to the -mm tree.  Its filename is
     headers_check-better-search-for-functions-in-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: headers_check: better search for functions in headers
From: Alexander Shishkin <virtuoso@slind.org>

Some headers don't bother with "extern" in function prototypes, which
results in said prototypes being unnoticed and exported to userland.

This patch slightly improves detection of such cases by checking for C
type names as well in the beginning of a line.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: WANG Cong <amwang@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/headers_check.pl~headers_check-better-search-for-functions-in-headers scripts/headers_check.pl
--- a/scripts/headers_check.pl~headers_check-better-search-for-functions-in-headers
+++ a/scripts/headers_check.pl
@@ -64,7 +64,7 @@ sub check_include
 
 sub check_declarations
 {
-	if ($line =~m/^\s*extern\b/) {
+	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
 		              "userspace cannot call function or variable " .
 		              "defined in the kernel\n";
_

Patches currently in -mm which might be from virtuoso@slind.org are

headers_check-better-search-for-functions-in-headers.patch

