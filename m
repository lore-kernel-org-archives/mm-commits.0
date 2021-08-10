Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B38C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 10 Aug 2021 06:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFC661077
	for <mm-commits@archiver.kernel.org>; Tue, 10 Aug 2021 06:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbhHJG2I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235465AbhHJG2I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Aug 2021 02:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ACFA61051;
        Tue, 10 Aug 2021 06:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628576866;
        bh=wsT792XsHRADdJ0I0fF8xhBZ68xQaKLfBAPQV6BRKMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lhmVTz2kXmXdbSGQmt4u9uG4M5wiModJyY7PmPyx++tLHA77Ajh9cPWF06t/v/b0y
         HNAjHBa40o7TJJMIE+5pqbGXlr+GzWJjhDx6UmntxkRUCoafArdaK5782G42H1x9u6
         yYRoEQ5dWkkt8WCYfMq/LIyIdCU8n8HKx9QyIWHs=
Date:   Mon, 9 Aug 2021 23:27:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: mmotm 2021-08-09-19-18 uploaded
Message-Id: <20210809232743.a95e8f111f697eaff9418b2c@linux-foundation.org>
In-Reply-To: <3bc14281-4cfe-7cd6-1b88-128e51d08c3a@infradead.org>
References: <20210810021934.XcpwGUEMn%akpm@linux-foundation.org>
        <3bc14281-4cfe-7cd6-1b88-128e51d08c3a@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 9 Aug 2021 21:25:27 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> Hm, my patch scripts usually work, but this one gives me:
> 
> Hunk #5 FAILED at 603.
> Hunk #6 FAILED at 701.
> 2 out of 19 hunks FAILED -- rejects in file include/linux/memcontrol.h

oops, sorry, let me redo...
