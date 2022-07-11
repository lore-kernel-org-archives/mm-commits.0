Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE71C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Jul 2022 11:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiGKLnI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiGKLmr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2022 07:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 829C4BC11
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 04:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657539438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJjZ9RfDWh1zXLXVBEQs5Pza3aLafmcYnsa1CbclB3M=;
        b=EzNT2IbyYsWXpOUJCbD9gsmPGVjufkSE7yI3z46rxdfRwyy+1epj/fN83ys5j338LNig8Y
        Adbpj1qaxEKwuCwXiFqIcpoYPcV6bfA6wu8HjAGjHTbfd1dCiZC8ibqns799GCCfCQ9/P8
        pd5SwJk3vvrV5ri6d4JtbKAjFyHSK88=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-7bH6xw5UNuaI1RDuLuFATQ-1; Mon, 11 Jul 2022 07:37:17 -0400
X-MC-Unique: 7bH6xw5UNuaI1RDuLuFATQ-1
Received: by mail-wm1-f71.google.com with SMTP id c17-20020a7bc011000000b003a2bfaf8d3dso2638762wmb.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Jul 2022 04:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=WJjZ9RfDWh1zXLXVBEQs5Pza3aLafmcYnsa1CbclB3M=;
        b=Rf5uigvGCf9KEBhLh3uHERErMNS2be5OiaI2u4uTwRQw7hhxYvQBvQKLWvAD0i3wLF
         k251cjNHY6D6wEj/WM3XR844gH9YgWc9XSJB7x2lld8eB3jE7gE7j9ORy0creFGZ2hEG
         Ylb1kHUeGsCoSIPkyPIfjKXgC2qGUiIeMsQnDr18GmUGkaPy8OLn0utwqtKe7IIMhJRj
         k8tb2iui77J7QwQKFbgrByXY6rkbslkEnlZ1gHYNY8Js2sSBhxfyiOuLVd60dh9CPXj0
         Py764yz1C0O9jbYqV0hEFMl8/WDhywQVl5YeN6rBB94PxEw1FMxKFrcM/ssr8cJVNgBx
         2L8g==
X-Gm-Message-State: AJIora80Onjkiip/dnAWvsTY0mS5Jx8LWRUK8ELTeFqVBVhTQuVaJ7/d
        NiswLv+ghsyLhuhhTAlOC0e1tutwhxERk3v7lV4G+rRLYtmie70jklCvjgDEUzT6DifbXJAtYCm
        Ju5pclJBTx6RskXfRDH5tZA==
X-Received: by 2002:a05:6000:2a8:b0:21d:8c81:7eb0 with SMTP id l8-20020a05600002a800b0021d8c817eb0mr15875099wry.460.1657539436386;
        Mon, 11 Jul 2022 04:37:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s2MokIJfH5KEdYY+v6DetK2oEneWaUMxMg+VhXpINE6GAL274FALDnR51af+4AbfdDfNO83w==
X-Received: by 2002:a05:6000:2a8:b0:21d:8c81:7eb0 with SMTP id l8-20020a05600002a800b0021d8c817eb0mr15875082wry.460.1657539436139;
        Mon, 11 Jul 2022 04:37:16 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:1400:c3:4ae0:6d5c:1ab2? (p200300cbc702140000c34ae06d5c1ab2.dip0.t-ipconnect.de. [2003:cb:c702:1400:c3:4ae0:6d5c:1ab2])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6da3000000b0021d66cf9547sm6954879wrs.0.2022.07.11.04.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 04:37:15 -0700 (PDT)
Message-ID: <ae8bed4c-5e12-2eb6-1e87-0d2783da38b9@redhat.com>
Date:   Mon, 11 Jul 2022 13:37:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: +
 mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch
 added to mm-hotfixes-unstable branch
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        hch@lst.de, apopple@nvidia.com, alex.sierra@amd.com
References: <20220624193843.30AECC34114@smtp.kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220624193843.30AECC34114@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 24.06.22 21:38, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/rmap: fix dereferencing invalid subpage pointer in try_to_migrate_one()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-dereferencing-invalid-subpage-pointer-in-try_to_migrate_one.patch
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

Andrew, can we make sure to get this into 5.19?


-- 
Thanks,

David / dhildenb

