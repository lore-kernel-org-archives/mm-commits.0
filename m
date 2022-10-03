Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CBCC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJCVMK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiJCVKi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439295140D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC4006118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21584C433D6;
        Mon,  3 Oct 2022 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831214;
        bh=vIJrrCO1lrfUggrrTRtGdEavpv6c/2pU0PS56vmilGM=;
        h=Date:To:From:Subject:From;
        b=YpLQpByagE6458Xts50lLsrli40forQW6O0WdGlyzI71Qy5+NeTMJ8DW151TZAz0h
         jopIM30dy5EzJo0eacOvofwrHWSQRc6teNpBikNY1VF9j1ZLLi9q7LdjQR9zX5nC8n
         CQC+5sTIcm7Xg4mVVbpVCyW7Fx7hyWciAKbau0fc=
Date:   Mon, 03 Oct 2022 14:06:53 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-kconfig-notify-debugfs-deprecation-plan.patch removed from -mm tree
Message-Id: <20221003210654.21584C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/Kconfig: notify debugfs deprecation plan
has been removed from the -mm tree.  Its filename was
     mm-damon-kconfig-notify-debugfs-deprecation-plan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/Kconfig: notify debugfs deprecation plan
Date: Fri, 9 Sep 2022 20:28:59 +0000

Commit b18402726bd1 ("Docs/admin-guide/mm/damon/usage: document DAMON
sysfs interface") announced the DAMON debugfs interface deprecation plan,
but it is not so aggressively announced.  As the deprecation time is
coming, this commit makes the announce more easy to be found by adding the
note to the config menu of DAMON debugfs interface.

Link: https://lkml.kernel.org/r/20220909202901.57977-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/Kconfig~mm-damon-kconfig-notify-debugfs-deprecation-plan
+++ a/mm/damon/Kconfig
@@ -68,6 +68,9 @@ config DAMON_DBGFS
 
 	  If unsure, say N.
 
+	  This will be removed after >5.15.y LTS kernel is released, so users
+	  should move to the sysfs interface (DAMON_SYSFS).
+
 config DAMON_DBGFS_KUNIT_TEST
 	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
 	depends on DAMON_DBGFS && KUNIT=y
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

