Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F9DC001B0
	for <mm-commits@archiver.kernel.org>; Mon,  3 Jul 2023 08:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjGCINL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Jul 2023 04:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjGCINK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jul 2023 04:13:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE0B91
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 01:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B02560DF6
        for <mm-commits@vger.kernel.org>; Mon,  3 Jul 2023 08:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2CCC433CB;
        Mon,  3 Jul 2023 08:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688371988;
        bh=2Ps2svImxyTTlbbUJYsKyTHx0dGlPzN4zbAKzMTzukM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZiEeeB9irMB2xzbLQRTm7/bvemUv47S5ge9U7wDQ1O7bLF/lE8Xp/qSaA1OciY0Aq
         fZM7epsw2E1NFi5+U+9/xwcBbmQC6YceS3p986xxt5M7KtF8epX+YD+NQ9W8OHYpfK
         rNJVzSCfQdk7EDxcU8I3e8fgjPEp7kKW1u0NVGlNTS60vxI8Ipz61nHV9bYfy5d8oO
         FNiysOsjBd5/CjMvDHIdE2YadqGvkqdj65j9OpMaixpZpHDFE/+ToPortvG3QSF+wp
         X0MtTPHHeSP6IX+wJK6tl7EJy8NIKXiyDvldofP2/g/PTlxNXZgrf9Brue2HPFM2mz
         qt40BCqPzDtGw==
Date:   Mon, 3 Jul 2023 10:13:04 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        jlayton@kernel.org, hughd@google.com, hch@lst.de,
        chuck.lever@oracle.com
Subject: Re: + libfs-add-directory-operations-for-stable-offsets.patch added
 to mm-unstable branch
Message-ID: <20230703-wohnraum-teilen-36a0c4e96cd2@brauner>
References: <20230702184211.0A63DC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230702184211.0A63DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, Jul 02, 2023 at 11:42:10AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: libfs: add directory operations for stable offsets
> has been added to the -mm mm-unstable branch.  Its filename is
>      libfs-add-directory-operations-for-stable-offsets.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/libfs-add-directory-operations-for-stable-offsets.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Chuck Lever <chuck.lever@oracle.com>
> Subject: libfs: add directory operations for stable offsets
> Date: Fri, 30 Jun 2023 13:48:49 -0400
> 
> Patch series "shmemfs stable directory offsets", v7.
> 
> The following series implements stable directory offsets for shmemfs/tmpfs
> and provides infrastructure for use by other file systems that are based
> on simplefs.
> 
> 
> This patch (of 3):
> 
> Create a vector of directory operations in fs/libfs.c that handles
> directory seeks and readdir via stable offsets instead of the current
> cursor-based mechanism.
> 
> For the moment these are unused.
> 
> Link: https://lkml.kernel.org/r/168814723481.530310.17776748558242063239.stgit@manet.1015granger.net
> Link: https://lkml.kernel.org/r/168814732984.530310.11190772066786107220.stgit@manet.1015granger.net
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/filesystems/locking.rst |    2 
>  Documentation/filesystems/vfs.rst     |    6 
>  fs/libfs.c                            |  247 ++++++++++++++++++++++++

Andrew, I'd like to take these patches through the VFS tree.
So I'd appreciate if you could please drop them.

Thanks!
