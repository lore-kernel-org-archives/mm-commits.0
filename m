Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBA8C56202
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 07:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1215206C0
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 07:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DEi6iLFA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zwCuI9aS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbgKZH4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730005AbgKZH4M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Nov 2020 02:56:12 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89849C0613D4
        for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2020 23:56:11 -0800 (PST)
Date:   Thu, 26 Nov 2020 08:56:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606377367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U95+L8gWUr8++ltvH7wCPUX0/Q8aGlTsZJ8Z1hmlSeM=;
        b=DEi6iLFAxWyPIGP1RhewuAQBBEdfy+23jYHuaH6aGwPPgBEhL0s9m/hMbt6LqlE8KrnCqJ
        y+/oBWm6XIrXzcGEWkZQWtSxU7bpIbB0UPEHI+NQuVQykiswZJMHyxv8HEomSlnUd149BZ
        sgVOzCiIXlhxrN7ZfbmBF6HVi3GHj/nhVnqpvurRVhB4GrVSrae8YAU5WvLNGDOTqwBbYa
        lt+m1fx8zmR2GvWaajxvgq8526RsEUTT+zi10mzh8asSlOw6DoKkTJCg1dWu4kUnNv5KUL
        O/Bd7G6+DAAEfRnNwJTLYDEzVfb5muSsonYfPOhiLRHL2D0E/gP8RtkApRrm9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606377367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U95+L8gWUr8++ltvH7wCPUX0/Q8aGlTsZJ8Z1hmlSeM=;
        b=zwCuI9aSTRcOZeke4UE6F47gId7/tfUqC5RFedpP2fWRF0qOJRm7b7BR/2GT5aiAaZVQXQ
        88hE3IQVuY2coqAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     akpm@linux-foundation.org
Cc:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject: Re: + mm-support-thps-in-zero_user_segments-fix.patch added to -mm
 tree
Message-ID: <20201126075606.hzwhoahvqvruu2yz@linutronix.de>
References: <20201126000518.UwwC6jSEH%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201126000518.UwwC6jSEH%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2020-11-25 16:05:18 [-0800], akpm@linux-foundation.org wrote:
> ------------------------------------------------------
> From: Matthew Wilcox <willy@infradead.org>
> Subject:  opcode: 0000 EIP: zero_user_segments]
> 
> I didn't realise start1 was allowed to be less than start2.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This should be
   Reported-by:Naresh Kamboju <naresh.kamboju@linaro.org>

instead. I just helped with debugging and testing.

Sebastian
