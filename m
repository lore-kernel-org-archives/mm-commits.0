Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D931AC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 20:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbjGMUhf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 16:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjGMUhe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 16:37:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844B273E
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 13:37:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B3BB322136;
        Thu, 13 Jul 2023 20:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1689280651;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XK0SkSzLZx25kOzG0v5zDEHcD+WylJFxMjdTTfw+2vE=;
        b=oaUBjq+nZ4NaIpoxMIn8Gzhe9ULHtSptXWS7t58uhpgA8t2Fw04kahqAAS99SRnkpA39yT
        ys80EFvAAlfM+NWwVEr6FdaviYtlB5BVpjTND14iKMewUXYca2kVyFJn3e2RZpFkB+dAkw
        TNSAU6mcMO0q4JGY5oum4b70cdoRyrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1689280651;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XK0SkSzLZx25kOzG0v5zDEHcD+WylJFxMjdTTfw+2vE=;
        b=3AC27fCeqSwGliIaFmTVFhZlaPSpHfjS2aIOIMjyXbw9R+lG2dFydZSXPo4g5TDJis1WmZ
        BdpjFvGUPrqDc4AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62C0713489;
        Thu, 13 Jul 2023 20:37:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y1s3F4tgsGQ+MQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 13 Jul 2023 20:37:31 +0000
Date:   Thu, 13 Jul 2023 22:30:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org
Subject: Re: + affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
 added to mm-unstable branch
Message-ID: <20230713203054.GA20457@suse.cz>
References: <20230713172646.EF6F5C433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713172646.EF6F5C433C7@smtp.kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 13, 2023 at 10:26:46AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: affs: convert affs_symlink_read_folio() to use the folio
> has been added to the -mm mm-unstable branch.  Its filename is
>      affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
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
> Subject: affs: convert affs_symlink_read_folio() to use the folio
> Date: Thu, 13 Jul 2023 04:55:07 +0100
> 
> Remove use of the old page APIs.  That includes use of setting PageError
> on error; simply not setting the uptodate flag is sufficient.
> 
> Link: https://lkml.kernel.org/r/20230713035512.4139457-3-willy@infradead.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.com>
> Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Pankaj Raghav <p.raghav@samsung.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Tom Rix <trix@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Sterba <dsterba@suse.com>

> ---
> 
>  fs/affs/symlink.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> --- a/fs/affs/symlink.c~affs-convert-affs_symlink_read_folio-to-use-the-folio
> +++ a/fs/affs/symlink.c
> @@ -13,10 +13,9 @@
>  
>  static int affs_symlink_read_folio(struct file *file, struct folio *folio)
>  {
> -	struct page *page = &folio->page;
>  	struct buffer_head *bh;
> -	struct inode *inode = page->mapping->host;
> -	char *link = page_address(page);
> +	struct inode *inode = folio->mapping->host;
> +	char *link = folio_address(folio);
>  	struct slink_front *lf;
>  	int			 i, j;
>  	char			 c;
> @@ -58,12 +57,11 @@ static int affs_symlink_read_folio(struc
>  	}
>  	link[i] = '\0';
>  	affs_brelse(bh);
> -	SetPageUptodate(page);
> -	unlock_page(page);
> +	folio_mark_uptodate(folio);
> +	folio_unlock(folio);
>  	return 0;
>  fail:
> -	SetPageError(page);
> -	unlock_page(page);
> +	folio_unlock(folio);
>  	return -EIO;
>  }
>  
> _
> 
> Patches currently in -mm which might be from willy@infradead.org are
> 
> rmap-pass-the-folio-to-__page_check_anon_rmap.patch
> highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
> affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
> affs-convert-data-read-and-write-to-use-folios.patch
> migrate-use-folio_set_bh-instead-of-set_bh_page.patch
> ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
> jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
> buffer-remove-set_bh_page.patch
> 
