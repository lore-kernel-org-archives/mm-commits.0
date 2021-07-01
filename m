Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A74C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC79961468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhGABvP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F58A6120C;
        Thu,  1 Jul 2021 01:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104125;
        bh=YOOzhUTqf7KWYxyFvUMrP7gImFxTqWLWGXQUYUpxmeA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EJHnh/B3d/0pOYMZqS6aopctm3R0gDAN9d5JEQoG3t9Z5lb5svMvm/qPEaqLoPqf9
         HhYpYuXNcBvhLgwWl1HDPUBg/MWQM6FRBq8ftpB2V+mMSriNq0bpm7LHG4gLG8X+qm
         Kz+fEWYL71ZAlLuiXM98ZfQTdNyvt6ZJiMZLZxpY=
Date:   Wed, 30 Jun 2021 18:48:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com,
        bgeffon@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, kirill@shutemov.name,
        linux-mm@kvack.org, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com
Subject:  [patch 031/192] userfaultfd/selftests: remove the time()
 check on delayed uffd
Message-ID: <20210701014844.ASqKQfeHh%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: remove the time() check on delayed uffd

There seems to have no guarantee that time() will return the same for the
two calls even if there's no delay, e.g.  when a fault is accidentally
crossing the changing of a second.  Meanwhile, this message is also not
helping that much since delay could happen with a lot of reasons, e.g.,
schedule latency of resolving thread.  It may not mean an issue with uffd.

Neither do I saw this error triggered either in the past runs.  Even if it
triggers, it'll be drown in all the rest of test logs.  Remove it.

Link: https://lkml.kernel.org/r/20210412232753.1012412-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-remove-the-time-check-on-delayed-uffd
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -395,7 +395,6 @@ static void *locking_thread(void *arg)
 	unsigned long long count;
 	char randstate[64];
 	unsigned int seed;
-	time_t start;
 
 	if (bounces & BOUNCE_RANDOM) {
 		seed = (unsigned int) time(NULL) - bounces;
@@ -432,7 +431,6 @@ static void *locking_thread(void *arg)
 			page_nr += 1;
 		page_nr %= nr_pages;
 
-		start = time(NULL);
 		if (bounces & BOUNCE_VERIFY) {
 			count = *area_count(area_dst, page_nr);
 			if (!count) {
@@ -495,12 +493,6 @@ static void *locking_thread(void *arg)
 		count++;
 		*area_count(area_dst, page_nr) = count_verify[page_nr] = count;
 		pthread_mutex_unlock(area_mutex(area_dst, page_nr));
-
-		if (time(NULL) - start > 1)
-			fprintf(stderr,
-				"userfault too slow %ld "
-				"possible false positive with overcommit\n",
-				time(NULL) - start);
 	}
 
 	return NULL;
_
