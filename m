Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FCCC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2375A2247F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgLODPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgLODOn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:43 -0500
Date:   Mon, 14 Dec 2020 19:14:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002042;
        bh=ru6ryEcr6nrj8Qs4TUJItGo6IS8Sr9pM0CkAvcz0KJU=;
        h=From:To:Subject:In-Reply-To:From;
        b=qa8uabiQbRKpNWp0LA2jYIXJO2+dxI/A1MDleT61RbpoS5nmMykRQWzWWzTM8lvhE
         2/nZi9TAoXJgVkXuIYMCynV5qqv9N7tvfaSyEBNqEar6Obe15EYv36jOrgvYfwIa50
         okU4uwh+fetamEe1c4MbndZRe/FOYK/buWkj32MU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 182/200] userfaultfd/selftests: always dump
 something in modes
Message-ID: <20201215031402.8uJvm2D5f%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: always dump something in modes

Patch series "userfaultfd: selftests: Small fixes".

Some very trivial fixes that I kept locally to userfaultfd selftest
program.  


This patch (of 3):

BOUNCE_POLL is a special bit that if cleared it means "READ" instead. 
Dump that too otherwise we'll see tests with empty modes.

Link: https://lkml.kernel.org/r/20201208024709.7701-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20201208024709.7701-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-always-dump-something-in-modes
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1291,6 +1291,8 @@ static int userfaultfd_stress(void)
 			printf(" ver");
 		if (bounces & BOUNCE_POLL)
 			printf(" poll");
+		else
+			printf(" read");
 		printf(", ");
 		fflush(stdout);
 
_
