Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2B4C4320A
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2408160FA0
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 20:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhG0UnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231133AbhG0UnD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 16:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 948FB60F9C;
        Tue, 27 Jul 2021 20:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627418582;
        bh=+1xBu4/BbS4D7z9HeivBMBKr9Iu5tBuA4zdelLy1hmg=;
        h=Date:From:To:Subject:From;
        b=VeSY1ZGwXKLk/4Jbgsr8hbWY4vZvKuEJJKrxTFWZa/tJ2UV8+Y9+Gzy9XMD6V28WE
         sExesoVd0NOio1OWi0kp5Emu0x0Ua3MSxE2P4HfIatoJTkquDTemzYCs0LOHRWBuxx
         V9inqnt4iyfN5aF6vn+6nNIspd5+A0ps2AgrJLpg=
Date:   Tue, 27 Jul 2021 13:43:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, mchehab+huawei@kernel.org,
        jordy@pwning.systems, hughd@google.com, djwong@kernel.org,
        dhowells@redhat.com, gregkh@linuxfoundation.org
Subject:  +
 mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch added to
 -mm tree
Message-ID: <20210727204302.VqGkS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change fault_in_pages_* to have an unsigned size parameter
has been added to the -mm tree.  Its filename is
     mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm: change fault_in_pages_* to have an unsigned size parameter

fault_in_pages_writeable() and fault_in_pages_readable() treat the size
parameter as unsigned, doing pointer math with the value, so make this
explicit and set it to be a size_t type which all callers currently treat
it as anyway.

This solves the issue where static checkers get nervous seeing pointer
arithmetic happening with a signed value.

Link: https://lkml.kernel.org/r/20210727111136.457638-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reported-by: Jordy Zomer <jordy@pwning.systems>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter
+++ a/include/linux/pagemap.h
@@ -786,7 +786,7 @@ extern void add_page_wait_queue(struct p
 /*
  * Fault everything in given userspace address range in.
  */
-static inline int fault_in_pages_writeable(char __user *uaddr, int size)
+static inline int fault_in_pages_writeable(char __user *uaddr, size_t size)
 {
 	char __user *end = uaddr + size - 1;
 
@@ -813,7 +813,7 @@ static inline int fault_in_pages_writeab
 	return 0;
 }
 
-static inline int fault_in_pages_readable(const char __user *uaddr, int size)
+static inline int fault_in_pages_readable(const char __user *uaddr, size_t size)
 {
 	volatile char c;
 	const char __user *end = uaddr + size - 1;
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch
percpu-remove-export-of-pcpu_base_addr.patch

