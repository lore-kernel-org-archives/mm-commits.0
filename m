Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08116C63798
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE4823A32
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9+5sbtw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgKPXPy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPXPy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:15:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E475A2223D;
        Mon, 16 Nov 2020 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605568552;
        bh=aXyJ5suE05cbFMf/44vIxnsax0oQe0yRwTZbJQDsYvw=;
        h=Date:From:To:Subject:From;
        b=Z9+5sbtwGK9tvHR2sVVEfw2adrgambqhSw1HBEw+GY/lJkY5OeymEL9AJY3TqwG6A
         hxrMbT5aJ0szaVf8JnfWqbM50GIX41C8RicDu2eKx1g5qk3cpcjno2/D+Bg/n8vD2e
         p88x7COr87N6GQVjCRcPj47Y4+H+RubI0ViCta8k=
Date:   Mon, 16 Nov 2020 15:15:50 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  +
 mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch added to -mm
 tree
Message-ID: <20201116231550.gSWGabEuQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: convert shmem_enabled_show to use sysfs_emit_at
has been added to the -mm tree.  Its filename is
     mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch

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
Subject: mm: shmem: convert shmem_enabled_show to use sysfs_emit_at

Update the function to use sysfs_emit_at while neatening the uses of
sprintf and overwriting the last space char with a newline to avoid
possible output buffer overflow.

Miscellanea:

o in shmem_enabled_show, the removal of the indirected use of fmt
  allows __printf verification

Link: https://lkml.kernel.org/r/b612a93825e5ea330cb68d2e8b516e9687a06cc6.1605376435.git.joe@perches.com
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

 mm/shmem.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at
+++ a/mm/shmem.c
@@ -3918,7 +3918,7 @@ out2:
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
 static ssize_t shmem_enabled_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				  struct kobj_attribute *attr, char *buf)
 {
 	static const int values[] = {
 		SHMEM_HUGE_ALWAYS,
@@ -3928,16 +3928,19 @@ static ssize_t shmem_enabled_show(struct
 		SHMEM_HUGE_DENY,
 		SHMEM_HUGE_FORCE,
 	};
-	int i, count;
+	int len = 0;
+	int i;
 
-	for (i = 0, count = 0; i < ARRAY_SIZE(values); i++) {
-		const char *fmt = shmem_huge == values[i] ? "[%s] " : "%s ";
-
-		count += sprintf(buf + count, fmt,
-				shmem_format_huge(values[i]));
+	for (i = 0; i < ARRAY_SIZE(values); i++) {
+		len += sysfs_emit_at(buf, len,
+				     shmem_huge == values[i] ? "%s[%s]" : "%s%s",
+				     i ? " " : "",
+				     shmem_format_huge(values[i]));
 	}
-	buf[count - 1] = '\n';
-	return count;
+
+	len += sysfs_emit_at(buf, len, "\n");
+
+	return len;
 }
 
 static ssize_t shmem_enabled_store(struct kobject *kobj,
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

