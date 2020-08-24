Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EDFC433E3
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976C920738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 20:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598300312;
	bh=VjgXarZGIUMFcM4o0jC6tQX0T3KvKNMN9F61cCoApvc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EzAhyjL7zWzUn5isnrQWL/4JDQvVTJ9DzL80eHo+iT/PpDPp3tz5JFYhNaOMYLRZa
	 OUSikvQu9HcLKyvbteAsDmcxbWqyR03iUtnisrEZFS06XjaB4EhX5HQ0yPCn7NRhhH
	 E/f7KbO/aZ6gYLBb65tHyXZ2aVxwO3cWX694IFoU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHXUSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHXUSa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 16:18:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA602074D;
        Mon, 24 Aug 2020 20:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598300309;
        bh=VjgXarZGIUMFcM4o0jC6tQX0T3KvKNMN9F61cCoApvc=;
        h=Date:From:To:Subject:From;
        b=TzQyD2Q8gCODucX/SLiHN0JnZ92aKNc7p4nwh2WfYgt8c4gYZeMJo72TGz9sZm3dV
         qhQFRr1m57zj+1SBoy/ASRckARPLo3W3VodaB/O/g+SqQBdH47DVPS0QvxQc37z+GK
         VJR3lO8i1IkGu2mEW4lkKQiD45IiwV5B0xxw0N44=
Date:   Mon, 24 Aug 2020 13:18:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + lib-syscall-delete-duplicated-words.patch added to -mm
 tree
Message-ID: <20200824201828.2xZv3LgNH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: syscall: delete duplicated words
has been added to the -mm tree.  Its filename is
     lib-syscall-delete-duplicated-words.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-syscall-delete-duplicated-words.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-syscall-delete-duplicated-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: syscall: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040514.26136-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/syscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/syscall.c~lib-syscall-delete-duplicated-words
+++ a/lib/syscall.c
@@ -44,7 +44,7 @@ static int collect_syscall(struct task_s
  *			 .data.instruction_pointer - filled with user PC
  *
  * If @target is blocked in a system call, returns zero with @info.data.nr
- * set to the the call's number and @info.data.args filled in with its
+ * set to the call's number and @info.data.args filled in with its
  * arguments. Registers not used for system call arguments may not be available
  * and it is not kosher to use &struct user_regset calls while the system
  * call is still in progress.  Note we may get this result if @target
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

