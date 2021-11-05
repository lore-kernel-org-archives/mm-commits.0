Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537F0C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E65260240
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhKEUuZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhKEUuZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C4EB6120A;
        Fri,  5 Nov 2021 20:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145265;
        bh=R4r/odyeX8hiRT8ZlOOfKeCMIVXfEblvWhWF7Ydjfe0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xy3ys5cRWOtOqYCkhzhGTK803N/1njMPhcUgDiTbxBJ/Ifj8SOTy7r56rsokiEd7c
         yi4bdjmIPyCgHd/C8cgFMCH63A2YB81XHcwGzxMqO6Gqkt9ilfU+37ybBt1YzazBdW
         UmcYyhc6uPoHsEpnCe/d0ZfFEDHciFl1hzyw4AJA=
Date:   Fri, 05 Nov 2021 13:47:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 248/262] tools/selftests/damon: update for regions
 prioritization of schemes
Message-ID: <20211105204744.xk_yNocPQ%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
