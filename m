From: akpm@linux-foundation.org
Subject: [merged] jump_label-unlikelyx-0.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:04 -0800
Message-ID: <5283e3a4.LbAjlLErTvJhJWvG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab3KMUkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raghavendra.kt@linux.vnet.ibm.com, mingo@kernel.org, konrad.wilk@oracle.com, hpa@linux.intel.com, roel.kluin@gmail.com

Subject: [merged] jump_label-unlikelyx-0.patch removed from -mm tree
To: roel.kluin@gmail.com,hpa@linux.intel.com,konrad.wilk@oracle.com,mingo@kernel.org,raghavendra.kt@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:04 -0800


The patch titled
     Subject: jump_label: unlikely(x) > 0
has been removed from the -mm tree.  Its filename was
     jump_label-unlikelyx-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roel Kluin <roel.kluin@gmail.com>
Subject: jump_label: unlikely(x) > 0

if (unlikely(x) > 0) doesn't seem to help branch prediction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
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

origin.patch
linux-next.patch

