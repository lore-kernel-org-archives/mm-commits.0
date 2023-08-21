Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7233EEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjHUUk1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjHUUkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D11CDB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A13D64AF5
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22C3C433C7;
        Mon, 21 Aug 2023 20:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650381;
        bh=PiFsOxk76TryFqH+0GeXRsqkmJjwCOsUnDqJPcuBJP4=;
        h=Date:To:From:Subject:From;
        b=xIf27ipXp5lo2GKNvHR205hae0uuxZL4DjFwSdWfjK+Y3yMKmQL2mwfQ/QlTQ6twS
         vnrHsH7vkQS6Ucbq+bCbEL8L7fdQ9iRqWIM8SMyZz3IIV/gQXbunT4i+lvKztL77nd
         rovzak+ySljg0Vm/Nc27hX2wqajtHjdB8WXHtVyk=
Date:   Mon, 21 Aug 2023 13:39:41 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch removed from -mm tree
Message-Id: <20230821203941.D22C3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for tried_regions/total_bytes
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for tried_regions/total_bytes
Date: Wed, 2 Aug 2023 21:32:21 +0000

Update the DAMON usage document for newly added
schemes/.../tried_regions/total_bytes file and the
update_schemes_tried_bytes command.

Link: https://lkml.kernel.org/r/20230802213222.109841-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   42 ++++++++++-------
 1 file changed, 27 insertions(+), 15 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,7 +87,7 @@ comma (","). ::
     │ │ │ │ │ │ │ filters/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
     │ │ │ │ │ │ │ stats/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
-    │ │ │ │ │ │ │ tried_regions/
+    │ │ │ │ │ │ │ tried_regions/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
@@ -127,14 +127,18 @@ in the state.  Writing ``commit`` to the
 user inputs in the sysfs files except ``state`` file again.  Writing
 ``update_schemes_stats`` to ``state`` file updates the contents of stats files
 for each DAMON-based operation scheme of the kdamond.  For details of the
-stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.  Writing
-``update_schemes_tried_regions`` to ``state`` file updates the DAMON-based
-operation scheme action tried regions directory for each DAMON-based operation
-scheme of the kdamond.  Writing ``clear_schemes_tried_regions`` to ``state``
-file clears the DAMON-based operating scheme action tried regions directory for
-each DAMON-based operation scheme of the kdamond.  For details of the
-DAMON-based operation scheme action tried regions directory, please refer to
-:ref:`tried_regions section <sysfs_schemes_tried_regions>`.
+stats, please refer to :ref:`stats section <sysfs_schemes_stats>`.
+
+Writing ``update_schemes_tried_regions`` to ``state`` file updates the
+DAMON-based operation scheme action tried regions directory for each
+DAMON-based operation scheme of the kdamond.  Writing
+``update_schemes_tried_bytes`` to ``state`` file updates only
+``.../tried_regions/total_bytes`` files.  Writing
+``clear_schemes_tried_regions`` to ``state`` file clears the DAMON-based
+operating scheme action tried regions directory for each DAMON-based operation
+scheme of the kdamond.  For details of the DAMON-based operation scheme action
+tried regions directory, please refer to :ref:`tried_regions section
+<sysfs_schemes_tried_regions>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
@@ -406,13 +410,21 @@ stats by writing a special keyword, ``up
 schemes/<N>/tried_regions/
 --------------------------
 
+This directory initially has one file, ``total_bytes``.
+
 When a special keyword, ``update_schemes_tried_regions``, is written to the
-relevant ``kdamonds/<N>/state`` file, DAMON creates directories named integer
-starting from ``0`` under this directory.  Each directory contains files
-exposing detailed information about each of the memory region that the
-corresponding scheme's ``action`` has tried to be applied under this directory,
-during next :ref:`aggregation interval <sysfs_monitoring_attrs>`.  The
-information includes address range, ``nr_accesses``, and ``age`` of the region.
+relevant ``kdamonds/<N>/state`` file, DAMON updates the ``total_bytes`` file so
+that reading it returns the total size of the scheme tried regions, and creates
+directories named integer starting from ``0`` under this directory.  Each
+directory contains files exposing detailed information about each of the memory
+region that the corresponding scheme's ``action`` has tried to be applied under
+this directory, during next :ref:`aggregation interval
+<sysfs_monitoring_attrs>`.  The information includes address range,
+``nr_accesses``, and ``age`` of the region.
+
+Writing ``update_schemes_tried_bytes`` to the relevant ``kdamonds/<N>/state``
+file will only update the ``total_bytes`` file, and will not create the
+subdirectories.
 
 The directories will be removed when another special keyword,
 ``clear_schemes_tried_regions``, is written to the relevant
_

Patches currently in -mm which might be from sj@kernel.org are


