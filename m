Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B0BCE79A9
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 22:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbjISWrZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 18:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjISWrS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 18:47:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15024BF
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 15:47:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA78C433C7;
        Tue, 19 Sep 2023 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695163632;
        bh=tc1hGI9W2yS7F+08V9qa5F/pGyv5WzC60MY7OffHly0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zot10wfdnIc24zFozRSDuWxk8vWkG8gAO8QLe1iXGsporYzQpao6iOh7RlQsYkqF1
         NjjoRg8oyPJRaJ9U7ISRUVVRZYwZMiTsJhlx1l00/thISQcQHb/y7T+ld+LuD9s0Ls
         AwwCXO+eVVvF+6Kq9j+i3iDjYyAU5QAYGPgT/Ono=
Date:   Tue, 19 Sep 2023 15:47:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        oleg@redhat.com, giulio.benetti@benettiengineering.com,
        dave@stgolabs.net, ben.wolsieffer@hefring.com
Subject: Re: [merged mm-hotfixes-stable]
 proc-nommu-fix-empty-proc-pid-maps.patch removed from -mm tree
Message-Id: <20230919154711.faea9e6319bcf294e90b7f0e@linux-foundation.org>
In-Reply-To: <20230919221511.jvmorb5nqmjiybjf@revolver>
References: <20230919202216.D1DB3C433C9@smtp.kernel.org>
        <20230919221511.jvmorb5nqmjiybjf@revolver>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 19 Sep 2023 18:15:11 -0400 "Liam R. Howlett" <Liam.Howlett@Oracle.com> wrote:

> 
> I think this has the wrong fixes tag, as pointed out by willy.

Well kinda.  Do we have a better Fixes:?  

> It also does not fix the underlying failure of find_vma() not doing what
> is expected in nommu context.

It does fix the immediate /proc/N/maps problem though.  So I'm inclined
to run with this patch for now.
