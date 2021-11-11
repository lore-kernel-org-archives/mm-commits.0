Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AF5C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D095610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhKKCwn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD3226103C;
        Thu, 11 Nov 2021 02:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598995;
        bh=C7gTya1QuK47hS8FP8cQnT0GtuTF2KyYFTGZoaC7mAA=;
        h=Date:From:To:Subject:From;
        b=qKc65DMFM35qzWZcfIqqIIk1Ihn8ahKGvLucxSghXYgaUx4rAC7+Lopl53yAY5P88
         oJ21C7ZXrFy9vnLJuUy+Laxjfjqic9X+b4+o3ab9vkYO6vvz2jk0Hiha4zuThr3JF2
         n+yb6l0ZM4fXGCI2ewIa7nARHeNoRGP2AJZqVioM=
Date:   Wed, 10 Nov 2021 18:49:54 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged] mm-damon-selftests-support-schemes-quotas.patch
 removed from -mm tree
Message-ID: <20211111024954.I6JtCFB13%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/selftests: support schemes quotas
has been removed from the -mm tree.  Its filename was
     mm-damon-selftests-support-schemes-quotas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/selftests: support schemes quotas

This commit updates DAMON selftests to support updated schemes debugfs
file format for the quotas.

Link: https://lkml.kernel.org/r/20211019150731.16699-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
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

 tools/testing/selftests/damon/debugfs_attrs.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~mm-damon-selftests-support-schemes-quotas
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -63,10 +63,10 @@ echo "$orig_content" > "$file"
 file="$DBGFS/schemes"
 orig_content=$(cat "$file")
 
-test_write_succ "$file" "1 2 3 4 5 6 4" \
+test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0" \
 	"$orig_content" "valid input"
 test_write_fail "$file" "1 2
-3 4 5 6 3" "$orig_content" "multi lines"
+3 4 5 6 3 0 0 0" "$orig_content" "multi lines"
 test_write_succ "$file" "" "$orig_content" "disabling"
 echo "$orig_content" > "$file"
 
_

Patches currently in -mm which might be from sj@kernel.org are


