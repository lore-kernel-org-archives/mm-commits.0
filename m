Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C335C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6642226A
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbhADVtz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:49:55 -0500
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:52918 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbhADVtz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2021 16:49:55 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 042F2181D3026;
        Mon,  4 Jan 2021 21:49:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cast93_3d134b9274d3
X-Filterd-Recvd-Size: 5154
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Mon,  4 Jan 2021 21:49:13 +0000 (UTC)
Message-ID: <a1f2f49b9ea565893fb5c86989c14d7e653abd76.camel@perches.com>
Subject: Re: + checkpatch-kconfig-enforce-help-text-indentation.patch added
 to -mm tree
From:   Joe Perches <joe@perches.com>
To:     akpm@linux-foundation.org, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Date:   Mon, 04 Jan 2021 13:49:11 -0800
In-Reply-To: <20210104211237.3Iy7io4dd%akpm@linux-foundation.org>
References: <20210104211237.3Iy7io4dd%akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 2021-01-04 at 13:12 -0800, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: checkpatch: kconfig: enforce help text indentation
> has been added to the -mm tree.  Its filename is
>      checkpatch-kconfig-enforce-help-text-indentation.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-kconfig-enforce-help-text-indentation.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-kconfig-enforce-help-text-indentation.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days

Andrew:

I think you should wait to apply these until
I ack/nak them.

Nak.

This still doesn't work to validate 2 space only indentation.


> 
> ------------------------------------------------------
> From: Nicolai Fischer <nicolai.fischer@fau.de>
> Subject: checkpatch: kconfig: enforce help text indentation
> 
> Adds a new warning in case the indentation level of the
> first line of a Kconfig help message is not at least two spaces
> higher than the keyword itself.

Not at least.  This should test for exactly 2.

> Blank lines between the message and the help keyword
> are ignored.

And if it's non-blank and < the help indent, the help block
content test should be terminated.

> 
> Link: https://lkml.kernel.org/r/20210103075015.23946-4-nicolai.fischer@fau.de
> Co-developed-by: Johannes Czekay <johannes.czekay@fau.de>
> Signed-off-by: Johannes Czekay <johannes.czekay@fau.de>
> Signed-off-by: Nicolai Fischer <nicolai.fischer@fau.de>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  scripts/checkpatch.pl |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> --- a/scripts/checkpatch.pl~checkpatch-kconfig-enforce-help-text-indentation
> +++ a/scripts/checkpatch.pl
> @@ -3313,6 +3313,8 @@ sub process {
>  			my $f;
>  			my $is_start = 0;
>  			my $is_end = 0;
> +			my $help_indent;
> +			my $help_stat_real;
>  			for (; $cnt > 0 && defined $lines[$ln - 1]; $ln++) {
>  				$f = $lines[$ln - 1];
>  				$cnt-- if ($lines[$ln - 1] !~ /^-/);
> @@ -3323,8 +3325,10 @@ sub process {
>  
> 
>  				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|int|hex|string|prompt)\s*(?:["'].*)?$/) {
>  					$is_start = 1;
> -				} elsif ($lines[$ln - 1] =~ /^\+\s*help$/) {
> -					$length = -1;
> +				} elsif ($lines[$ln - 1] =~ /^\+(\s*)help$/) {
> +					$help_indent = $1;
> +					$length = 0;
> +					next;
>  				}
>  
> 
>  				$f =~ s/^.//;
> @@ -3332,6 +3336,13 @@ sub process {
>  				$f =~ s/^\s+//;
>  				next if ($f =~ /^$/);
>  
> 
> +				if (defined $help_indent) {
> +					if ($lines[$ln - 1] !~ /^\+$help_indent\ {2,}\S*/) {
> +						$help_stat_real = get_stat_real($ln - 1, $ln);
> +					}
> +					undef $help_indent;
> +				}
> +
>  				# This only checks context lines in the patch
>  				# and so hopefully shouldn't trigger false
>  				# positives, even though some of these are
> @@ -3347,6 +3358,10 @@ sub process {
>  				WARN("CONFIG_DESCRIPTION",
>  				     "please write a paragraph that describes the config symbol fully\n" . $herecurr);
>  			}
> +			if ($is_start && $is_end && defined $help_stat_real) {
> +				WARN("CONFIG_DESCRIPTION",
> +				     "please indent the help text two spaces more than the keyword\n" . "$here\n$help_stat_real\n");
> +			}
>  			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>  		}
>  
> 
> _
> 
> Patches currently in -mm which might be from nicolai.fischer@fau.de are
> 
> checkpatch-kconfig-replace-help-with-help.patch
> checkpatch-kconfig-add-missing-types-to-regex.patch
> checkpatch-kconfig-enforce-help-text-indentation.patch
> checkpatch-kconfig-clarify-warning-for-paragraph-length.patch
> checkpatch-kconfig-enforce-block-indentation.patch
> 


