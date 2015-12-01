From: akpm@linux-foundation.org
Subject: + errh-add-missing-unlikely-to-is_err_or_null.patch added to -mm
 tree
Date: Mon, 30 Nov 2015 16:39:34 -0800
Message-ID: <565cec46.Vl0VAtmJzOBVp2EF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbLAAjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 19:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: err.h: add (missing) unlikely() to IS_ERR_OR_NULL()
has been added to the -mm tree.  Its filename is
     errh-add-missing-unlikely-to-is_err_or_null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/errh-add-missing-unlikely-to-is_err_or_null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/errh-add-missing-unlikely-to-is_err_or_null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

errh-add-missing-unlikely-to-is_err_or_null.patch

