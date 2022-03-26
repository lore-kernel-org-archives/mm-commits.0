Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C897BC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 19:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiCZTwa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 26 Mar 2022 15:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiCZTw1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2022 15:52:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F872D1EA
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 12:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF201B80B83
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 19:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3B6C2BBE4;
        Sat, 26 Mar 2022 19:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648324248;
        bh=1ICrjt1AyVn7hkEXUv1VBiB/LHPFZj4IqR11e9o0mVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n7BwXre1zaUmHUpDUs6QbT3HmB4B7ywzeXTwc92OkPACFOEUfQ2UOH4U/NrIAOFrx
         8bZDZtnCh76Uf7nom1vQkzzz9znCUKo0GRb/rvNzCLzlibBGrOekK2QhDLjVxMHpl9
         3cTtBuLpoBqCN+o3MdiifWp+0GPUU4w9m23Hp1UE=
Date:   Sat, 26 Mar 2022 12:50:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     mm-commits@vger.kernel.org
Subject: Re: +
 proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
 added to -mm tree
Message-Id: <20220326125047.684917930c7683cbbd9930e0@linux-foundation.org>
In-Reply-To: <Yj8kPp6FctCnMu7a@localhost.localdomain>
References: <20220326032728.43D0EC004DD@smtp.kernel.org>
        <Yj8kPp6FctCnMu7a@localhost.localdomain>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 26 Mar 2022 17:33:34 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Mar 25, 2022 at 08:27:27PM -0700, Andrew Morton wrote:
>  
> > WARNING: braces {} are not necessary for single statement blocks
> 
> Who is inventing all these silly rules?

um, Linus?

: Do not unnecessarily use braces where a single statement will do.
: 
: .. code-block:: c
: 
: 	if (condition)
: 		action();

has been in Documentation/process/coding-style.rst since 2015 and it
was in Documentation/CodingStyle for infinity.
