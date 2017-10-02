From: akpm@linux-foundation.org
Subject: + mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch
 added to -mm tree
Date: Mon, 02 Oct 2017 14:41:15 -0700
Message-ID: <59d2b27b./IpuVg2LN2r76yMG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdJBVlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 17:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rcampbell@nvidia.com, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: constify hmm_devmem_page_get_drvdata() parameter
has been added to the -mm tree.  Its filename is
     mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hmm-constify-hmm_devmem_page_get_drvdata-parameter.patch

