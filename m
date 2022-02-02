Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236EDC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  2 Feb 2022 00:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbiBBAec (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 19:34:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243361AbiBBAec (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 19:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643762071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wso2XPnLiVfCRE34RBtaQeUShVKzCDoiefTQDGZxCLE=;
        b=Va9EtiNV8UbsGMuZg3RsPUZadd0vR6s3V6zQtLHMOg4PoGU9nvgxp2nOZM2WTTEBtst9sK
        UT2PCXtgqoXlEePC9bBIR853Hn8Xd++iS29ky2Gnitymu4UpBlQgPRShbembbf8fmyamyi
        /XlHkbUAOyRHGJk8PDL4rLdVPE2/Ih4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-uivTLxV_PJONsU2mTVPtWQ-1; Tue, 01 Feb 2022 19:34:28 -0500
X-MC-Unique: uivTLxV_PJONsU2mTVPtWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E0FD801B04;
        Wed,  2 Feb 2022 00:34:27 +0000 (UTC)
Received: from [10.22.19.61] (unknown [10.22.19.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2347C163E2;
        Wed,  2 Feb 2022 00:34:19 +0000 (UTC)
Message-ID: <c0bc4645-2ed2-e93f-c5af-09f4f77c25cc@redhat.com>
Date:   Tue, 1 Feb 2022 19:34:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: +
 mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch added to
 -mm tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, mingo@kernel.org,
        kirill.shutemov@linux.intel.com, jforbes@redhat.com,
        aquini@redhat.com
References: <20220201193450.63804C340EC@smtp.kernel.org>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20220201193450.63804C340EC@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


On 2/1/22 14:34, Andrew Morton wrote:
> The patch titled
>       Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
> has been added to the -mm tree.  Its filename is
>       mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
>
> This patch should soon appear at
>      https://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
> and later at
>      https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
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
> ------------------------------------------------------
> From: Waiman Long <longman@redhat.com>
> Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
>
> The gcc 12 compiler reports a warning on the following code:
>
>      static inline struct mem_section *__nr_to_section(unsigned long nr)
>      {
>      #ifdef CONFIG_SPARSEMEM_EXTREME
>          if (!mem_section)
>                  return NULL;
>      #endif
>         :
>
> With CONFIG_SPARSEMEM_EXTREME on, the mem_section definition is
>
>      extern struct mem_section **mem_section;
>
> Obviously, mem_section cannot be NULL, but *mem_section can be if memory
> hasn't been allocated for the dynamic mem_section[] array yet.  Fix this
> warning by checking for "!*mem_section" instead.
>
> Link: https://lkml.kernel.org/r/20220201192924.672675-1-longman@redhat.com
> Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Justin Forbes <jforbes@redhat.com>
> Cc: Rafael Aquini <aquini@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   include/linux/mmzone.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning
> +++ a/include/linux/mmzone.h
> @@ -1390,7 +1390,7 @@ static inline unsigned long *section_to_
>   static inline struct mem_section *__nr_to_section(unsigned long nr)
>   {
>   #ifdef CONFIG_SPARSEMEM_EXTREME
> -	if (!mem_section)
> +	if (!*mem_section)
>   		return NULL;
>   #endif
>   	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
> _
>
> Patches currently in -mm which might be from longman@redhat.com are
>
> mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
> ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch
>
Sorry, this patch isn't complete. I will send out a v2 soon.

Thanks,
Longman

