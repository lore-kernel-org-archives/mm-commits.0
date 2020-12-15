Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D39C352A6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D3C22D05
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgLPAAd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbgLOX2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:12 -0500
Date:   Tue, 15 Dec 2020 15:24:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074683;
        bh=d07HkswqEGzfFdTmE7OmTI+96CI9iVfGSz0uB4Ai1cM=;
        h=From:To:Subject:From;
        b=dbXzEtCm9DVPeRZ3PyCPdnFRRSoRf2M7LEHc6kJ/od1KkoMfAbtPzMx2vEmwJ+0KH
         lvPX0F11nzQFTeno775k/z+0fmpub34TBCV+fB4VCLQeaMZAY8JwaiZS/Vh3XRXiBn
         SSMQJCP60iMTFg0ZL8fWRY+t4ouSiSPEWlOZ6cU8=
From:   akpm@linux-foundation.org
To:     cl@linux.com, gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, willy@infradead.org
Subject:  [merged]
 mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch removed from
 -mm tree
Message-ID: <20201215232442.rKyvOirEx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: convert shmem_enabled_show to use sysfs_emit_at
has been removed from the -mm tree.  Its filename was
     mm-shmem-convert-shmem_enabled_show-to-use-sysfs_emit_at.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4020,7 +4020,7 @@ out2:
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
 static ssize_t shmem_enabled_show(struct kobject *kobj,
-		struct kobj_attribute *attr, char *buf)
+				  struct kobj_attribute *attr, char *buf)
 {
 	static const int values[] = {
 		SHMEM_HUGE_ALWAYS,
@@ -4030,16 +4030,19 @@ static ssize_t shmem_enabled_show(struct
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

checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-update-__attribute__sectionname-quote-removal-v2.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch
treewide-remove-stringification-from-__alias-macro-definition.patch

