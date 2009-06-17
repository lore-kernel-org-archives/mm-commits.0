From: akpm@linux-foundation.org
Subject: [folded] gcov-add-gcov-profiling-infrastructure-update.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:56:07 -0700
Message-ID: <200906172256.n5HMu7SU015643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbZFQW4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     gcov-add-gcov-profiling-infrastructure-update
has been removed from the -mm tree.  Its filename was
     gcov-add-gcov-profiling-infrastructure-update.patch

This patch was dropped because it was folded into gcov-add-gcov-profiling-infrastructure.patch

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
