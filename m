Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09D0C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBBAC61D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhF2Cln (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2Clm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B525561D08;
        Tue, 29 Jun 2021 02:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934355;
        bh=2U/zUKy0sWMij0JlANJxis4SFX5DlLwfZYE18xDPxc0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y92eZ1w8XkFwCDX02vBf0B9doJmvs06evVC+KK6Qoy3YdGySIxa9cmQAaHEN+HZZv
         1mehkW1d8CnbHIpnYut5w9fjRoHc1tOYx1+OQwqz+18PiOzSp5Y59/Yv5b9f31FKx6
         A9NDKtPT9tLCx25HIaB6dfrYcuKPTJtmnZja0oAI=
Date:   Mon, 28 Jun 2021 19:39:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 113/192] x86/sgx: use vma_lookup() in
 sgx_encl_find()
Message-ID: <20210629023914.UwVt-_L7f%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: x86/sgx: use vma_lookup() in sgx_encl_find()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-10-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/sgx/encl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/encl.h~x86-sgx-use-vma_lookup-in-sgx_encl_find
+++ a/arch/x86/kernel/cpu/sgx/encl.h
@@ -91,8 +91,8 @@ static inline int sgx_encl_find(struct m
 {
 	struct vm_area_struct *result;
 
-	result = find_vma(mm, addr);
-	if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
+	result = vma_lookup(mm, addr);
+	if (!result || result->vm_ops != &sgx_vm_ops)
 		return -EINVAL;
 
 	*vma = result;
_
