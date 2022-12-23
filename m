Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32883C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Dec 2022 10:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiLWKDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Dec 2022 05:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiLWKDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Dec 2022 05:03:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CABDEB9
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 02:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671789764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zd08r+/yxBI3QCDz4qTyW7WKzjHtTlULyzjNBHIsEnI=;
        b=Y5jdOTUya+tg2DGUsMRg3NlxOwu7imz2e5uSD6zd+R+wWfei5SgFeMk5BAhFiFA+uDa8ZT
        Vf203h8rAF8U05cwrsnjTjPuac6l6NqTL0Q/GEONfRbF+V7WF/C3aFjT522DOX+BKR0NYd
        tRA5eiq0UqdEelrXX99zZ347yb0UlIg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-392-W7HwMpFUMkGliMPpU3A49w-1; Fri, 23 Dec 2022 05:02:42 -0500
X-MC-Unique: W7HwMpFUMkGliMPpU3A49w-1
Received: by mail-wm1-f69.google.com with SMTP id i7-20020a05600c354700b003d62131fe46so3602464wmq.5
        for <mm-commits@vger.kernel.org>; Fri, 23 Dec 2022 02:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zd08r+/yxBI3QCDz4qTyW7WKzjHtTlULyzjNBHIsEnI=;
        b=aoGg7LAcoU/4ZslUVSCqG/ZJHKSRICMnNvB0bKUWq5zZKjOZUDwQ08vBoY4EMTajPV
         IQ2bJiDw/F2SPAAKgkZ6wnS9uw6XOR/4T8c19F/cTn4V+szXQmINlyHS41apsR6OQCo5
         DBEZoiEoa03cSIDcE8z+J4pa79DoSHlGehVV6H7Anp0yaELGUnDO/66sYS/gla7WaN/u
         mgzI96/kGKdJuoDqYbfkI6Ygcy5QaMqkycHZWwlPZslETjrPhT1XssaC1qOe4K4Jfzx3
         BVcN9RMg6iCLV+GlfSZGfvfdE63yhiN2C0dnl1inEg8sS+X8FoXQ5mQwlSI/XHDgOObm
         9rnw==
X-Gm-Message-State: AFqh2kqGobR8aNipi0jdk4mQejJh43l+2jPPJ4RjD34USBGAa8oYu1xo
        3gNDpDXVNtBx8Jd0zn42rU4LQ50zjnNjJYyG45lzYvdlodhYkadcfxUwJaRihsN9QslqQivv0wP
        Ra1uBFjgp6qwyDlK6zplJUA==
X-Received: by 2002:adf:e40e:0:b0:24f:93fe:dce6 with SMTP id g14-20020adfe40e000000b0024f93fedce6mr5557739wrm.27.1671789761773;
        Fri, 23 Dec 2022 02:02:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvif/NV49KBuhvWmbj+VFqZV9WC0ozWRfyn0bN6lWQowIR6WsdnIAaGZ7uSOB3jV4n16xHJDw==
X-Received: by 2002:adf:e40e:0:b0:24f:93fe:dce6 with SMTP id g14-20020adfe40e000000b0024f93fedce6mr5557719wrm.27.1671789761543;
        Fri, 23 Dec 2022 02:02:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:ab00:3d8e:16c4:a38d:2827? (p200300cbc707ab003d8e16c4a38d2827.dip0.t-ipconnect.de. [2003:cb:c707:ab00:3d8e:16c4:a38d:2827])
        by smtp.gmail.com with ESMTPSA id c4-20020a5d4f04000000b002365cd93d05sm2655632wru.102.2022.12.23.02.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 02:02:41 -0800 (PST)
Message-ID: <b7489609-d9e3-a052-5f29-b948a3e4584e@redhat.com>
Date:   Fri, 23 Dec 2022 11:02:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, nadav.amit@gmail.com,
        ives@codesandbox.io, hughd@google.com, apopple@nvidia.com,
        aarcange@redhat.com
References: <20221210004423.94D4FC433D2@smtp.kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: +
 mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
 added to mm-hotfixes-unstable branch
In-Reply-To: <20221210004423.94D4FC433D2@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 10.12.22 01:44, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch

Andrew, what happened to this fix? I think I'm too blind to spot it 
upstream, in one of your trees or in -next ...

-- 
Thanks,

David / dhildenb

