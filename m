From: akpm@linux-foundation.org
Subject: + rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch
 added to -mm tree
Date: Thu, 22 Jan 2015 15:03:13 -0800
Message-ID: <54c181b1.dPAzPIQkVYq/ZLfT%akpm__28739.7223678001$1421967819$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbAVXDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:03:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, k.kozlowski@samsung.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s5m.c: terminate s5m_rtc_id array with empty element
has been added to the -mm tree.  Its filename is
     rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: drivers/rtc/rtc-s5m.c: terminate s5m_rtc_id array with empty element

Array of platform_device_id elements should be terminated with empty
element.

Fixes: 5bccae6ec458 ("rtc: s5m-rtc: add real-time clock driver for s5m8767")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s5m.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-s5m.c~rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element drivers/rtc/rtc-s5m.c
--- a/drivers/rtc/rtc-s5m.c~rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element
+++ a/drivers/rtc/rtc-s5m.c
@@ -832,6 +832,7 @@ static SIMPLE_DEV_PM_OPS(s5m_rtc_pm_ops,
 static const struct platform_device_id s5m_rtc_id[] = {
 	{ "s5m-rtc",		S5M8767X },
 	{ "s2mps14-rtc",	S2MPS14X },
+	{ },
 };
 
 static struct platform_driver s5m_rtc_driver = {
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

rtc-s5m-terminate-s5m_rtc_id-array-with-empty-element.patch
hugetlb-sysctl-pass-extra1-=-null-rather-then-extra1-=-zero.patch
mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch

