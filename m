Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EF8C5519F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 869D02419B
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qN8oI35A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgKPXPt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPXPt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:15:49 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1164E23A32;
        Mon, 16 Nov 2020 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568548;
        bh=w47SfsdezqrpxNNOs3Iucko6uHMoFntVmJ1SdvMTCp8=;
        h=Date:From:To:Subject:From;
        b=qN8oI35A3iqtLnYQ2qMYhDY1KYGltkzwoP/kw31dDWSgj+xDD2yvzw56B5QD9mk/y
         7FmIlmSZidcnTX+fZnUVl/D14qrVg3r8S84tzpd4TmLoNo2Cu908F2n4k0SouaoNYg
         KF43UZqchdjCZuGpwz43dLrnmFJMwJFJVNwBfQGs=
Date:   Mon, 16 Nov 2020 15:15:47 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  +
 mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch added to
 -mm tree
Message-ID: <20201116231547.CZfCifXID%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm:backing-dev: use sysfs_emit in macro defining functions
has been added to the -mm tree.  Its filename is
     mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm:backing-dev: use sysfs_emit in macro defining functions

The cocci script used in commit bdacbb8d04f ("mm: Use sysfs_emit for
struct kobject * uses") does not convert the name##_show macro because the
macro uses concatenation via ##.

Convert it by hand.

Link: https://lkml.kernel.org/r/45ec6cfc177d743f9c0ebaf35e43969dce43af42.1605376435.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-use-sysfs_emit-in-macro-defining-functions
+++ a/mm/backing-dev.c
@@ -150,11 +150,11 @@ static ssize_t read_ahead_kb_store(struc
 
 #define BDI_SHOW(name, expr)						\
 static ssize_t name##_show(struct device *dev,				\
-			   struct device_attribute *attr, char *page)	\
+			   struct device_attribute *attr, char *buf)	\
 {									\
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
 									\
-	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+	return sysfs_emit(buf, "%lld\n", (long long)expr);		\
 }									\
 static DEVICE_ATTR_RW(name);
 
@@ -200,11 +200,11 @@ BDI_SHOW(max_ratio, bdi->max_ratio)
 
 static ssize_t stable_pages_required_show(struct device *dev,
 					  struct device_attribute *attr,
-					  char *page)
+					  char *buf)
 {
 	dev_warn_once(dev,
 		"the stable_pages_required attribute has been removed. Use the stable_writes queue attribute instead.\n");
-	return snprintf(page, PAGE_SIZE-1, "%d\n", 0);
+	return sysfs_emit(buf, "%d\n", 0);
 }
 static DEVICE_ATTR_RO(stable_pages_required);
 
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
mm-use-sysfs_emit-for-struct-kobject-uses.patch
mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch
mm-backing-dev-use-sysfs_emit-in-macro-defining-functions.patch
mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch
mm-slub-convert-sysfs-sprintf-family-to-sysfs_emit-sysfs_emit_at.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
treewide-remove-stringification-from-__alias-macro-definition.patch

