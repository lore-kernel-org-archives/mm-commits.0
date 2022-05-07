Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FAEC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 20:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446967AbiEGUUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 16:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiEGUUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 16:20:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC361EC70
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 13:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57973B807EE
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 20:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33B9C385A5;
        Sat,  7 May 2022 20:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651954620;
        bh=wUjthspTacniY9RvlQY2sy957hv1yl0tO4JmBPh9pq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l7Dw4Vi2/K7oMY1no3//8u0kfIasbZutyRCZNfThNNtLx3Etwlx0H9UILTFOFP2Bh
         2yYmbLs6UlE6SJz3IHEK5FoT5OwwuEu2PVqLl2Ksg11u1QKr+K1+L4fZfqO3LQfTTs
         5QLKKzwPQWvmt5KLV2/x/H8gw9o7FlpBnWNkKzQk=
Date:   Sat, 7 May 2022 13:16:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     mm-commits@vger.kernel.org, Martin Wilck <mwilck@suse.com>
Subject: Re: + initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
 added to -mm tree
Message-Id: <20220507131659.e061e7f96c901f45c19e2220@linux-foundation.org>
In-Reply-To: <20220504164645.15fd6577@suse.de>
References: <20220426204411.83DF7C385A0@smtp.kernel.org>
        <20220504164645.15fd6577@suse.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 4 May 2022 16:46:45 +0200 David Disseldorp <ddiss@suse.de> wrote:

> > Benchmarks with a one million directory cpio archive extracted 20 times
> > demonstrated: mean extraction time (s) std dev INITRAMFS_PRESERVE_MTIME=y
> > 3.808 0.006 INITRAMFS_PRESERVE_MTIME unset 3.056 0.004
> 
> The benchmark table above has been collapsed, making it mostly
> incomprehensible.

Fat fingers, thanks, fixed.

> > The above extraction times were measured using ftrace (initcall_finish -
> > initcall_start) values for populate_rootfs() with initramfs_async
> > disabled.
> > 
> > [ddiss@suse.de: rebase atop dir_entry.name flexible array member and drop  separate initramfs_mtime.h header]
> > Link: https://lkml.org/lkml/2008/9/3/424
> > Link: https://lkml.kernel.org/r/20220404093429.27570-4-ddiss@suse.de
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> The reordering of the tags above is also somewhat confusing - I added
> the [ddiss@suse.de: rebase atop ...] to reflect minor changes that I
> made to the patch *after* Martin had provided his Reviewed-by tag.

Alas, I don't think anyone would interpret it that way.

I do think it would make sense to order these things chronologically,
to provide an account of who-did-what-and-when.  But I'm not aware of
that presently being a convention with subsystem teams.  Maybe I'm
wrong about that.


