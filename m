Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AEBC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF9A6136A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhKEUtR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhKEUtR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA396120A;
        Fri,  5 Nov 2021 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145197;
        bh=X1wWSguvt0r17lGh2MG5wB182QPXV4yBUf97OZieb0A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OvCD3QAtNJZfPmdakaopAyVFcClQ1UzeMTBzpztoaRHadfdy0ehTbTo0Q9Vaw8JrP
         9SyVZ9OaWWgEStWtSbdzlDOXShWaOzBQn6i0y7TeGqDEo0Jn8xN5v/GwnZ1qr+Puwz
         4ytlXQbADw36yfK17MqAa7Aj6XhE5dj4C6RCzyM8=
Date:   Fri, 05 Nov 2021 13:46:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 228/262] selftests/damon: add 'schemes' debugfs
 tests
Message-ID: <20211105204636.V-75NEmx0%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
