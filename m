Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF50C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiI0CvN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiI0CtU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069EAAC24A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE34B80DA7
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCFBC433D7;
        Tue, 27 Sep 2022 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246916;
        bh=v7WO83anU6OsTAZP+/hutIf6Twq6IWQHVU0jCNKVeZs=;
        h=Date:To:From:Subject:From;
        b=Vy1yuL9g+hF6CAE5WaFaNnzI824PypGkz7N0SprEVg7gS1pEYfh/hF4MGhJNaDeEA
         aSqoTcSbQIScEBbQK4SLo0dDvwTxy3zCYlb81wp3pDWKvWWsOhmCf6CwXAidvefL3W
         f+795JLZIO+Y8UhWHnADr9vfNf9tR0WWHwMZG89U=
Date:   Mon, 26 Sep 2022 19:48:35 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-test-suite-add-lockdep_is_held-to-header.patch removed from -mm tree
Message-Id: <20220927024836.1BCFBC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: add lockdep_is_held to header
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-add-lockdep_is_held-to-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: radix tree test suite: add lockdep_is_held to header
Date: Tue, 6 Sep 2022 19:48:41 +0000

maple tree uses lockdep_is_held, so define it as external in the header.

Link: https://lkml.kernel.org/r/20220906194824.2110408-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/lockdep.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/radix-tree/linux/lockdep.h~radix-tree-test-suite-add-lockdep_is_held-to-header
+++ a/tools/testing/radix-tree/linux/lockdep.h
@@ -11,4 +11,6 @@ static inline void lockdep_set_class(spi
 					struct lock_class_key *key)
 {
 }
+
+extern int lockdep_is_held(const void *);
 #endif /* _LINUX_LOCKDEP_H */
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


