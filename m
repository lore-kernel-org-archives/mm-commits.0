From: akpm@linux-foundation.org
Subject: [merged] headers_check-better-search-for-functions-in-headers.patch removed from -mm tree
Date: Wed, 15 Dec 2010 13:04:55 -0800
Message-ID: <201012152107.oBFL7a0X006025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240Ab0LOVME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 16:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: virtuoso@slind.org, amwang@redhat.com, mmarek@suse.cz, randy.dunlap@oracle.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     headers_check: better search for functions in headers
has been removed from the -mm tree.  Its filename was
     headers_check-better-search-for-functions-in-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
scsi-fix-a-header-to-include-linux-typesh.patch
toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch
cramfs-hide-function-prototypes-behind-__kernel__-macro.patch

