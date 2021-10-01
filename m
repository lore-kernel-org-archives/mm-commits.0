Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B4AC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B0661A8E
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhJAXfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhJAXfk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A8761A6F;
        Fri,  1 Oct 2021 23:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633131235;
        bh=GZWv35v/2rMqCBBX/myl8tb0JA4KFFXqwUsCGFMZ2Lw=;
        h=Date:From:To:Subject:From;
        b=pDNig4x6JYp4D1aI91zKSitidS5V08W8Lw6GZ4zdRb1RKlUiLb5+abIL1EUyuuAxu
         RIGkofe3ElnO6OTo7IymVHa3aqDrHBerVFiS0xyYEDyh26rbM7deOg7MVXgaIAx47f
         7ZzSffdv1B9GnEgPMHiV7xAwF9HYpwiTA4WVVDAw=
Date:   Fri, 01 Oct 2021 16:33:54 -0700
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  + selftests-damon-add-schemes-debugfs-tests.patch added
 to -mm tree
Message-ID: <20211001233354.C-eN0-mpg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: add 'schemes' debugfs tests
has been added to the -mm tree.  Its filename is
     selftests-damon-add-schemes-debugfs-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-damon-add-schemes-debugfs-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-damon-add-schemes-debugfs-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: add 'schemes' debugfs tests

This commit adds simple selftets for 'schemes' debugfs file of DAMON.

Link: https://lkml.kernel.org/r/20211001125604.29660-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_attrs.sh |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-add-schemes-debugfs-tests
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -57,6 +57,19 @@ test_write_fail "$file" "1 2 3 5 4" "$or
 test_content "$file" "$orig_content" "1 2 3 4 5" "successfully written"
 echo "$orig_content" > "$file"
 
+# Test schemes file
+# =================
+
+file="$DBGFS/schemes"
+orig_content=$(cat "$file")
+
+test_write_succ "$file" "1 2 3 4 5 6 4" \
+	"$orig_content" "valid input"
+test_write_fail "$file" "1 2
+3 4 5 6 3" "$orig_content" "multi lines"
+test_write_succ "$file" "" "$orig_content" "disabling"
+echo "$orig_content" > "$file"
+
 # Test target_ids file
 # ====================
 
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch

