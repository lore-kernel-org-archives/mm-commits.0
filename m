Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45017C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjFIXd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbjFIXcT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A379546B7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CD7763EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CCFC433EF;
        Fri,  9 Jun 2023 23:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353388;
        bh=8tTBvAhslM+TIY0xBIZGAc8HvBmUj8CW/gUuvHQfdwI=;
        h=Date:To:From:Subject:From;
        b=FCqEsqT9vZJAiKoscM9znhtnWwlu3AzuXZ+jN/W2JfzIB1HYTmAZKS42jUxjn6OpE
         najKsE4XUT4N0DCTPWXGsAkh/J58wCzr85TADfiJCN7a6adndfJeKY3S03HXfP85Ei
         Ugfl5o6PAICD3Ud4jboTzkOdLaATENH1c35/Ixh4=
Date:   Fri, 09 Jun 2023 16:29:47 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-a-section-for-damon-core-api.patch removed from -mm tree
Message-Id: <20230609232948.72CCFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/design: add a section for DAMON core API
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-a-section-for-damon-core-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add a section for DAMON core API
Date: Thu, 25 May 2023 21:43:13 +0000

Add a section covering the API of DAMON core layer on the design document.

Link: https://lkml.kernel.org/r/20230525214314.5204-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-a-section-for-damon-core-api
+++ a/Documentation/mm/damon/design.rst
@@ -358,3 +358,15 @@ example, the memory cgroup filter type a
 the memory cgroup for the filter.  Hence, users can apply specific schemes to
 only anonymous pages, non-anonymous pages, pages of specific cgroups, all pages
 excluding those of specific cgroups, and any combination of those.
+
+
+Application Programming Interface
+---------------------------------
+
+The programming interface for kernel space data access-aware applications.
+DAMON is a framework, so it does nothing by itself.  Instead, it only helps
+other kernel components such as subsystems and modules building their data
+access-aware applications using DAMON's core features.  For this, DAMON exposes
+its all features to other kernel components via its application programming
+interface, namely ``include/linux/damon.h``.  Please refer to the API
+:doc:`document </mm/damon/api>` for details of the interface.
_

Patches currently in -mm which might be from sj@kernel.org are


