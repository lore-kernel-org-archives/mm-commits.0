From: akpm@linux-foundation.org
Subject: + gcov-add-gcov-profiling-infrastructure-update.patch added to -mm tree
Date: Wed, 03 Jun 2009 14:39:27 -0700
Message-ID: <200906032139.n53LdRI4012390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbZFCVj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 17:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com


The patch titled
     gcov-add-gcov-profiling-infrastructure-update
has been added to the -mm tree.  Its filename is
     gcov-add-gcov-profiling-infrastructure-update.patch

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
Subject: gcov-add-gcov-profiling-infrastructure-update
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

See below for the updated patch that uses strtoul instead of sscanf.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-update kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-update
+++ a/kernel/gcov/fs.c
@@ -70,15 +70,8 @@ static int gcov_persist = 1;
 
 static int __init gcov_persist_setup(char *str)
 {
-	int val;
-	char delim;
