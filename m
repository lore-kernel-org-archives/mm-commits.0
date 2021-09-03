Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F821C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C326113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349516AbhICU7i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350362AbhICU7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96EED610FD;
        Fri,  3 Sep 2021 20:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702714;
        bh=iTgkESpbNeZU3r0LCT0j16UZyw1nxyhaRhUrWoMRTGw=;
        h=Date:From:To:Subject:From;
        b=wj5d9GCliG5sV3KA70dgnYE5gXf3Fjv+Y79q3tuAZratj0JlTl7bwLiWh1PLhLCSa
         jLPUm7AW/MgBOBPte8agCqvkJ+67KjOY4h6ck9iVAdegfUXP5RKBmfK6WD5j41yMJs
         u9LMZv+VdPWfPI+8xLBIvFXeCtq1dPdQhhFM4Fjg=
Date:   Fri, 03 Sep 2021 13:58:34 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, djwong@kernel.org, gregkh@linuxfoundation.org,
        hughd@google.com, jordy@pwning.systems, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [merged]
 mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch removed
 from -mm tree
Message-ID: <20210903205834.RbY0Yzcwm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change fault_in_pages_* to have an unsigned size parameter
has been removed from the -mm tree.  Its filename was
     mm-change-fault_in_pages_-to-have-an-unsigned-size-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -736,7 +736,7 @@ extern void add_page_wait_queue(struct p
 /*
  * Fault everything in given userspace address range in.
  */
-static inline int fault_in_pages_writeable(char __user *uaddr, int size)
+static inline int fault_in_pages_writeable(char __user *uaddr, size_t size)
 {
 	char __user *end = uaddr + size - 1;
 
@@ -763,7 +763,7 @@ static inline int fault_in_pages_writeab
 	return 0;
 }
 
-static inline int fault_in_pages_readable(const char __user *uaddr, int size)
+static inline int fault_in_pages_readable(const char __user *uaddr, size_t size)
 {
 	volatile char c;
 	const char __user *end = uaddr + size - 1;
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

percpu-remove-export-of-pcpu_base_addr.patch

