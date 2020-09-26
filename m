Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708B5C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E3820936
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601086689;
	bh=o+vxYxHspLKkx90gGv8X72Xjda3OXk+u/F7ykifqRY8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LvSEYwOM5YOJ0PzMmUmaq9cl9Cw9M6XUgkAU96qh5NXH/IR+wiQu12ahB/VBpYmf+
	 uz8+6dcPNRdbR6MT1HbW9oaNbVF2xTNceOEcIjWEEFn2j3GyGg1Ugxm8jITaPq8eii
	 A4NLkKJtEo0YTnTIF3ScoZ+d3mX9rxM6GNYje8VI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgIZCSJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgIZCSI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:18:08 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7459520866;
        Sat, 26 Sep 2020 02:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601086687;
        bh=o+vxYxHspLKkx90gGv8X72Xjda3OXk+u/F7ykifqRY8=;
        h=Date:From:To:Subject:From;
        b=weDvoiGfJH8d9pt25knOQYRTczuBfTjS8a2CpUvNSfR5aoZXqV2xQq/NUH8rVZ49j
         VmyQ37lgPq4y1uq4OeE2CaftnDCvj3AoDWEN+b8Xj7xNf0oDyhSQZccksrEv2HChoW
         kZtHddZQDbpfsfoAy5zOBfVbdAPB5AtrWD20OLFA=
Date:   Fri, 25 Sep 2020 19:18:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        lkp@intel.com, dan.j.williams@intel.com, joao.m.martins@oracle.com
Subject:  [folded-merged]
 device-dax-add-an-align-attribute-fixpatch.patch removed from -mm tree
Message-ID: <20200926021806.7TbbB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: fix dax_align_valid() to work on PAGE_SHIFT>=14
has been removed from the -mm tree.  Its filename was
     device-dax-add-an-align-attribute-fixpatch.patch

This patch was dropped because it was folded into device-dax-add-an-align-attribute.patch

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

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-make-align-a-per-device-property.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

