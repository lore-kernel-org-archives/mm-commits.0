Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9A0C63777
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 549AE23A32
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R97pO2iJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgKPXPq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPXPq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:15:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED822225B;
        Mon, 16 Nov 2020 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568545;
        bh=oSdWrIwmsQMe8Y3GdVkv0s5a8SxYF9zRAnwjufVVky4=;
        h=Date:From:To:Subject:From;
        b=R97pO2iJi5mrZ77xyQLqfxud2jXe8j6MIK+16u5N0TxzTZPUKufz3YluV9RUYZXVe
         5XupylNOcbs0k6Kjq0RPvCvoUIpDqW5comTNVmXVjmGaI+2rLRCmg7KDfgfIFM1ZZD
         0oemdZdIH49wX714MtqKZej8Wt+ub2WBdPZNWjRQ=
Date:   Mon, 16 Nov 2020 15:15:44 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-huge=5Fmemory-convert-remaining-use-of-sprintf-to-sy?=
 =?US-ASCII?Q?sfs=5Femit-and-neatening.patch?= added to -mm tree
Message-ID: <20201116231544.EwjxXNN-g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: convert remaining use of sprintf to sysfs_emit and neatening
has been added to the -mm tree.  Its filename is
     mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch

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
Subject: mm: huge_memory: convert remaining use of sprintf to sysfs_emit and neatening

Convert the only use of sprintf with struct kobject * that the cocci
script could not convert.

Miscellanea:

o Neaten the uses of a constant string with sysfs_emit to use a const
  char * to reduce overall object size

Link: https://lkml.kernel.org/r/7df6be66bbd68e1a0bca9d35aca1341dbf94d2a7.1605376435.git.joe@perches.com
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

 mm/huge_memory.c |   52 ++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening
+++ a/mm/huge_memory.c
@@ -163,12 +163,17 @@ static struct shrinker huge_zero_page_sh
 static ssize_t enabled_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buf)
 {
+	const char *output;
+
 	if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags))
-		return sysfs_emit(buf, "[always] madvise never\n");
-	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags))
-		return sysfs_emit(buf, "always [madvise] never\n");
+		output = "[always] madvise never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+			  &transparent_hugepage_flags))
+		output = "always [madvise] never";
 	else
-		return sysfs_emit(buf, "always madvise [never]\n");
+		output = "always madvise [never]";
+
+	return sysfs_emit(buf, "%s\n", output);
 }
 
 static ssize_t enabled_store(struct kobject *kobj,
@@ -200,11 +205,11 @@ static struct kobj_attribute enabled_att
 	__ATTR(enabled, 0644, enabled_show, enabled_store);
 
 ssize_t single_hugepage_flag_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf,
-				enum transparent_hugepage_flag flag)
+				  struct kobj_attribute *attr, char *buf,
+				  enum transparent_hugepage_flag flag)
 {
-	return sprintf(buf, "%d\n",
-		       !!test_bit(flag, &transparent_hugepage_flags));
+	return sysfs_emit(buf, "%d\n",
+			  !!test_bit(flag, &transparent_hugepage_flags));
 }
 
 ssize_t single_hugepage_flag_store(struct kobject *kobj,
@@ -232,19 +237,24 @@ ssize_t single_hugepage_flag_store(struc
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags))
-		return sysfs_emit(buf,
-				  "[always] defer defer+madvise madvise never\n");
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags))
-		return sysfs_emit(buf,
-				  "always [defer] defer+madvise madvise never\n");
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags))
-		return sysfs_emit(buf,
-				  "always defer [defer+madvise] madvise never\n");
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags))
-		return sysfs_emit(buf,
-				  "always defer defer+madvise [madvise] never\n");
-	return sysfs_emit(buf, "always defer defer+madvise madvise [never]\n");
+	const char *output;
+
+	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
+		     &transparent_hugepage_flags))
+		output = "[always] defer defer+madvise madvise never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
+			  &transparent_hugepage_flags))
+		output = "always [defer] defer+madvise madvise never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
+			  &transparent_hugepage_flags))
+		output = "always defer [defer+madvise] madvise never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
+			  &transparent_hugepage_flags))
+		output = "always defer defer+madvise [madvise] never";
+	else
+		output = "always defer defer+madvise madvise [never]";
+
+	return sysfs_emit(buf, "%s\n", output);
 }
 
 static ssize_t defrag_store(struct kobject *kobj,
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

