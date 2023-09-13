Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FD4EE0210
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 22:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjIMWMB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 18:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjIMWMB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 18:12:01 -0400
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F4F198B
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 15:11:57 -0700 (PDT)
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
        by cmsmtp with ESMTP
        id gXhyqZrg4QFHRgY5Uqb7AG; Wed, 13 Sep 2023 22:11:56 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTPS
        id gY5TqWagU4a4ygY5Uq3x6A; Wed, 13 Sep 2023 22:11:56 +0000
X-Authority-Analysis: v=2.4 cv=MrpBVkWe c=1 sm=1 tr=0 ts=650233ac
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=WzbPXH4gqzPVN0x6HrNMNA==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=wYkD_t78qR0A:10 a=VwQbUJbxAAAA:8
 a=IJv9LcIfAAAA:8 a=NEAV23lmAAAA:8 a=DfNHnWVPAAAA:8 a=pGLkceISAAAA:8
 a=Z4Rwk6OoAAAA:8 a=aYEq8dtRTDKSVL_BDHkA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=cmr4hm9N53k6aw-X_--Q:22 a=rjTVMONInIDnV1a_A2c_:22
 a=HkZW87K1Qel5hWWM3VKY:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6Cayoj4FgOxm8D/k8xhFH8WKPGREi+m5ppSao4g3j18=; b=jXmd7aNNhCjBcs8X1zpQle5ziZ
        7S7TQPA2isjRqitM/YcP1M/XgEh5enKQN1aLWW761KankiQbeMcRrJbitlJDk4NwoqKIYSjNjh1Vr
        kE+6YVO7bbgNSyjCA1yXlgzfzHJsSEgc+uWFo/qQUwe+WqROt4/ZKsoWKB2NuQl+96NQMbhNk0pcA
        LuhXKZUNA+jv8ZnclWtex1ZWhwOcTw/5+DOpms1qJLgy+DkDDojpmUaQyX40ipSz+/Xbu0gSrZtZB
        e1R+AZ4GjDFPrBrBi/B7Fyfr+PonqltxnqZnT5HWUviEra0aqrSwsWYIVbT+Hdn572xGHTJvJ7XVc
        I5a5mpsg==;
Received: from 187-162-21-192.static.axtel.net ([187.162.21.192]:59998 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.96)
        (envelope-from <gustavo@embeddedor.com>)
        id 1qgY5T-001k7I-14;
        Wed, 13 Sep 2023 17:11:55 -0500
Message-ID: <b3065a3d-bfd5-2391-50aa-76279c3af52e@embeddedor.com>
Date:   Wed, 13 Sep 2023 16:12:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: +
 checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch
 added to mm-nonmm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        gustavoars@kernel.org, dwaipayanray1@gmail.com, apw@canonical.com,
        joe@perches.com
References: <20230913212211.D51E1C433C9@smtp.kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20230913212211.D51E1C433C9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.21.192
X-Source-L: No
X-Exim-ID: 1qgY5T-001k7I-14
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-21-192.static.axtel.net ([192.168.15.8]) [187.162.21.192]:59998
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLRoFqP1IxfVxgEFet57q69pIhGXF13DLT0qQOgtH4zjEd1PYStcXVC04bEwRpL0fe7Derod7CmjkyGjYFHt7vRoIyt9quzV+YBRD4kpO/W8T3GLGVrh
 1nwJEFYFaikYRAz0CyOMm4LwfBr2IKT7Tl0Uuu054wmuoEUixv+HPEhMnlxKvsqwxVELZPfQYdrYsGs7eRLs6C1bAmhu5Og6tql2l7knnyi+E5Fu05l1XE1U
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 9/13/23 15:22, Andrew Morton wrote:
> The patch titled
>       Subject: checkpatch: add a couple new alloc functions to alloc with multiplies check
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Joe Perches <joe@perches.com>
> Subject: checkpatch: add a couple new alloc functions to alloc with multiplies check
> Date: Wed, 13 Sep 2023 13:37:52 -0700
> 
> vmalloc() and vzalloc() functions have now 2-factor multiplication
> argument forms vmalloc_array() and vcalloc(), correspondingly.
> 
> Add alloc-with-multiplies checks for these new functions.
> 
> Simplify the original codes repeated else to use a hash.
> 
> Link: https://github.com/KSPP/linux/issues/342
> 
> Link: https://lore.kernel.org/lkml/ZQCaO+tYycDxVLy7@work/
> Link: https://lkml.kernel.org/r/edb667e19211652a32ef6069159bb85dbc3bcdfc.1694636817.git.joe@perches.com
> Original-patch-by: Gustavo A. R. Silva <gustavoars@kernel.org>

This patch should include the following tags:

Co-developed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   scripts/checkpatch.pl |   21 ++++++++++++++-------
>   1 file changed, 14 insertions(+), 7 deletions(-)
> 
> --- a/scripts/checkpatch.pl~checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check
> +++ a/scripts/checkpatch.pl
> @@ -834,6 +834,16 @@ our %deprecated_apis = (
>   #Create a search pattern for all these strings to speed up a loop below
>   our $deprecated_apis_search = '(?:' . join('|', keys %deprecated_apis) . ')';
>   
> +our %alloc_with_multiply_apis = (
> +	"kmalloc"		=> "kmalloc_array",
> +	"kvmalloc"		=> "kvmalloc_array",
> +	"vmalloc"		=> "vmalloc_array",
> +	"kvzalloc"		=> "kvcalloc",
> +	"kzalloc"		=> "kcalloc",
> +	"vzalloc"		=> "vcalloc",
> +);
> +our $alloc_with_multiply_search = '(?:' . join('|', keys %alloc_with_multiply_apis) . ')';
> +
>   our $mode_perms_world_writable = qr{
>   	S_IWUGO		|
>   	S_IWOTH		|
> @@ -7187,17 +7197,14 @@ sub process {
>   			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
>   		}
>   
> -# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_array/kvmalloc_array/kvcalloc/kcalloc
> +# check for various allocs with multiplies that should use safer functions
>   		if ($perl_version_ok &&
>   		    defined $stat &&
> -		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
> +		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*($alloc_with_multiply_search)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
>   			my $oldfunc = $3;
> +			my $newfunc = $alloc_with_multiply_apis{$oldfunc};
>   			my $a1 = $4;
>   			my $a2 = $10;
> -			my $newfunc = "kmalloc_array";
> -			$newfunc = "kvmalloc_array" if ($oldfunc eq "kvmalloc");
> -			$newfunc = "kvcalloc" if ($oldfunc eq "kvzalloc");
> -			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
>   			my $r1 = $a1;
>   			my $r2 = $a2;
>   			if ($a1 =~ /^sizeof\s*\S/) {
> @@ -7213,7 +7220,7 @@ sub process {
>   					 "Prefer $newfunc over $oldfunc with multiply\n" . $herectx) &&
>   				    $cnt == 1 &&
>   				    $fix) {
> -					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
> +					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*($oldfunc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
>   				}
>   			}
>   		}
> _
> 
> Patches currently in -mm which might be from joe@perches.com are
> 
> checkpatch-simplify-creating-search-strings.patch
> checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch
> 
