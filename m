Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30440C001DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 18:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjGXS7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjGXS7j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 14:59:39 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E58188
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 11:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1690225164; x=1690829964; i=deller@gmx.de;
 bh=B2w3lyO10q01D5nRx0dFwQZzxdC0BVVGvGOJX9jXntc=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=G2nZZ+HTvDk/fbZxNu5HQdrIg1DMwIQqBKMTA1IzUu20Ng67MeUaAOZmwRCxYTd9u00hai2
 akNmIfyZJiNbTdMitUpslkCP1h2TBRzZ4stelyrCugsY7G1RsU+dIwnOWm5vJSD+rqu63bF0w
 fA/YQtB1DoL+kWG5bSScX+DY604p9z1pfVlPY1VB5K/iuQdAu5ibxr7WyrHaeEyCKhnltWUrb
 Iocd52xKgqEwgQOz0eI8x7vW1J0fwbQmccw1LXp9yTMRSg4iC+1fYbfviu6HOTNRoAgdlgo8o
 WtBCcnNlN91oqUg5VAwS8eg/FVmGKOYUaF4A+26ypgKgCV1T0M2g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.154.236]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEm6F-1q8Nb52RFz-00GEEX; Mon, 24
 Jul 2023 20:59:24 +0200
Message-ID: <929b5dff-7df5-7d6a-4ed0-40f67073221c@gmx.de>
Date:   Mon, 24 Jul 2023 20:59:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: + ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch
 added to mm-nonmm-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        jirislaby@kernel.org, axboe@kernel.dk
References: <20230724172441.A6EEBC433C8@smtp.kernel.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20230724172441.A6EEBC433C8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:aW+4LCnSPoGb1UGAYk4uI9l990kwn60rhun3akivfJ6AQ63py3x
 Yr7Vzb5BXRDCq23ZQ1adDN0Fw/4eJNzHRf6w0pXOV0AyQ5VS9YIX5CAqV0qnK5pasTWyb14
 0Xliu7ppauZ6pHgV8haGAZ3HV9wSYTovm306GTwMsxU+80uSW72HvSpckCUYixOZl9phQew
 cquzjTUsG1jLqwfCcyETg==
UI-OutboundReport: notjunk:1;M01:P0:Ue6YMn07+P4=;TENse1NMNeiahqPttcuPQGHgT8S
 4t7ZwBwP/9oZ2dAAPyM9/1U9FMWzRly5hFeH/67peFtotY2q4lo7OWb+bhx17LKBHKm7YMsJv
 5d72+oYzbAkDvQmMR5WjP67WC2wEcjY10My/1QQDdl3vN5xkGgPkjPq6ZrDhejymEjj31Ko18
 SiJ1cF1cgHIKj7xFi6zR4m80Wk0chudApuMXNWUxiUx8HGbkU/naBbZCqKFe4rPE/wZ50xFCA
 qr3eaIgoURSge1OYB7acBXfaE7eHgVGJndXOZcQ5z05Oab3PaxN830vI1VEUBXuvwzo4ICrsw
 NTT8rzRT45/e2kCj4UzZzIy/s5MvLB1Si1w9rTYidT/C2NSubLilR9J8XrS76nyZtKtOt8xla
 OcltFTihvYVA0GmBymLgTp57kSdryNGqqOK2HJvEET9of37vh4RP0kI5P3vwNXFwf/wMcU/Q8
 0x1dliAI+OHV2tzDLpDhGBL/sfH/WIre1YXXgC13Sp7/EmfReXL4R/eBj0gePMZBgYO5ekLV/
 nFy2Zp1EWUkLM2g6zSWtcfiNYH8/ykvexpCOhYG/3rmZmo/fD8F6EQwVaFNxpq69bb9797pbW
 6vZXmPOs1nvZrmsXWfIAgWNXPqd19FUKRl9WI21KGmL+MRIlutpBzMezx1Wh+NL1kUB3+oQXh
 Kb8T5jPok/4gFThW+qL9aLR4/nORP1WKAOT0NO4gnbAvsDu+fa1Nys8BSnDifglMRD2PIedsE
 irCMmY5PaYHKqIXCgSl9ghQv7qABjXkMw7U1WSf7TNyeOu9i8R/QDmJi3Lvw7deA/FCqHaly+
 XnPIiUOXnAJW09uoDZnuD3l12Eruk71qhTlvqH6Nqe3Zvzz9vK74WLa0c6S28HJXDPxfVSA/3
 aKpe6dpTsXWYWEFekUwIAhh5SB1/lcFyX/A2blFXyHofYQeWVzRiYK12XKpNXotbcLCX1TQtk
 RaoRD4EFM4jGYeJjPXXHevgwzaM=
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

thanks for taking care!
But this patch is already upstreamed via Jens' io_uring tree, so
you can drop it from your patch series.

Thanks!
Helge


On 7/24/23 19:24, Andrew Morton wrote:
> The patch titled
>       Subject: ia64: mmap: consider pgoff when searching for free mappin=
g
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch
>
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tr=
ee/patches/ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch
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
> *** Remember to use Documentation/process/submit-checklist.rst when test=
ing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Helge Deller <deller@gmx.de>
> Subject: ia64: mmap: consider pgoff when searching for free mapping
> Date: Fri, 21 Jul 2023 17:24:32 +0200
>
> IA64 is the only architecture which does not consider the pgoff value wh=
en
> searching for a possible free memory region with vm_unmapped_area().
> Adding this seems to have no negative side effect on IA64, so add it now
> to make IA64 consistent with all other architectures.
>
> Link: https://lkml.kernel.org/r/20230721152432.196382-3-deller@gmx.de
> Signed-off-by: Helge Deller <deller@gmx.de>
> Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jiri Slaby <jirislaby@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   arch/ia64/kernel/sys_ia64.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/ia64/kernel/sys_ia64.c~ia64-mmap-consider-pgoff-when-searchin=
g-for-free-mapping
> +++ a/arch/ia64/kernel/sys_ia64.c
> @@ -63,7 +63,7 @@ arch_get_unmapped_area (struct file *fil
>   	info.low_limit =3D addr;
>   	info.high_limit =3D TASK_SIZE;
>   	info.align_mask =3D align_mask;
> -	info.align_offset =3D 0;
> +	info.align_offset =3D pgoff << PAGE_SHIFT;
>   	return vm_unmapped_area(&info);
>   }
>
> _
>
> Patches currently in -mm which might be from deller@gmx.de are
>
> ia64-mmap-consider-pgoff-when-searching-for-free-mapping.patch
>

