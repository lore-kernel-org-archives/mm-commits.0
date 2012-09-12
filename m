From: akpm@linux-foundation.org
Subject: + lib-gcdc-prevent-possible-div-by-0.patch added to -mm tree
Date: Wed, 12 Sep 2012 12:12:03 -0700
Message-ID: <20120912191203.AA247100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:65418 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2ILTME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 15:12:04 -0400
Received: by vcbfy27 with SMTP id fy27so90491vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 12:12:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org, eric.dumazet@gmail.com


The patch titled
     Subject: lib/gcd.c: prevent possible div by 0
has been added to the -mm tree.  Its filename is
     lib-gcdc-prevent-possible-div-by-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@gnu.org>
Subject: lib/gcd.c: prevent possible div by 0

Account for all properties when a and/or b are 0:
gcd(0, 0) = 0
gcd(a, 0) = a
gcd(0, b) = b

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
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

oom-remove-deprecated-oom_adj.patch
lib-gcdc-prevent-possible-div-by-0.patch

