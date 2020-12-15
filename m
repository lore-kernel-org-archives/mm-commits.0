Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BC5C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74BC420709
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLODQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbgLODPl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:41 -0500
Date:   Mon, 14 Dec 2020 19:14:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002094;
        bh=6ZVf4hObHZw76Z42pSqFmGKGOdB4VzqhbCDaHZwNSbw=;
        h=From:To:Subject:In-Reply-To:From;
        b=TLIYD30Dl2g1XOnWvEK1QdoYRcZE4blnob6L9m/wwjjqLCDV52oXwRdu0s1sXRFHl
         l3KV0AsztK6J44PB3NTwGUEeveHJewdpjQASYHotBYLGQ+53tEc3vGCE8WLQbFLF5c
         TRtoEBuHnWo1pPdEOJgHYkxJv7lo+brNhtO5zl/M=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com,
        gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 197/200] mm: shmem: convert shmem_enabled_show to
 use sysfs_emit_at
Message-ID: <20201215031453.bwBJarhc5%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
