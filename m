Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FD2C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 18:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357822AbiELS6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 14:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357798AbiELS6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 14:58:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A040019875A
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 11:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1M9gijGtCLyLz7Y+3LHxg6WVP2t/jcqTgFUCs74E4OM=; b=lHkbC/gPz6ECyUOCtY+MYmWY++
        52OZRggh3o/gSDWYDr1aaSvlmfB6ZZsf8XDzi3W+s+7AfeI3isnKifjyJDNZpiEgYWZwe3oeuSCIt
        Q7SF+glASrctzSCCIjnTcqxr1LDJ5farlM443s2tdOmjyixcUn3/J9W3yURVSv6gE1UJ24Xig4t2v
        I3+5BVBp9Xlps9ZBPN3EkrMUXAcKR9fkqU1OrcrAC+e/vpNBhYpvHA4XDxw5AY7R3Ap9BTU2wEX9+
        jxNcSX/eOqrEuk57LWQAkSCt7D2LTfrslFgTQTd+tgemTA99w+XMY+NivPQUK4hvk32nt1WSmwBQf
        Y6WkqDtg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npE1T-00DAxL-MG; Thu, 12 May 2022 18:58:51 +0000
Date:   Thu, 12 May 2022 11:58:51 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yzaikin@google.com,
        viro@zeniv.linux.org.uk, mingo@elte.hu, keescook@chromium.org,
        jpitti@cisco.com
Subject: Re: [obsolete] proc-sysctl-make-protected_-world-readable.patch
 removed from -mm tree
Message-ID: <Yn1Y60Hbls4tahpX@bombadil.infradead.org>
References: <20220425214652.9F507C385A9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425214652.9F507C385A9@smtp.kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

I've reivewed this now and you can add:

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

On Mon, Apr 25, 2022 at 02:46:51PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: proc/sysctl: make protected_* world readable
> has been removed from the -mm tree.  Its filename was
>      proc-sysctl-make-protected_-world-readable.patch
> 
> This patch was dropped because it is obsolete
> 
> ------------------------------------------------------
> From: Julius Hemanth Pitti <jpitti@cisco.com>
> Subject: proc/sysctl: make protected_* world readable
> 
> protected_* files have 600 permissions which prevents non-superuser from
> reading them.
> 
> Container like "AWS greengrass" refuse to launch unless
> protected_hardlinks and protected_symlinks are set.  When containers like
> these run with "userns-remap" or "--user" mapping container's root to
> non-superuser on host, they fail to run due to denied read access to these
> files.
> 
> As these protections are hardly a secret, and do not possess any security
> risk, making them world readable.
> 
> Though above greengrass usecase needs read access to only
> protected_hardlinks and protected_symlinks files, setting all other
> protected_* files to 644 to keep consistency.
> 
> Link: http://lkml.kernel.org/r/20200709235115.56954-1-jpitti@cisco.com
> Fixes: 800179c9b8a1 ("fs: add link restrictions")
> Signed-off-by: Julius Hemanth Pitti <jpitti@cisco.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: Iurii Zaikin <yzaikin@google.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/namei.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/fs/namei.c~proc-sysctl-make-protected_-world-readable
> +++ a/fs/namei.c
> @@ -1031,7 +1031,7 @@ static struct ctl_table namei_sysctls[]
>  		.procname	= "protected_symlinks",
>  		.data		= &sysctl_protected_symlinks,
>  		.maxlen		= sizeof(int),
> -		.mode		= 0600,
> +		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_ONE,
> @@ -1040,7 +1040,7 @@ static struct ctl_table namei_sysctls[]
>  		.procname	= "protected_hardlinks",
>  		.data		= &sysctl_protected_hardlinks,
>  		.maxlen		= sizeof(int),
> -		.mode		= 0600,
> +		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_ONE,
> @@ -1049,7 +1049,7 @@ static struct ctl_table namei_sysctls[]
>  		.procname	= "protected_fifos",
>  		.data		= &sysctl_protected_fifos,
>  		.maxlen		= sizeof(int),
> -		.mode		= 0600,
> +		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_TWO,
> @@ -1058,7 +1058,7 @@ static struct ctl_table namei_sysctls[]
>  		.procname	= "protected_regular",
>  		.data		= &sysctl_protected_regular,
>  		.maxlen		= sizeof(int),
> -		.mode		= 0600,
> +		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_TWO,
> _
> 
> Patches currently in -mm which might be from jpitti@cisco.com are
> 
> 
