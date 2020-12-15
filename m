Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68EBC35296
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BAA22D07
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgLPAAd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbgLOX2N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:13 -0500
Date:   Tue, 15 Dec 2020 15:24:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074676;
        bh=6vcotkoK66YMKBZG7hDAXQBWCCxcGYtkdARKbx/FwTQ=;
        h=From:To:Subject:From;
        b=kFE/kmmmLo1suGyOrjWYiiPMAK2WDZgZw1x9Z+fGaDlxcsWVcivoWyHzM/Q986Tg6
         oriXIyhGbTaxF7s3l21Qe5yqc+2QVogBxsB9FZ986ohLv958hDGWyGs9LD0fa69Ada
         3h80GwYZPr/DMHd/P42x8madrUNq+eDiMAsEe5Ag=
From:   akpm@linux-foundation.org
To:     cl@linux.com, gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-huge=5Fmemory-convert-remaining-use-of-sprintf-to-sy?=
 =?US-ASCII?Q?sfs=5Femit-and-neatening.patch?= removed from -mm tree
Message-ID: <20201215232436.aoFJ5d65r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: convert remaining use of sprintf to sysfs_emit and neatening
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-remaining-use-of-sprintf-to-sysfs_emit-and-neatening.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch
treewide-remove-stringification-from-__alias-macro-definition.patch

