Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B868C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 578D7610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhKKCxE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCxE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87FB661108;
        Thu, 11 Nov 2021 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599016;
        bh=Asu7DG8/QDG2a4cnoJqQqI8GpSZnQjVxnfxUczWGOds=;
        h=Date:From:To:Subject:From;
        b=ka0KX6nWhX6d6suUYmjhcFZ+8/cjqeDCXRh898CDNxUU6ZcZ3VYO8xRJgkCR52Uvo
         N+dWJE19QcLolPdk8amxa0TX0hha5xkNGJrRfOrhlTOMKbDBCuquJjFq3JuiDkLCBv
         mo4Vfwyhwa1UWoBnB389liUG0tj2w8lqDYBWJXQ8=
Date:   Wed, 10 Nov 2021 18:50:15 -0800
From:   akpm@linux-foundation.org
To:     amit@kernel.org, benh@kernel.crashing.org, corbet@lwn.net,
        david@redhat.com, dwmw@amazon.com, elver@google.com,
        foersleo@amazon.de, gthelen@google.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de,
        mm-commits@vger.kernel.org, rientjes@google.com,
        shakeelb@google.com, shuah@kernel.org, sj@kernel.org
Subject:  [merged] selftests-damon-support-watermarks.patch removed
 from -mm tree
Message-ID: <20211111025015.EnSdfgnbS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: support watermarks
has been removed from the -mm tree.  Its filename was
     selftests-damon-support-watermarks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: support watermarks

This commit updates DAMON selftests for 'schemes' debugfs file to reflect
the changes in the format.

Link: https://lkml.kernel.org/r/20211019150731.16699-14-sj@kernel.org
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

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-support-watermarks
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -63,10 +63,10 @@ echo "$orig_content" > "$file"
 file="$DBGFS/schemes"
 orig_content=$(cat "$file")
 
-test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0 1 2 3" \
+test_write_succ "$file" "1 2 3 4 5 6 4 0 0 0 1 2 3 1 100 3 2 1" \
 	"$orig_content" "valid input"
 test_write_fail "$file" "1 2
-3 4 5 6 3 0 0 0 1 2 3" "$orig_content" "multi lines"
+3 4 5 6 3 0 0 0 1 2 3 1 100 3 2 1" "$orig_content" "multi lines"
 test_write_succ "$file" "" "$orig_content" "disabling"
 echo "$orig_content" > "$file"
 
_

Patches currently in -mm which might be from sj@kernel.org are


