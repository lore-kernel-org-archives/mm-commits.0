Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD779C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BE12098B
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598825247;
	bh=woYZOf1WWJ5+pj6KNTK+bz2MllUW72pQ3n7KFO4/dFw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m6aza7GeCzSECilZabi4N+vtLN7pHbS0TSxmR9957DfGOn64kD3E0AiKyAqGDUTB0
	 0NCIIJggFuDvoJF6QJzkccM5EudbtJM58/HVE9ZwoiG6+8xYlkYKYVrVzUedxbZyu3
	 mpItCLVn2ObX3wOVT4VYdsLOeUYZzCDwNlKDi0YY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgH3WH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WH0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:07:26 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FACB2083E;
        Sun, 30 Aug 2020 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598825245;
        bh=woYZOf1WWJ5+pj6KNTK+bz2MllUW72pQ3n7KFO4/dFw=;
        h=Date:From:To:Subject:From;
        b=W0qPNMna3HkGNtvP+66jdBE5/rI1N1WUUBM6UHSvZhLwctL2bRYIc4xM9VpWlMtNV
         tgilL6M4FxNAkiDwY29lYC7OWy9emp63jVMlxWMZQoXeQJEYEVOmdoOSEF/S1ibqgU
         LMyk1fdA+Qdbxktg/xy4CzVkX1kPr5ea8PidC6P8=
Date:   Sun, 30 Aug 2020 15:07:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        lkp@intel.com, dan.j.williams@intel.com, joao.m.martins@oracle.com
Subject:  + device-dax-add-an-align-attribute-fixpatch.patch added to
 -mm tree
Message-ID: <20200830220724.Tm9AE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: fix dax_align_valid() to work on PAGE_SHIFT>=14
has been added to the -mm tree.  Its filename is
     device-dax-add-an-align-attribute-fixpatch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-an-align-attribute-fixpatch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-an-align-attribute-fixpatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: fix dax_align_valid() to work on PAGE_SHIFT>=14

With ARM64_PAGE_SHIFT=14, we get:

In file included from drivers/dax/device.c:14:
drivers/dax/dax-private.h:94:12: warning: result of comparison of constant 68719476736
with expression of type 'unsigned int' is always false
[-Wtautological-constant-out-of-range-compare]
        if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
            ~~~~~ ^  ~~~~~~~~
In file included from drivers/dax/super.c:18:
drivers/dax/dax-private.h:94:12: warning: result of comparison of constant 68719476736
with expression of type 'unsigned int' is always false
[-Wtautological-constant-out-of-range-compare]
        if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
            ~~~~~ ^  ~~~~~~~~
In file included from drivers/dax/bus.c:10:
drivers/dax/dax-private.h:94:12: warning: result of comparison of constant 68719476736
with expression of type 'unsigned int' is always false
[-Wtautological-constant-out-of-range-compare]
        if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
            ~~~~~ ^  ~~~~~~~~

Or with ARM64_PAGE_SHIFT=16 && ARM64_VA_BITS_52=y:

In file included from drivers/dax/device.c:14:
drivers/dax/dax-private.h:94:12: warning: result of comparison of constant 4398046511104
with expression of type 'unsigned int' is always false
[-Wtautological-constant-out-of-range-compare]
        if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
            ~~~~~ ^  ~~~~~~~~
In file included from drivers/dax/super.c:18:
drivers/dax/dax-private.h:94:12: warning: result of comparison of constant 4398046511104
with expression of type 'unsigned int' is always false
[-Wtautological-constant-out-of-range-compare]
        if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
In file included from drivers/dax/bus.c:10:
drivers/dax/dax-private.h:94:12: warning: result of comparison of constant 4398046511104
with expression of type 'unsigned int' is always false
[-Wtautological-constant-out-of-range-compare]
        if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
            ~~~~~ ^  ~~~~~~~~

Change dax_align_valid() to unsigned long (dax_align_valid()
already is unsigned long). Note that in practice
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is only set on x86,
so a dax_align_valid(PUD_SIZE) check always return false.
An alternative would be to invert the check to:

	if (IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) && align == PUD_SIZE)

Link: http://lkml.kernel.org/r/435778c3-65c2-7e5d-578d-68cf89ae19bd@oracle.com
Link: https://lore.kernel.org/linux-mm/202008280906.WPrik7QQ%25lkp@intel.com/
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax-private.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dax/dax-private.h~device-dax-add-an-align-attribute-fixpatch
+++ a/drivers/dax/dax-private.h
@@ -89,7 +89,7 @@ static inline struct dax_mapping *to_dax
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline bool dax_align_valid(unsigned int align)
+static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
@@ -100,7 +100,7 @@ static inline bool dax_align_valid(unsig
 	return false;
 }
 #else
-static inline bool dax_align_valid(unsigned int align)
+static inline bool dax_align_valid(unsigned long align)
 {
 	return align == PAGE_SIZE;
 }
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

device-dax-add-dis-contiguous-resource-support-fix.patch
device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute-fix.patch
device-dax-add-an-align-attribute-fixpatch.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

