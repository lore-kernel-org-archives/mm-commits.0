From: akpm@linux-foundation.org
Subject: [merged]
 mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:00:56 -0800
Message-ID: <20171116200056.t2awN2O55%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46356 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934974AbdKPUA6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/hmm: constify hmm_devmem_page_get_drvdata() parameter
has been removed from the -mm tree.  Its filename was
     mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: constify hmm_devmem_page_get_drvdata() parameter

Constify pointer parameter to avoid issue when use from code that only has
const struct page pointer to use in the first place.

Link: http://lkml.kernel.org/r/1506972774-10191-1-git-send-email-jglisse@redhat.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hmm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/hmm.h~mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter include/linux/hmm.h
--- a/include/linux/hmm.h~mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter
+++ a/include/linux/hmm.h
@@ -471,9 +471,9 @@ static inline void hmm_devmem_page_set_d
  * @page: pointer to struct page
  * Return: driver data value
  */
-static inline unsigned long hmm_devmem_page_get_drvdata(struct page *page)
+static inline unsigned long hmm_devmem_page_get_drvdata(const struct page *page)
 {
-	unsigned long *drvdata = (unsigned long *)&page->pgmap;
+	const unsigned long *drvdata = (const unsigned long *)&page->pgmap;
 
 	return drvdata[1];
 }
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


