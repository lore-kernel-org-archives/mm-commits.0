Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A863DC2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77141224B0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgLODQE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgLODPI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:08 -0500
Date:   Mon, 14 Dec 2020 19:14:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002087;
        bh=ICh4Yg/CZEtWrOrlSSdViegqZLcbT3VpnivsWaIh3ak=;
        h=From:To:Subject:In-Reply-To:From;
        b=Lrz2xYF/PcqGX90PNTIdODg/Eo8FwxY24b3bXpHboLNm6p040hwfaEDt9W7NcR96y
         EkMjJUIuVNqDWVVoZnyareNFYsurwWq2oHYVQZJqlE7lvpZo6eZeZA3YqJ2+DaPXPF
         UGjvoZMy+CNyTlXUR6fYnz46MqwnXWWQ7lZ6F2bs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com,
        gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 195/200] mm: huge_memory: convert remaining use of
 sprintf to sysfs_emit and neatening
Message-ID: <20201215031446.Yny2cxDmM%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
