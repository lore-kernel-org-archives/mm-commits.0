Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB7FE936E5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244951AbjJDUXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244759AbjJDUWw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065B112
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043F6C433C7;
        Wed,  4 Oct 2023 20:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450968;
        bh=8hfHwAXZ7LGbGL1lrcVSzXJsqiJYgE4Eq18GOOziJfE=;
        h=Date:To:From:Subject:From;
        b=OKXYhlwOmKVGwlFk3yYZ3C26ZMw7YUI9dXWX1qLdjWdF8nB0W+PwBqe4SdX+rv+i/
         qTHWPjd2eDJ4UoTqUr0D5Bln+Hb6na3+KGJin8qdMPW1E6AmgExM5b21rgtof0QEE9
         rJU8m8uqEaQnxsoRQWWHpIbILkzKh+RugIQ6+YTU=
Date:   Wed, 04 Oct 2023 13:22:46 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-damos-apply-intervals.patch removed from -mm tree
Message-Id: <20231004202248.043F6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/ABI/damon: update for DAMOS apply intervals
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-damos-apply-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for DAMOS apply intervals
Date: Sat, 16 Sep 2023 02:09:45 +0000

Update DAMON ABI document for the newly added DAMON sysfs file for DAMOS
apply intervals (apply_interval_us file).

Link: https://lkml.kernel.org/r/20230916020945.47296-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-damos-apply-intervals
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -151,6 +151,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the action
 		of the scheme.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
+Date:		Sep 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the action apply interval of
+		the scheme in microseconds.  Reading this file returns the
+		value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/sz/min
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are


