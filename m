Return-Path: <SRS0=Y9qB=DS=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0EBC433DF
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 03:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 777F520874
	for <mm-commits@archiver.kernel.org>; Sun, 11 Oct 2020 03:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602386840;
	bh=UDSgnvXvLJoIBiAf8SyZAjRhHh4qUFDQJwlegq72aL0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=A9MVjHerfmqgtPyMweiNA3r7s5Ahp73lVkfy4ItKpgOkIbefIdm9lFdKZi+ufCEJk
	 GPU3/NrYn+h4l2IoHpWAPtYdxspXoaea1o0qFkCiYL9YpD/xQ7UjSMx85yUuDlb7gd
	 Nnmzb2KPsp/rPpli9uNDwDyJiE1jSca/SC9Kj3vE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgJKD1T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Oct 2020 23:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgJKD1T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Oct 2020 23:27:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A994120773;
        Sun, 11 Oct 2020 03:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602386838;
        bh=UDSgnvXvLJoIBiAf8SyZAjRhHh4qUFDQJwlegq72aL0=;
        h=Date:From:To:Subject:From;
        b=XLCmM7vTF7xR+hFqljNtcnlHsq1o3AjeY7Lu3XuqcBv1ccSIMpp0iWEOhFPH0JhOT
         vi6PtXX4TYzXKLh6ExxSgMFIa/EsHyFMy1OU+ZoaER8ynsNrw5qLaWqNynsKgQK1TG
         sSJPJf3QZgpi0EH8wpqaSkkBuQRo3y8I6YeAgFjc=
Date:   Sat, 10 Oct 2020 20:27:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject:  + kernel-acctc-fix-some-kernel-doc-nits.patch added to
 -mm tree
Message-ID: <20201011032718.WPM5qYFtr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: acct.c: fix some kernel-doc nits
has been added to the -mm tree.  Its filename is
     kernel-acctc-fix-some-kernel-doc-nits.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-acctc-fix-some-kernel-doc-nits.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-acctc-fix-some-kernel-doc-nits.patch

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
Subject: kernel: acct.c: fix some kernel-doc nits

Fix kernel-doc notation to use the documented Returns: syntax and place
the function description for acct_process() on the first line where it
should be.

Link: https://lkml.kernel.org/r/b4c33e5d-98e8-0c47-77b6-ac1859f94d7f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/acct.c~kernel-acctc-fix-some-kernel-doc-nits
+++ a/kernel/acct.c
@@ -263,12 +263,12 @@ static DEFINE_MUTEX(acct_on_mutex);
  * sys_acct - enable/disable process accounting
  * @name: file name for accounting records or NULL to shutdown accounting
  *
- * Returns 0 for success or negative errno values for failure.
- *
  * sys_acct() is the only system call needed to implement process
  * accounting. It takes the name of the file where accounting records
  * should be written. If the filename is NULL, accounting will be
  * shutdown.
+ *
+ * Returns: 0 for success or negative errno values for failure.
  */
 SYSCALL_DEFINE1(acct, const char __user *, name)
 {
@@ -586,9 +586,7 @@ static void slow_acct_process(struct pid
 }
 
 /**
- * acct_process
- *
- * handles process accounting for an exiting task
+ * acct_process - handles process accounting for an exiting task
  */
 void acct_process(void)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
x86-numa-add-nohmat-option-fix.patch
mm-memoryc-fix-spello-of-function.patch
fs-configfs-delete-repeated-words-in-comments.patch
kernel-fix-repeated-words-in-comments.patch
kernel-acctc-fix-some-kernel-doc-nits.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

