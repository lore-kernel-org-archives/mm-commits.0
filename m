Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CF4C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 May 2022 14:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiEDOu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 May 2022 10:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiEDOuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2022 10:50:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2CC13EBE
        for <mm-commits@vger.kernel.org>; Wed,  4 May 2022 07:46:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 970EA210E4;
        Wed,  4 May 2022 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651675606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RK7D4WZN/DMM/8qU9WxLp6CVN1WWgcM9OG5OfoCwKJs=;
        b=VJsjv9Zh0Rhz9M2XD7wlxexVmUT3bfzmZh3LlCNLotQWHxOmnzbT0aQeB4X52RlwJtRiu4
        wSKZpSHTCttZkeAz8mmJHMFo36P3jletGspet72NFbKtcCnUwX528ATtmZ2DVHgWQ7ZDwj
        4Aqs4+IMg5s7faAfS+rwCn2mJ8EoJ+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651675606;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RK7D4WZN/DMM/8qU9WxLp6CVN1WWgcM9OG5OfoCwKJs=;
        b=jVM4x+CNOLrjyiTMEp7ioScQ0sIdIxID6WdSJSq5iUzGzyKZaXiFrEX/m27/frO+aFBGLJ
        /7DH/jYuL7ez9CDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6BF90131BD;
        Wed,  4 May 2022 14:46:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iIQkGdaRcmJiHgAAMHmgww
        (envelope-from <ddiss@suse.de>); Wed, 04 May 2022 14:46:46 +0000
Date:   Wed, 4 May 2022 16:46:45 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Martin Wilck <mwilck@suse.com>
Subject: Re: + initramfs-add-initramfs_preserve_mtime-kconfig-option.patch
 added to -mm tree
Message-ID: <20220504164645.15fd6577@suse.de>
In-Reply-To: <20220426204411.83DF7C385A0@smtp.kernel.org>
References: <20220426204411.83DF7C385A0@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

A couple of minor comments regarding the -mm tree commit message
reformatting...

On Tue, 26 Apr 2022 13:44:10 -0700, Andrew Morton wrote:

...
> Benchmarks with a one million directory cpio archive extracted 20 times
> demonstrated: mean extraction time (s) std dev INITRAMFS_PRESERVE_MTIME=y
> 3.808 0.006 INITRAMFS_PRESERVE_MTIME unset 3.056 0.004

The benchmark table above has been collapsed, making it mostly
incomprehensible.

> The above extraction times were measured using ftrace (initcall_finish -
> initcall_start) values for populate_rootfs() with initramfs_async
> disabled.
> 
> [ddiss@suse.de: rebase atop dir_entry.name flexible array member and drop  separate initramfs_mtime.h header]
> Link: https://lkml.org/lkml/2008/9/3/424
> Link: https://lkml.kernel.org/r/20220404093429.27570-4-ddiss@suse.de
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Martin Wilck <mwilck@suse.com>

The reordering of the tags above is also somewhat confusing - I added
the [ddiss@suse.de: rebase atop ...] to reflect minor changes that I
made to the patch *after* Martin had provided his Reviewed-by tag.

Cheers, David
