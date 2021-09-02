Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3186C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A277D6056B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347922AbhIBV5n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347809AbhIBV5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36EEC60FA0;
        Thu,  2 Sep 2021 21:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619804;
        bh=c5yA802kgCeNP/tLSxN9yttaY1VJIrX9mOtaDPcnYuI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sFaFLMJXkdHA5fm6uetk4dgigGOSRxF5qHj968JUlEvd4u2WLJWqK/smEPMUDN1tk
         6cujCyUx7GQG1eMebEaJA639Vcd2BPxfDACoeDp9lDBpMHhBdwlom3eRyz+ttGdpJf
         z0QcS1D2GCAz+mUn3thSAH8IADV36vonGqAaB3sw=
Date:   Thu, 02 Sep 2021 14:56:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com, djwong@kernel.org,
        gregkh@linuxfoundation.org, hughd@google.com, jordy@pwning.systems,
        linux-mm@kvack.org, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 126/212] mm: change fault_in_pages_* to have an
 unsigned size parameter
Message-ID: <20210902215643.s0dGtsXtL%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
