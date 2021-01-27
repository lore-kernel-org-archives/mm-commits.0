Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E2FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 08:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CFA20754
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 08:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhA0ItF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 03:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhA0IpN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2021 03:45:13 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8BCC061786
        for <mm-commits@vger.kernel.org>; Wed, 27 Jan 2021 00:44:04 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b21so1416945edy.6
        for <mm-commits@vger.kernel.org>; Wed, 27 Jan 2021 00:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IdCxDBZ3sPhSRhLXyA1keD+lZP64AgdCld/NmXg3+hk=;
        b=IS/HNzCqaTlQKuldfjXFljfGdWDkR3yNq67tdqVlOUT6zPBlq+nMnBxLkrT4kxOCPP
         fYXbrCkUG3NWvUo7u6RVGMYvLa0ITwHkmwi1zyJYUzcIYbC2f25OwTMEEOw/AjGXXt2U
         vBzl9JwOZRCuY8a1P8f3Vv8AQevPvT2QrY/2NpIs7mGLRPoGbatztwBrLkHaHs1vSfv9
         rbAz28Uc5xHj3bDnDGnBLiehj3s6z/xmDhar9kPo65/KDYJwPmCi63+CPHJGi3KiSVhO
         z+/WCWSF1enXBaZVNKk6Hjh2ACWvCdDJms3tyhAJqzsSdOt2roTWJLkP/ZPrOjyZqjSu
         jDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IdCxDBZ3sPhSRhLXyA1keD+lZP64AgdCld/NmXg3+hk=;
        b=X0pKXDObalXsqcJQgDxhO+XRVhiMnIajmHn5AsB6jw7p5WQU6xfjnh0s//chrFyEKF
         C625bvv9J692c0UFaA+6IAf6i1D2FmFs76fPVhBldTvQ4os3gmFdURf/HJbJ/pB1aTek
         w877ONwYXwifgirLAfy47dziGsOV/wSv43mmCSO7jKodgLd7TMj/U+o86VV9zexcUcZ5
         kHJNe4iFo1Ci2YUrujuWbJDtQDuFir8VmuKDLFfT6oAzLO6PthkJmSoPX/9C87m0lDxW
         jPm+kW26/iK4U58/enhM9Lp3znyh0JavQWoII9w3zCCIsWMpIDJCnDYoOvlxzumUKqTe
         WwbA==
X-Gm-Message-State: AOAM533tRftl4SNH1CuG4vp/aF6/GjsSjBtbGO8L4kCHgdYu/Jcn+yQE
        zAvDtz7HhyIub2HaqTuYsss=
X-Google-Smtp-Source: ABdhPJyyg+lUbtIMpPnxAaFxnnKPgPap/Igaxcv4p83jV8GCp+H4agMVbbQvVwsWhRB4M7RPmJJT5w==
X-Received: by 2002:aa7:c34f:: with SMTP id j15mr7857771edr.120.1611737043639;
        Wed, 27 Jan 2021 00:44:03 -0800 (PST)
Received: from localhost.localdomain ([131.228.2.21])
        by smtp.gmail.com with ESMTPSA id r26sm837993edc.95.2021.01.27.00.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 00:44:03 -0800 (PST)
Subject: Re: +
 mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
 added to -mm tree
To:     akpm@linux-foundation.org, aarcange@redhat.com, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, lokeshgidra@google.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
References: <20210119193228.8J478mJSk%akpm@linux-foundation.org>
From:   Li Xinhai <lixinhai.lxh@gmail.com>
Message-ID: <38431252-7540-8303-921c-4386021a6066@gmail.com>
Date:   Wed, 27 Jan 2021 16:43:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119193228.8J478mJSk%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 1/20/21 3:32 AM, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success
> has been added to the -mm tree.  Its filename is
>       mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
> 
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 

Andrew,
These two patches require updates. I've sent out v2, please consider the new patches. Thanks.

mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch

> ------------------------------------------------------
> From: Li Xinhai <lixinhai.lxh@gmail.com>
> Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success
> 
> mremap with MREMAP_DONTUNMAP will move all page table entries to new vma,
> which means all pages allocated for the old vma are not relevant to it
> anymore, and the relevant anon_vma links needs to be unlinked, in nature
> the old vma is much like been freshly created and have no pages been fault
> in.
> 
> But we should not do unlink, if the new vma has effectively merged with
> the old one.
> 
> Link: https://lkml.kernel.org/r/20210119075126.3513154-2-lixinhai.lxh@gmail.com
> Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
> Cc: Brian Geffon <bgeffon@google.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/mremap.c |    7 +++++++
>   1 file changed, 7 insertions(+)
> 
> --- a/mm/mremap.c~mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success
> +++ a/mm/mremap.c
> @@ -595,6 +595,13 @@ static unsigned long move_vma(struct vm_
>   		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
>   		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
>   
> +		/*
> +		 * anon_vma links of the old vma is no longer needed after its page
> +		 * table has been moved.
> +		 */
> +		if (new_vma != vma)
> +			unlink_anon_vmas(vma);
> +
>   		/* Because we won't unmap we don't need to touch locked_vm */
>   		return new_addr;
>   	}
> _
> 
> Patches currently in -mm which might be from lixinhai.lxh@gmail.com are
> 
> mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
> mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
> mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch
> 
