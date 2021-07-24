Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E323DC4338F
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jul 2021 02:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C8460E98
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jul 2021 02:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhGXBTZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:19:25 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:53048 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbhGXBTZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jul 2021 21:19:25 -0400
X-Greylist: delayed 952 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2021 21:19:25 EDT
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m76fo-003Lco-9E; Sat, 24 Jul 2021 01:41:52 +0000
Date:   Sat, 24 Jul 2021 01:41:52 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     bugs+kernel.org@dtnr.ch, dhowells@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject: Re: [patch 15/15] hugetlbfs: fix mount mode command line processing
Message-ID: <YPtv4E6Y/L1aGlK9@zeniv-ca.linux.org.uk>
References: <20210723154926.c6cda0f262b1990b950a5886@linux-foundation.org>
 <20210723225044.DpiHGbzxj%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723225044.DpiHGbzxj%akpm@linux-foundation.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 23, 2021 at 03:50:44PM -0700, Andrew Morton wrote:
> From: Mike Kravetz <mike.kravetz@oracle.com>
> Subject: hugetlbfs: fix mount mode command line processing
> 
> In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing of
> the mount mode string was changed from match_octal() to fsparam_u32.  This
> changed existing behavior as match_octal does not require octal values to
> have a '0' prefix, but fsparam_u32 does.
> 
> Use fsparam_u32oct which provides the same behavior as match_octal.

Looks sane...  Which tree do you want it to go through?
