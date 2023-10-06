Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE85BE94130
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbjJFVte (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbjJFVt2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:49:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ED7BF
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:49:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F97EC433C9;
        Fri,  6 Oct 2023 21:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628967;
        bh=+GNBA9ZUTtiLaEt99zUblRdgYF8LGG/X94CI/kK4QQ4=;
        h=Date:To:From:Subject:From;
        b=sgtc9Yrw5r7MGkmqoiW9yk7Qllpkcw95xv4Ejd70od5JQhjrsoPk3iCMMRHy/7L1o
         EoqkLl7vOZtaT0OZmhTf/NgZXAR9kzRhebjFSA+TM8COIvYaig9G34O72v3dEq4DFI
         p4T1l17PhlHVPzZ8ezW8rFOplWS1XiPeHg5MW1GE=
Date:   Fri, 06 Oct 2023 14:49:24 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-document-pages_skipped-sysfs-knob.patch removed from -mm tree
Message-Id: <20231006214926.8F97EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: document pages_skipped sysfs knob
has been removed from the -mm tree.  Its filename was
     mm-ksm-document-pages_skipped-sysfs-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: document pages_skipped sysfs knob
Date: Mon, 25 Sep 2023 21:09:39 -0700

This adds documentation for the new metric pages_skipped.

Link: https://lkml.kernel.org/r/20230926040939.516161-5-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-pages_skipped-sysfs-knob
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -178,6 +178,8 @@ pages_unshared
         how many pages unique but repeatedly checked for merging
 pages_volatile
         how many pages changing too fast to be placed in a tree
+pages_skipped
+        how many pages did the "smart" page scanning algorithm skip
 full_scans
         how many times all mergeable areas have been scanned
 stable_node_chains
_

Patches currently in -mm which might be from shr@devkernel.io are


