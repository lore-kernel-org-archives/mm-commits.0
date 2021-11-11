Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB83C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA34361241
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbhKKCwz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:52:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AB0661108;
        Thu, 11 Nov 2021 02:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599007;
        bh=+vmYHArwkGBRmkd9TzSza0fizKYkbxyV4nRplcsI7tQ=;
        h=Date:From:To:Subject:From;
        b=j3qP0fnASuBweIczfYzfNdlLZD+Lx7lH1MPwckSjf0jVXBDwaCpjfZo2CHQv5wB6u
         H/a2VpuoiaK/JjDDqKGHKb3RMUdrj8TYvD5B+o3ws7UWAtjcukyGo3Xd4jIfP2SQS7
         9MTXk2PyLdxHt1VEErxvgakEKysXcyAUZRPy7ECE=
Date:   Wed, 10 Nov 2021 18:50:06 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged]
 tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
 removed from -mm tree
Message-ID: <20211111025006.igHh5H7fT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/selftests/damon: update for regions prioritization of schemes
has been removed from the -mm tree.  Its filename was
     tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: tools/selftests/damon: update for regions prioritization of schemes

This commit updates the DAMON selftests for 'schemes' debugfs file, as the
file format is updated.

Link: https://lkml.kernel.org/r/20211019150731.16699-11-sj@kernel.org
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

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~tools-selftests-damon-update-for-regions-prioritization-of-schemes
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -63,10 +63,10 @@ echo "$orig_content" > "$file"
 file="$DBGFS/schemes"
 orig_content=$(cat "$file")
 
-test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0" \
+test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0 1 2 3" \
 	"$orig_content" "valid input"
 test_write_fail "$file" "1 2
-3 4 5 6 3 0 0 0" "$orig_content" "multi lines"
+3 4 5 6 3 0 0 0 1 2 3" "$orig_content" "multi lines"
 test_write_succ "$file" "" "$orig_content" "disabling"
 echo "$orig_content" > "$file"
 
_

Patches currently in -mm which might be from sj@kernel.org are


