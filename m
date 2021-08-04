Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D869DC4338F
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 01:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5EF60F70
	for <mm-commits@archiver.kernel.org>; Wed,  4 Aug 2021 01:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhHDB3Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 21:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232195AbhHDB3Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 21:29:25 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1688160F58;
        Wed,  4 Aug 2021 01:29:13 +0000 (UTC)
Date:   Tue, 3 Aug 2021 21:29:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        masahiroy@kernel.org, nathan@kernel.org
Subject: Re: +
 scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch added
 to -mm tree
Message-ID: <20210803212911.48f3924a@rorschach.local.home>
In-Reply-To: <20210802213040.ED4ON%akpm@linux-foundation.org>
References: <20210802213040.ED4ON%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 02 Aug 2021 14:30:40 -0700
akpm@linux-foundation.org wrote:

> The patch titled
>      Subject: scripts/recordmcount.pl: remove check_objcopy() and $can_use_local
> has been added to the -mm tree.  Its filename is
>      scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch

Thanks Andrew,

But I'll pulling it through my tree.

I'll even send it up with my urgent push into the -rc release.

-- Steve

> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Nathan Chancellor <nathan@kernel.org>
> Subject: scripts/recordmcount.pl: remove check_objcopy() and $can_use_local
> 
> When building ARCH=riscv allmodconfig with llvm-objcopy, the objcopy
> version warning from this script appears:
> 
> WARNING: could not find objcopy version or version is less than 2.17.
>         Local function references are disabled.
> 
> The check_objcopy() function in scripts/recordmcount.pl is set up to parse
> GNU objcopy's version string, not llvm-objcopy's, which triggers the
> warning.
> 
> Commit 799c43415442 ("kbuild: thin archives make default for all archs")
> made binutils 2.20 mandatory and commit ba64beb17493 ("kbuild: check the
> minimum assembler version in Kconfig") enforces this at configuration time
> so just remove check_objcopy() and $can_use_local instead, assuming
> --globalize-symbol is always available.
> 
> llvm-objcopy has supported --globalize-symbol since LLVM 7.0.0 in 2018 and
> the minimum version for building the kernel with LLVM is 10.0.1 so there
> is no issue introduced:
> 
> Link: https://github.com/llvm/llvm-project/commit/ee5be798dae30d5f9414b01f76ff807edbc881aa
> Link: https://lkml.kernel.org/r/20210802210307.3202472-1-nathan@kernel.org
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Makefile                |    1 
>  scripts/recordmcount.pl |   40 --------------------------------------
>  2 files changed, 41 deletions(-)
> 
> --- a/Makefile~scripts-recordmcountpl-remove-check_objcopy-and-can_use_local
> +++ a/Makefile
> @@ -546,7 +546,6 @@ export RCS_TAR_IGNORE := --exclude SCCS
>  PHONY += scripts_basic
>  scripts_basic:
>  	$(Q)$(MAKE) $(build)=scripts/basic
> -	$(Q)rm -f .tmp_quiet_recordmcount
>  
>  PHONY += outputmakefile
>  ifdef building_out_of_srctree
> --- a/scripts/recordmcount.pl~scripts-recordmcountpl-remove-check_objcopy-and-can_use_local
> +++ a/scripts/recordmcount.pl
> @@ -173,39 +173,6 @@ my $mcount_regex;	# Find the call site t
>  my $mcount_adjust;	# Address adjustment to mcount offset
>  my $alignment;		# The .align value to use for $mcount_section
>  my $section_type;	# Section header plus possible alignment command
> -my $can_use_local = 0; 	# If we can use local function references
> -
> -# Shut up recordmcount if user has older objcopy
> -my $quiet_recordmcount = ".tmp_quiet_recordmcount";
> -my $print_warning = 1;
> -$print_warning = 0 if ( -f $quiet_recordmcount);
> -
> -##
> -# check_objcopy - whether objcopy supports --globalize-symbols
> -#
> -#  --globalize-symbols came out in 2.17, we must test the version
> -#  of objcopy, and if it is less than 2.17, then we can not
> -#  record local functions.
> -sub check_objcopy
> -{
> -    open (IN, "$objcopy --version |") or die "error running $objcopy";
> -    while (<IN>) {
> -	if (/objcopy.*\s(\d+)\.(\d+)/) {
> -	    $can_use_local = 1 if ($1 > 2 || ($1 == 2 && $2 >= 17));
> -	    last;
> -	}
> -    }
> -    close (IN);
> -
> -    if (!$can_use_local && $print_warning) {
> -	print STDERR "WARNING: could not find objcopy version or version " .
> -	    "is less than 2.17.\n" .
> -	    "\tLocal function references are disabled.\n";
> -	open (QUIET, ">$quiet_recordmcount");
> -	printf QUIET "Disables the warning from recordmcount.pl\n";
> -	close QUIET;
> -    }
> -}
>  
>  if ($arch =~ /(x86(_64)?)|(i386)/) {
>      if ($bits == 64) {
> @@ -434,8 +401,6 @@ if ($filename =~ m,^(.*)(\.\S),) {
>  my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
>  my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
>  
> -check_objcopy();
> -
>  #
>  # Step 1: find all the local (static functions) and weak symbols.
>  #         't' is local, 'w/W' is weak
> @@ -473,11 +438,6 @@ sub update_funcs
>  
>      # is this function static? If so, note this fact.
>      if (defined $locals{$ref_func}) {
> -
> -	# only use locals if objcopy supports globalize-symbols
> -	if (!$can_use_local) {
> -	    return;
> -	}
>  	$convert{$ref_func} = 1;
>      }
>  
> _
> 
> Patches currently in -mm which might be from nathan@kernel.org are
> 
> scripts-recordmcountpl-remove-check_objcopy-and-can_use_local.patch

