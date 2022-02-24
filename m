Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D742C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiBXEbP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiBXEbL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:31:11 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C54F71D3ACA
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:30:41 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6178F106F;
        Wed, 23 Feb 2022 20:30:41 -0800 (PST)
Received: from [10.163.48.178] (unknown [10.163.48.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECFAD3F66F;
        Wed, 23 Feb 2022 20:30:38 -0800 (PST)
Subject: Re: + x86-mm-enable-arch_has_vm_get_page_prot-fix.patch added to -mm
 tree
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hch@infradead.org
References: <20220224025851.C4094C340E7@smtp.kernel.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <1137f802-72e4-c635-74d7-c94c2db1144b@arm.com>
Date:   Thu, 24 Feb 2022 10:00:40 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220224025851.C4094C340E7@smtp.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 2/24/22 8:28 AM, Andrew Morton wrote:
> 
> The patch titled
>      Subject: x86-mm-enable-arch_has_vm_get_page_prot-fix
> has been added to the -mm tree.  Its filename is
>      x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-enable-arch_has_vm_get_page_prot-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: x86-mm-enable-arch_has_vm_get_page_prot-fix
> 
> fix build
> 
> arch/x86/mm/mem_encrypt_amd.c: In function 'sme_early_init':
> arch/x86/mm/mem_encrypt_amd.c:182:22: error: unused variable 'i' [-Werror=unused-variable]
>   182 |         unsigned int i;
> 
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/mm/mem_encrypt_amd.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> --- a/arch/x86/mm/mem_encrypt_amd.c~x86-mm-enable-arch_has_vm_get_page_prot-fix
> +++ a/arch/x86/mm/mem_encrypt_amd.c
> @@ -179,8 +179,6 @@ void __init sme_map_bootdata(char *real_
>  
>  void __init sme_early_init(void)
>  {
> -	unsigned int i;
> -
>  	if (!sme_me_mask)
>  		return;
>  

Will fold this up next time.
