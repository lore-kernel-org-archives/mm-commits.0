Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414DBEE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjHUUkk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjHUUkQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66062E44
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D23EE6462E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35180C433C8;
        Mon, 21 Aug 2023 20:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650388;
        bh=leHQajKUy1G7ttP8BhwC4jC3HoieupRov19OzITpdKE=;
        h=Date:To:From:Subject:From;
        b=XTyzGvufNtxOLNFAvzHPV8drCXBNwOpwKKixX370UCu3KPi/7g5+Pm4z67XEnOl9T
         qtsj1jI1gC6YWH/ahJWh8CEYGbsqaK/S/tSamF33nkKxjjFWShiLWwVSu1IIFOGe2Y
         6SfSy8nvIvicsarFQVTNuDCQQSQFhQ1M0wxcnNaM=
Date:   Mon, 21 Aug 2023 13:39:47 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-update-for-address-range-damos-filter.patch removed from -mm tree
Message-Id: <20230821203948.35180C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/ABI/damon: update for address range DAMOS filter
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-update-for-address-range-damos-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for address range DAMOS filter
Date: Wed, 2 Aug 2023 21:43:05 +0000

Update DAMON ABI document for address ranges type DAMOS filter files.

Link: https://lkml.kernel.org/r/20230802214312.110532-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   20 ++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-address-range-damos-filter
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -271,8 +271,9 @@ What:		/sys/kernel/mm/damon/admin/kdamon
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the type of
-		the memory of the interest.  'anon' for anonymous pages, or
-		'memcg' for specific memory cgroup can be written and read.
+		the memory of the interest.  'anon' for anonymous pages,
+		'memcg' for specific memory cgroup, or 'addr' for address range
+		(an open-ended interval) can be written and read.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/memcg_path
 Date:		Dec 2022
@@ -281,6 +282,21 @@ Description:	If 'memcg' is written to th
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_start
+Date:		Jul 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'addr' is written to the 'type' file, writing to or reading
+		from this file sets or gets the start address of the address
+		range for the filter.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/addr_end
+Date:		Jul 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'addr' is written to the 'type' file, writing to or reading
+		from this file sets or gets the end address of the address
+		range for the filter.
+
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/matching
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are


