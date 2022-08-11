Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFAFC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 17:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiHKRBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 13:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbiHKRBJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 13:01:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34153DFA4C
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 09:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660235575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+08WhAtdCCtoiRwgxwlguKyD9e6qvMsgpwSn5573nJo=;
        b=UUDe+X35Jlmminh1nkNKIV5buk+Ka/NiXYcrgiAK5gyAFoeSEBbKLn83w0KwTnflfopB3C
        R8+EGwUAuNtcf8ll3imyGpEL5IH7M0pRs075ox6VJhb4177MrDwcTmN8RI5/ikavdcUXvD
        Cn01meNZ2NEnsenSODWw9ihc2Sg4Gkg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-0tIbc1SVM9GkSCyHgPAVNg-1; Thu, 11 Aug 2022 12:32:54 -0400
X-MC-Unique: 0tIbc1SVM9GkSCyHgPAVNg-1
Received: by mail-wm1-f70.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so1826378wmp.8
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 09:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+08WhAtdCCtoiRwgxwlguKyD9e6qvMsgpwSn5573nJo=;
        b=TJXkP6ZhJsL3CeVWiyFQQR6L/BPKZJk3LnKpeAXCwkx0kDeoo4/FpnElkJNJy7g/z7
         yTUtLoB6j8jdN0HGw3E4BSn+gILLRF5NdL4AK4f3+/aMqchQNKC9sOrFK9aTZqcFIrZy
         Rg7Ohe0jP8GilLAXV10soqkHHgJLGfe2gZExuEOaqj2U1tPZis4VuEInARQf/dgX6V7z
         gxG7LeRaOQfCa8GXuCmqTO28P+VQSQReNFZVcszycE9CCyOkEa6oSX+O81Ad9yLwg3v3
         9+DPrXiocibLqOPz1f1hcKVMBT0/Okyg4BYHSHAd1MHcKEcbsTp7O2QxUNsRGwPtWjlH
         YG3Q==
X-Gm-Message-State: ACgBeo390XnNRJmWPsAIsiBXHiWPBEFrAlj5dLYcnIgSaxWZxSwNVHn+
        mv7TBxeThxBH3nRNVDhEJwyD7IIthgBgxshPTkdNte2RDZW37R5MU62Pzu/y8N89Ojgfb91/hND
        2VsLIZEga1G+IDGWzmY9HWA==
X-Received: by 2002:a5d:6406:0:b0:220:7e54:1bb1 with SMTP id z6-20020a5d6406000000b002207e541bb1mr19456088wru.447.1660235572992;
        Thu, 11 Aug 2022 09:32:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7qdtt28s8hC+zWXpVHYfDeJMBa8HOSS/oq5yYLBlckqNcdNnwqpd4M3Xnvo0tuntIe4+Lsiw==
X-Received: by 2002:a5d:6406:0:b0:220:7e54:1bb1 with SMTP id z6-20020a5d6406000000b002207e541bb1mr19456068wru.447.1660235572705;
        Thu, 11 Aug 2022 09:32:52 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:2e00:4009:47dc:d0e5:dcd2? (p200300cbc7082e00400947dcd0e5dcd2.dip0.t-ipconnect.de. [2003:cb:c708:2e00:4009:47dc:d0e5:dcd2])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d4f05000000b002205a5de337sm19775060wru.102.2022.08.11.09.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 09:32:52 -0700 (PDT)
Message-ID: <632c18c2-d43d-088b-bcbd-69ac96810e9e@redhat.com>
Date:   Thu, 11 Aug 2022 18:32:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: + mm-re-allow-pinning-of-zero-pfns-again.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, willy@infradead.org, hch@lst.de,
        felix.kuehling@amd.com, apopple@nvidia.com, alex.sierra@amd.com,
        alex.williamson@redhat.com
References: <20220810214428.83DF1C433C1@smtp.kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220810214428.83DF1C433C1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.08.22 23:44, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: re-allow pinning of zero pfns (again)
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-re-allow-pinning-of-zero-pfns-again.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-re-allow-pinning-of-zero-pfns-again.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Alex Williamson <alex.williamson@redhat.com>
> Subject: mm: re-allow pinning of zero pfns (again)
> Date: Wed, 10 Aug 2022 10:53:59 -0600
> 
> The below referenced commit makes the same error as 1c563432588d ("mm: fix
> is_pinnable_page against a cma page"), re-interpreting the logic to
> exclude pinning of the zero page, which breaks device assignment with
> vfio.
> 
> To avoid further subtle mistakes, split the logic into discrete tests.
> 
> Link: https://lkml.kernel.org/r/166015037385.760108.16881097713975517242.stgit@omen
> Link: https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen
> Fixes: f25cbb7a95a2 ("mm: add zone device coherent type memory support")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
> Cc: Alex Sierra <alex.sierra@amd.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

