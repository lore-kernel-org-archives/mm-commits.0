From: akpm@linux-foundation.org
Subject: + dma-mapping-constify-attrs-passed-to-dma_get_attr.patch added
 to -mm tree
Date: Thu, 02 Jun 2016 16:11:04 -0700
Message-ID: <5750bd08.YwQMWl90IXnFHp0p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcFBXLF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, catalin.marinas@arm.com, joro@8bytes.org, konrad.wilk@oracle.com, linux@armlinux.org.uk, m.szyprowski@samsung.com, sstabellini@kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: constify attrs passed to dma_get_attr()
has been added to the -mm tree.  Its filename is
     dma-mapping-constify-attrs-passed-to-dma_get_attr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-constify-attrs-passed-to-dma_get_attr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-constify-attrs-passed-to-dma_get_attr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: dma-mapping: constify attrs passed to dma_get_attr()

The dma_get_attr() does not modify passed dma_attrs so the pointer can
point to const data.

Link: http://lkml.kernel.org/r/1464071290-15948-2-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-attrs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/dma-attrs.h~dma-mapping-constify-attrs-passed-to-dma_get_attr include/linux/dma-attrs.h
--- a/include/linux/dma-attrs.h~dma-mapping-constify-attrs-passed-to-dma_get_attr
+++ a/include/linux/dma-attrs.h
@@ -60,7 +60,8 @@ static inline void dma_set_attr(enum dma
  * @attr: attribute to set
  * @attrs: struct dma_attrs (may be NULL)
  */
-static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
+static inline int dma_get_attr(enum dma_attr attr,
+			       const struct dma_attrs *attrs)
 {
 	if (attrs == NULL)
 		return 0;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

dma-mapping-constify-attrs-passed-to-dma_get_attr.patch
arm-dma-mapping-constify-attrs-passed-to-internal-functions.patch
arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

