Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79017EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjHUUk6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjHUUkY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF96E5D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C49A64B15
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1326C433C7;
        Mon, 21 Aug 2023 20:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650394;
        bh=BjtIJUyZwLQEx5aG/wkLOG59LDzy/xwiUOrANQ2kHJU=;
        h=Date:To:From:Subject:From;
        b=YFWqRrW2XOlM99LdbPJabbGtdpe/Bhwgyqgts9VA23RK6Ly2r8DdvxqRapUtX0JME
         IjS4xncka9D5baEBzzWg3fvfNQsl40KhEJ3mrUKnKiKIGq/CVlmj34SuBv1lkBzOcL
         uiv5sMG0blYrXIRAf9YdC9jTeVWlkFu6g4ERgf3Y=
Date:   Mon, 21 Aug 2023 13:39:54 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch removed from -mm tree
Message-Id: <20230821203954.A1326C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/ABI/damon: update for DAMON monitoring target type DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for DAMON monitoring target type DAMOS filter
Date: Wed, 2 Aug 2023 21:43:11 +0000

Update DAMON ABI document for the newly added DAMON monitoring target type
DAMOS filter.

Link: https://lkml.kernel.org/r/20230802214312.110532-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -272,8 +272,9 @@ Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
 		the memory of the interest.  'anon' for anonymous pages,
-		'memcg' for specific memory cgroup, or 'addr' for address range
-		(an open-ended interval) can be written and read.
+		'memcg' for specific memory cgroup, 'addr' for address range
+		(an open-ended interval), or 'target' for DAMON monitoring
+		target can be written and read.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
 Date:		Dec 2022
@@ -296,6 +297,12 @@ Description:	If 'addr' is written to the
 		from this file sets or gets the end address of the address
 		range for the filter.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
+Date:		Dec 2022
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'target' is written to the 'type' file, writing to or
+		reading from this file sets or gets the index of the DAMON
+		monitoring target of the interest.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
 Date:		Dec 2022
_

Patches currently in -mm which might be from sj@kernel.org are


