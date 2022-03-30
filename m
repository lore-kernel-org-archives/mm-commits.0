Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89071C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 30 Mar 2022 20:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbiC3U7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 16:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351176AbiC3U7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 16:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96C7F42A2F
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 13:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648673840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MeKkthCeJH55gUCoXkC5opPjQPW4ec2xHA9SFzG0sjg=;
        b=DOh6WOcXBV2r3+l+jpnYo/cWaVBLXT42ooweCF7JjhnciR9uZTisvZlD4A9uEnR6Au13sd
        pbC+gX+O8ReMwrSip9tz7cAVk6Nd9Q4czUk5izggV2VIR/AyZQFXQVCG5c2QJU6eFSIVi1
        iobled2K5d0DD4ny3KyuseXCjdKfAVI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-rRhSNS5kPnaJhPicSdvszQ-1; Wed, 30 Mar 2022 16:57:17 -0400
X-MC-Unique: rRhSNS5kPnaJhPicSdvszQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E5A5899EC1;
        Wed, 30 Mar 2022 20:57:16 +0000 (UTC)
Received: from [10.18.17.215] (dhcp-17-215.bos.redhat.com [10.18.17.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3BB9C202C8;
        Wed, 30 Mar 2022 20:57:15 +0000 (UTC)
Message-ID: <64eb7879-b2be-0c9b-bd60-8c7b8de89987@redhat.com>
Date:   Wed, 30 Mar 2022 16:57:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [failures]
 mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch removed
 from -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mingo@kernel.org,
        marcan@marcan.st, kirill.shutemov@linux.intel.com,
        jforbes@redhat.com, aquini@redhat.com
References: <20220222041217.3C24BC340EB@smtp.kernel.org>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220222041217.3C24BC340EB@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2/21/22 23:12, Andrew Morton wrote:
> The patch titled
>       Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
> has been removed from the -mm tree.  Its filename was
>       mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
>
> This patch was dropped because it had testing failures
>
> ------------------------------------------------------
> From: Waiman Long <longman@redhat.com>
> Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
>
> The gcc 12 compiler reports a "'mem_section' will never be NULL" warning
> on the following code:
>
>      static inline struct mem_section *__nr_to_section(unsigned long nr)
>      {
>      #ifdef CONFIG_SPARSEMEM_EXTREME
>          if (!mem_section)
>                  return NULL;
>      #endif
>          if (!mem_section[SECTION_NR_TO_ROOT(nr)])
>                  return NULL;
>         :
>
> It happens with both CONFIG_SPARSEMEM_EXTREME on and off.  The mem_section
> definition is
>
>      #ifdef CONFIG_SPARSEMEM_EXTREME
>      extern struct mem_section **mem_section;
>      #else
>      extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
>      #endif
>
> In the CONFIG_SPARSEMEM_EXTREME case, mem_section obviously cannot be
> NULL, but *mem_section can be if memory hasn't been allocated for the
> dynamic mem_section[] array yet.  In the !CONFIG_SPARSEMEM_EXTREME case,
> mem_section is a static 2-dimensional array and so the check
> "!mem_section[SECTION_NR_TO_ROOT(nr)]" doesn't make sense.
>
> Fix this warning by checking for "!*mem_section" instead of "!mem_section"
> and moving the "!mem_section[SECTION_NR_TO_ROOT(nr)]" check up inside the
> CONFIG_SPARSEMEM_EXTREME block.
>
> [longman@redhat.com: v2]
>    Link: https://lkml.kernel.org/r/20220202003550.698768-1-longman@redhat.com
> Link: https://lkml.kernel.org/r/20220201192924.672675-1-longman@redhat.com
> Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
> Fixes: 3e347261a80b ("sparsemem extreme implementation")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Reported-by: Justin Forbes <jforbes@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Justin Forbes <jforbes@redhat.com>
> Cc: Rafael Aquini <aquini@redhat.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Hector Martin <marcan@marcan.st>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/mmzone.h |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> --- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning
> +++ a/include/linux/mmzone.h
> @@ -1390,11 +1390,9 @@ static inline unsigned long *section_to_
>   static inline struct mem_section *__nr_to_section(unsigned long nr)
>   {
>   #ifdef CONFIG_SPARSEMEM_EXTREME
> -	if (!mem_section)
> +	if (!*mem_section || !mem_section[SECTION_NR_TO_ROOT(nr)])
>   		return NULL;
>   #endif
> -	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
> -		return NULL;
>   	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
>   }
>   extern size_t mem_section_usage_size(void);

I am sorry that I had a brain fart on my part to add the "*" to 
mem_section. I will post an updated patch to fix that.

Cheers,
Longman

