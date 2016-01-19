From: akpm@linux-foundation.org
Subject: [merged] errh-add-missing-unlikely-to-is_err_or_null.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:42 -0800
Message-ID: <569e9932.18UdzkH7dYPaUTCJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbcASUOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: err.h: add (missing) unlikely() to IS_ERR_OR_NULL()
has been removed from the -mm tree.  Its filename was
     errh-add-missing-unlikely-to-is_err_or_null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: err.h: add (missing) unlikely() to IS_ERR_OR_NULL()

IS_ERR_VALUE() already contains it and so we need to add this only to the
!ptr check.  That will allow users of IS_ERR_OR_NULL(), to not add this
compiler flag.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/err.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/err.h~errh-add-missing-unlikely-to-is_err_or_null include/linux/err.h
--- a/include/linux/err.h~errh-add-missing-unlikely-to-is_err_or_null
+++ a/include/linux/err.h
@@ -37,7 +37,7 @@ static inline bool __must_check IS_ERR(_
 
 static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
-	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+	return unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
 }
 
 /**
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are


