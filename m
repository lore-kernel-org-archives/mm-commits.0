From: akpm@linux-foundation.org
Subject: + checkpatch-fix-processing-of-memset-issues.patch added to -mm
 tree
Date: Wed, 10 Jun 2015 13:46:52 -0700
Message-ID: <5578a23c.tN9aHAqewE+tf9LP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbbFJUqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 16:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusz.kulikowski@gmail.com, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix processing of MEMSET issues
has been added to the -mm tree.  Its filename is
     checkpatch-fix-processing-of-memset-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-processing-of-memset-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-processing-of-memset-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Subject: checkpatch: fix processing of MEMSET issues

Remove 's' modifier to avoid reporting the same warning several times.

Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-processing-of-memset-issues scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-processing-of-memset-issues
+++ a/scripts/checkpatch.pl
@@ -5132,7 +5132,7 @@ sub process {
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
-		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/s) {
+		    $stat =~ /^\+(?:.*?)\bmemset\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*$FuncArg\s*\)/) {
 
 			my $ms_addr = $2;
 			my $ms_val = $7;
_

Patches currently in -mm which might be from mateusz.kulikowski@gmail.com are

checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
linux-next.patch

