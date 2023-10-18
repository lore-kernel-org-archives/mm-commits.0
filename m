Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF27CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjJRVoD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344906AbjJRVn6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D4AEA
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C62C433C7;
        Wed, 18 Oct 2023 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665436;
        bh=77ZpXLOxSydEIpqWxiSRRlFwtLV8QVIoIYiQng9ynI4=;
        h=Date:To:From:Subject:From;
        b=K216+Kztksnj+Cjqtg7j4CYgK8CV5U/23ldU71ZFxZ7ReBnwtt5mbkt6EMDfOpx1E
         JzMiKkL3nxhBJKuJVBMRLGKHcChkIJemmZ6aGcUcrQHxOCSBTSRLSDZ0dzUgdtNHen
         7to/zuNBCxMK6D+RlmZMjMcqONjK5QSs5B9l+Z0c=
Date:   Wed, 18 Oct 2023 14:43:55 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, oberpar@linux.ibm.com,
        ndesaulniers@google.com, nathan@kernel.org, gustavoars@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] gcov-annotate-struct-gcov_iterator-with-__counted_by.patch removed from -mm tree
Message-Id: <20231018214356.91C62C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gcov: annotate struct gcov_iterator with __counted_by
has been removed from the -mm tree.  Its filename was
     gcov-annotate-struct-gcov_iterator-with-__counted_by.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: gcov: annotate struct gcov_iterator with __counted_by
Date: Fri, 22 Sep 2023 10:52:20 -0700

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute.  Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct gcov_iterator.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Link: https://lkml.kernel.org/r/20230922175220.work.327-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/fs.c~gcov-annotate-struct-gcov_iterator-with-__counted_by
+++ a/kernel/gcov/fs.c
@@ -99,7 +99,7 @@ struct gcov_iterator {
 	struct gcov_info *info;
 	size_t size;
 	loff_t pos;
-	char buffer[];
+	char buffer[] __counted_by(size);
 };
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are


