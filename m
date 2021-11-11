Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F2FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95D261108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhKKCv7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234456AbhKKCv5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F4C60F26;
        Thu, 11 Nov 2021 02:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598949;
        bh=zWlk9M3T7l9JRJpnFqsfRQv0/JOC6xUrmBeiGNf9Zt4=;
        h=Date:From:To:Subject:From;
        b=or6pFrjS6UdWJFcbJ+8proxjNMChcDc3FKtgqKlnr1td+2mkZxL0tEVjr0xL3eZ1c
         FcyUDC3k2DW+Tx4lHly9osubX8Fd+R/5FVUf3z9oTELWFdGIwa0bZe2UWFyJFY9ehl
         cyWt62KnAb3HlidhvyK5BKgRJi3IHyBEgBh11K0o=
Date:   Wed, 10 Nov 2021 18:49:08 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged] selftests-damon-add-schemes-debugfs-tests.patch
 removed from -mm tree
Message-ID: <20211111024908.gkREWpkWY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: add 'schemes' debugfs tests
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-schemes-debugfs-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


