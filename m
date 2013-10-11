From: akpm@linux-foundation.org
Subject: + jump_label-unlikelyx-0.patch added to -mm tree
Date: Fri, 11 Oct 2013 13:57:08 -0700
Message-ID: <52586624.gxkCNPUlX6RlRZt2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3JKU5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Oct 2013 16:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raghavendra.kt@linux.vnet.ibm.com, mingo@kernel.org, konrad.wilk@oracle.com, hpa@linux.intel.com, roel.kluin@gmail.com

Subject: + jump_label-unlikelyx-0.patch added to -mm tree
To: roel.kluin@gmail.com,hpa@linux.intel.com,konrad.wilk@oracle.com,mingo@kernel.org,raghavendra.kt@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 11 Oct 2013 13:57:08 -0700


The patch titled
     Subject: jump_label: unlikely(x) > 0
has been added to the -mm tree.  Its filename is
     jump_label-unlikelyx-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jump_label-unlikelyx-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jump_label-unlikelyx-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roel Kluin <roel.kluin@gmail.com>
Subject: jump_label: unlikely(x) > 0

untested, but wasn't this intended instead?
--------------
if (unlikely(x) > 0) doesn't seem to help branch prediction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
index a507907..cf08540 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jump_label.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/jump_label.h~jump_label-unlikelyx-0 include/linux/jump_label.h
--- a/include/linux/jump_label.h~jump_label-unlikelyx-0
+++ a/include/linux/jump_label.h
@@ -132,14 +132,14 @@ static __always_inline void jump_label_i
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	if (unlikely(atomic_read(&key->enabled)) > 0)
+	if (unlikely(atomic_read(&key->enabled) > 0))
 		return true;
 	return false;
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	if (likely(atomic_read(&key->enabled)) > 0)
+	if (likely(atomic_read(&key->enabled) > 0))
 		return true;
 	return false;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

jump_label-unlikelyx-0.patch

