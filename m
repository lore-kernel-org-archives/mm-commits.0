Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815CCC001E0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjHJQnn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjHJQn2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:43:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A8590
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691685766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MMIOYX0dVcN7Hv8zYl0scBpcigJykHTOFRAOAdovJpw=;
        b=EmlFEPVHv5PQ4WLO1OTLokTaYqlMg+xG1rRRZ7SRo3Q+fOSiRBSJwnOnnA9VfUmlFejl1r
        q4QQp4sZQoE2ea94M9EX1AilXF2w/zozC9w+H7TzenQCXd2YRXrRvDc/Deq3mAH6VJQkk6
        SI8wkERVhH5JGURZVUP1fHKZ1kGOmDo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-Ka7GesgiMeWdAX_ludzXJQ-1; Thu, 10 Aug 2023 12:42:45 -0400
X-MC-Unique: Ka7GesgiMeWdAX_ludzXJQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe13f529f5so7424465e9.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691685764; x=1692290564;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMIOYX0dVcN7Hv8zYl0scBpcigJykHTOFRAOAdovJpw=;
        b=IRo17+3dg3ZT4acXmDFZndB5FWk93Ctpc6Ihp0TC8UR8LONZPhUaDaO89JIJSzwJWz
         /e92nWfqWhA5IjPVaA2sUa3s6orLX2VntUw4ouxrmgAbtBXoc8UEVBWCWKx6ocgpR1kJ
         KuYE1Jm4b87GnVmOtPcYzxU6G2sRW07pCxNdSj1EJUAkBi4F8XYBjGbFtrEEh5tARbzo
         F+tPU7BLUYgf0LwHl/pcJrajvggk28r6PhF5HfVVQiaK5zeaJ59lDlZ9VYQl09BnAn3o
         ZnzwUaNTqh/uMsHssRHFM4DBw3smZyTvHI5v4YhdDVPKjp5GZkQj80L2N3zgY1O7Bn4X
         xF1Q==
X-Gm-Message-State: AOJu0YxSE3b6PMZEyjtV35VmzPJdrt+GYLY+0VtF2TR/GCDdx4kUdp8n
        fHp+5LUzDFFmsJ1xUItVyuo88S6A84I47USbG8v+0LjU1yvx0MxUSGgnQrXVAL3bbGvBjPQo49x
        bN2h0KwMFNpQAUNxVWyUdEw==
X-Received: by 2002:a5d:4b49:0:b0:317:6816:578c with SMTP id w9-20020a5d4b49000000b003176816578cmr2445863wrs.5.1691685764085;
        Thu, 10 Aug 2023 09:42:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNcbIY5yTnEzxX7MI/TszVuiqwg0bkgcPLOmtD6zAZyF64yj6Q/+JXDOGDv7ICgc6U21lKTw==
X-Received: by 2002:a5d:4b49:0:b0:317:6816:578c with SMTP id w9-20020a5d4b49000000b003176816578cmr2445842wrs.5.1691685763651;
        Thu, 10 Aug 2023 09:42:43 -0700 (PDT)
Received: from [192.168.3.108] (p4ff235a1.dip0.t-ipconnect.de. [79.242.53.161])
        by smtp.gmail.com with ESMTPSA id y2-20020adffa42000000b00317e6f06e22sm2679369wrr.77.2023.08.10.09.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 09:42:43 -0700 (PDT)
Message-ID: <279ce23c-8331-2b7c-86d3-b318f2c157af@redhat.com>
Date:   Thu, 10 Aug 2023 18:42:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: + mm-large_anon_folio-for-improved-performance.patch added to
 mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        itaru.kitayama@gmail.com, fengwei.yin@intel.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com
References: <20230810163130.E3D10C433C8@smtp.kernel.org>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230810163130.E3D10C433C8@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.08.23 18:31, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm: LARGE_ANON_FOLIO for improved performance
> has been added to the -mm mm-unstable branch.  Its filename is
>       mm-large_anon_folio-for-improved-performance.patch
> 

It's good to give these patches some early testing in -next.

But let's wait for more review and acks before we pull this into mm-stable.

-- 
Cheers,

David / dhildenb

