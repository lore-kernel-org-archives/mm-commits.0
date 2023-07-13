Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A3DC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 20:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjGMUh4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 16:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjGMUhz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 16:37:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498B01FD6
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 13:37:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CB6E11F37E;
        Thu, 13 Jul 2023 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1689280672;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=354M6eTZExNhaOsB+hULau5obQDvdIO3uQBni2rPmR8=;
        b=1mH4h2fjH0waliPT0FspxhOFgSYrYMVRohdWsPpXBd8TxW0M3ODQVMndO7c5pB0d3l0Ie7
        vqiVgFRPqeFCesYrsYkw9srprkoh0lGln3lhe11IMBTnNCHKrqUK9gbNU4ex5cVtypoxWg
        qpw+/ijC4sgpwKyeVD8lD/OQXzyVCSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1689280672;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=354M6eTZExNhaOsB+hULau5obQDvdIO3uQBni2rPmR8=;
        b=y2pTD2KbVOI3AartWs0baw1eDPtUpRxDKNzXLYZ3is3TW5ZZJuZlYIuPiCLuri2dqrBxbd
        CwiH0z+UcLf/UrDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C78213489;
        Thu, 13 Jul 2023 20:37:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8GqXHaBgsGRfMQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 13 Jul 2023 20:37:52 +0000
Date:   Thu, 13 Jul 2023 22:31:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org
Subject: Re: + affs-convert-data-read-and-write-to-use-folios.patch added to
 mm-unstable branch
Message-ID: <20230713203115.GB20457@suse.cz>
References: <20230713172648.D45B3C433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713172648.D45B3C433C8@smtp.kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 13, 2023 at 10:26:48AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: affs: convert data read and write to use folios
> has been added to the -mm mm-unstable branch.  Its filename is
>      affs-convert-data-read-and-write-to-use-folios.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/affs-convert-data-read-and-write-to-use-folios.patch
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
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Subject: affs: convert data read and write to use folios
> Date: Thu, 13 Jul 2023 04:55:08 +0100
> 
> We still need to convert to/from folios in write_begin & write_end to fit
> the API, but this removes a lot of calls to old page-based functions,
> removing many hidden calls to compound_head().
> 
> Link: https://lkml.kernel.org/r/20230713035512.4139457-4-willy@infradead.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.com>
> Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Tom Rix <trix@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Sterba <dsterba@suse.com>
