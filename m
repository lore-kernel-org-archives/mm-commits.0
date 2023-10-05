Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364AFE9270A
	for <mm-commits@archiver.kernel.org>; Thu,  5 Oct 2023 14:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbjJEOnw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbjJEOlm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Oct 2023 10:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FD22708
        for <mm-commits@vger.kernel.org>; Thu,  5 Oct 2023 07:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696515264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Bi66j3k4ynnWKgb81nCxW5uhFN2nM8BDT+nUoM2MKQ=;
        b=Q5MdI3yhR3mF7OQCiVAzO1KORhaSFn30mGWG4QIVgj6SC2vxIFXGym5z1xFJsRWalXuqol
        EyujBtpRPqWzeX0zgxvvfnaMuHLe7pl7uwg9er5mByZlRnBW7YNK6mbRatdJNp7a/LcNRP
        AZnpCndvXvK4bbbE189PYc7u62IkQJs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-3gJ2NiJAN1muS8IS5k6P3w-1; Thu, 05 Oct 2023 04:12:31 -0400
X-MC-Unique: 3gJ2NiJAN1muS8IS5k6P3w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40566c578b7so5173535e9.0
        for <mm-commits@vger.kernel.org>; Thu, 05 Oct 2023 01:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696493550; x=1697098350;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Bi66j3k4ynnWKgb81nCxW5uhFN2nM8BDT+nUoM2MKQ=;
        b=qCO9l2CtAH5gmf6rwA0yy9AUivXrw8tlBqJY1mw5wvrsBo05KVOYK50DpmmKgu0aHc
         YauAO+VitHEp5lQO4L4wFxf+MeHQ7hm0FNL2VTv4LHgTSiCRap9mGZbodCm+4blxRThh
         W5IuRvEcnc9khh4G5QFxCKQgjImBBw91Fe6S2Qtj8Umjm17mP5RQqYYXB8KltunaRUw4
         uR8t+SLTAKz0fiMz+TU7qTYRqTNjipT3NJbDPvUFOFNeqTII/qM9KraYTVh6lMVLEszz
         BZysdIz5IFJ68Y0VcEMOOBe+WfnFCpzjQhVTpsGkx9OaF1lf7CLMM+IxvXK4LQWu+WdK
         ypZQ==
X-Gm-Message-State: AOJu0Yy3xNtVZS0h9xOz8kqTz6hM4IUlqyJN3+dwH4YBrHam6cuNcXzd
        nl6BpwIl7KnsvCLg19gW7RZAA5Z0MbzzeLylK3assJ3f3N8Lxrx7vmrt9H2G63NJHvRJqb0rFlj
        4wOgcKrf4w5iRo+ZMv3z33Q==
X-Received: by 2002:adf:db50:0:b0:327:d08a:1fb3 with SMTP id f16-20020adfdb50000000b00327d08a1fb3mr3962211wrj.35.1696493550411;
        Thu, 05 Oct 2023 01:12:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXyzVX/rCtRMnqeVxerQpvmINBqYp9ORX3SDaeC4SkbHnbCP+OZicAIqrP+6ta8R2kz5S7ww==
X-Received: by 2002:adf:db50:0:b0:327:d08a:1fb3 with SMTP id f16-20020adfdb50000000b00327d08a1fb3mr3962186wrj.35.1696493550030;
        Thu, 05 Oct 2023 01:12:30 -0700 (PDT)
Received: from [192.168.3.108] (p4ff231b6.dip0.t-ipconnect.de. [79.242.49.182])
        by smtp.gmail.com with ESMTPSA id x6-20020adff0c6000000b003233b554e6esm1163542wro.85.2023.10.05.01.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 01:12:29 -0700 (PDT)
Message-ID: <63426190-5865-970f-773f-cce33a8209d1@redhat.com>
Date:   Thu, 5 Oct 2023 10:12:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: +
 mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch added to
 mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com
References: <20230929190832.CBFFBC433C7@smtp.kernel.org>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230929190832.CBFFBC433C7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 29.09.23 21:08, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm: non-pmd-mappable, large folios for folio_add_new_anon_rmap()
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
> 

Andrew, please don't move these patches to stable before we have a 
couple of acks from people involved in the discussions.

I'm confident that we'll get them into 6.8. Not so sure about 6.7.

Besides, there are still other things to be sorted out to make this 
actually consumable: As the cover letter reads:

"
NOTE: These changes should not be merged until the prerequisites are 
complete.
These are in progress and tracked at [7].
"

Again, I am happy to see them in mm-unstable early.

-- 
Cheers,

David / dhildenb

