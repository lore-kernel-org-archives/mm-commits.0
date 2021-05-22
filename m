Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF86C2B9FB
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC5D611AD
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhEVWLN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 18:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhEVWLN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 18:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1652561182;
        Sat, 22 May 2021 22:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621721388;
        bh=Y+CbtsVItI6NZChc0JYHPiLtlA9/E6tm5nRmDWK0u5A=;
        h=Date:From:To:Subject:From;
        b=2ga+UTpNle2PbdFKGme7vAaY9XFpHOlVj5+bwY/zsRoy2UP6WJepLw14lTT9Ftcw6
         TmtXms2u5j0IpF07aLuRXqXa2HOli84/nsTYWqE4eopzLV27P0LhpHZuLjOnED+7ld
         wT5hZEXMyuNWwSJB3qA4hVAtFW+nLlU48VR2b3Ak=
Date:   Sat, 22 May 2021 15:09:47 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, tony.luck@intel.com,
        yaoaili@kingsoft.com
Subject:  +
 =?US-ASCII?Q?mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-alr?=
 =?US-ASCII?Q?eady-been-poisoned.patch?= added to -mm tree
Message-ID: <20210522220947.baV5oLqpe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return -EHWPOISON to denote that the page has already been poisoned
has been added to the -mm tree.  Its filename is
     mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aili Yao <yaoaili@kingsoft.com>
Subject: mm,hwpoison: return -EHWPOISON to denote that the page has already been poisoned

When memory_failure() is called with MF_ACTION_REQUIRED on the page that
has already been hwpoisoned, memory_failure() could fail to send SIGBUS to
the affected process, which results in infinite loop of MCEs.

Currently memory_failure() returns 0 if it's called for already hwpoisoned
page, then the caller, kill_me_maybe(), could return without sending
SIGBUS to current process.  An action required MCE is raised when the
current process accesses to the broken memory, so no SIGBUS means that the
current process continues to run and access to the error page again soon,
so running into MCE loop.

This issue can arise for example in the following scenarios:

- Two or more threads access to the poisoned page concurrently.  If
  local MCE is enabled, MCE handler independently handles the MCE events. 
  So there's a race among MCE events, and the second or latter threads
  fall into the situation in question.

- If there was a precedent memory error event and memory_failure() for
  the event failed to unmap the error page for some reason, the subsequent
  memory access to the error page triggers the MCE loop situation.

To fix the issue, make memory_failure() return an error code when the
error page has already been hwpoisoned.  This allows memory error handler
to control how it sends signals to userspace.  And make sure that any
process touching a hwpoisoned page should get a SIGBUS even in "already
hwpoisoned" path of memory_failure() as is done in page fault path.

Link: https://lkml.kernel.org/r/20210521030156.2612074-3-nao.horiguchi@gmail.com
Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jue Wang <juew@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned
+++ a/mm/memory-failure.c
@@ -1244,7 +1244,7 @@ static int memory_failure_hugetlb(unsign
 	if (TestSetPageHWPoison(head)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 		       pfn);
-		return 0;
+		return -EHWPOISON;
 	}
 
 	num_poisoned_pages_inc();
@@ -1452,6 +1452,7 @@ try_again:
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
+		res = -EHWPOISON;
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from yaoaili@kingsoft.com are

mmhwpoison-return-ehwpoison-to-denote-that-the-page-has-already-been-poisoned.patch

