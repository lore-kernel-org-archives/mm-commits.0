From: akpm@linux-foundation.org
Subject: [merged] lib-gcdc-prevent-possible-div-by-0.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:42 -0700
Message-ID: <20121005201543.24461200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:58361 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2JEUPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:45 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so141020lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, eric.dumazet@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/gcd.c: prevent possible div by 0
has been removed from the -mm tree.  Its filename was
     lib-gcdc-prevent-possible-div-by-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@gnu.org>
Subject: lib/gcd.c: prevent possible div by 0

Account for all properties when a and/or b are 0:
gcd(0, 0) = 0
gcd(a, 0) = a
gcd(0, b) = b

Fixes no known problems in current kernels.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gcd.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/gcd.c~lib-gcdc-prevent-possible-div-by-0 lib/gcd.c
--- a/lib/gcd.c~lib-gcdc-prevent-possible-div-by-0
+++ a/lib/gcd.c
@@ -9,6 +9,9 @@ unsigned long gcd(unsigned long a, unsig
 
 	if (a < b)
 		swap(a, b);
+
+	if (!b)
+		return a;
 	while ((r = a % b) != 0) {
 		a = b;
 		b = r;
_

Patches currently in -mm which might be from dave@gnu.org are

origin.patch
oom-remove-deprecated-oom_adj.patch

