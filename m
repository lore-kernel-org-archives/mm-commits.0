Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D6CC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 21:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E6C724078
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 21:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392907AbgLKTbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 14:31:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391593AbgLKTbD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 14:31:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607714976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7DWo0EZVCUjQuatX1aZ/tjq8qJriPOVmsSkf2Jk6X08=;
        b=b1VvMbTMDyP+ehU7eCeCxoFlzUgizW9tBtsEOC5szhukvd+ar0iYAAEuSGX3AvZDskZtqS
        nrePjPJtlMjpm0yXBXlCbbMlakROiq+Sp/FKRnvPTKNOhnl6xqUlHiIYJFkUjTYp80s6s7
        8tGaSLpuUrIYSCg0luVQ6idnyP3/X/E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-_H4dBo0VMqWcHiZMl2mbBA-1; Fri, 11 Dec 2020 14:29:33 -0500
X-MC-Unique: _H4dBo0VMqWcHiZMl2mbBA-1
Received: by mail-wr1-f69.google.com with SMTP id z6so3679150wrl.7
        for <mm-commits@vger.kernel.org>; Fri, 11 Dec 2020 11:29:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=7DWo0EZVCUjQuatX1aZ/tjq8qJriPOVmsSkf2Jk6X08=;
        b=VPHN0KtYfLnJmNQMVsr0qnqiTb0zU4SqdkExMn6j0yrRoGZgx5iHyI2IjibIOcQ4DP
         USUMia1/7HS9w8NmKF8c74ZlwV47jPZweh2gXk7BYhTzkmeOjrO98AjiFZgU9uJE/j4T
         cS6fqFHHXeGRLhDO0tOpwN/caBR5Apk2v7ybplRpCrIoiaMifdbOKwxIeQdB+02zeErU
         1QLlB7P+RGrkLrPfDKCdOY940vhYY+k25qqEg7nAz/qa9wmlDPq8jJUr+5CaqxqnUC6+
         GBhpsRsVaa9fDS7+734lzK/FtCxUUk1hcxXf6bSX2mk6E1egFYNf7vM8o8b9NOYPEDfC
         pYyw==
X-Gm-Message-State: AOAM531vhYx3ed5uuQ1dcgIw6E/0Ui0Fr0cmhxCIoc+7Ulg/mPywRfRe
        ZXD8deS3wxcHS8WQeVhTMYyERDvXurWWIgd5cDpaSQ5+SyAGZJp5QVkuDKkn9JMEe6B24sG2wmT
        aX01p4QkxqEvu5j0vSz5dew==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr15139357wmb.83.1607714972222;
        Fri, 11 Dec 2020 11:29:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7dYE0YcBr5aSxY0nlf5Pt+s9vz1GfXSO6nnC6+Nn/uBKNSDxK97H8n5eRjVtYShvZv2Hy6g==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr15139341wmb.83.1607714971991;
        Fri, 11 Dec 2020 11:29:31 -0800 (PST)
Received: from [192.168.3.114] (p4ff23c7c.dip0.t-ipconnect.de. [79.242.60.124])
        by smtp.gmail.com with ESMTPSA id d191sm16339124wmd.24.2020.12.11.11.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 11:29:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: + mm-memory_hotplug-quieting-offline-operation.patch added to -mm tree
Date:   Fri, 11 Dec 2020 20:29:30 +0100
Message-Id: <0E6A5718-F2F7-45F6-8C13-504BA57164AE@redhat.com>
References: <20201211192603.F38pDKsAo%akpm@linux-foundation.org>
Cc:     cheloha@linux.ibm.com, david@redhat.com, ldufour@linux.ibm.com,
        mm-commits@vger.kernel.org, nathanl@linux.ibm.com
In-Reply-To: <20201211192603.F38pDKsAo%akpm@linux-foundation.org>
To:     akpm@linux-foundation.org
X-Mailer: iPhone Mail (18B92)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


> Am 11.12.2020 um 20:26 schrieb akpm@linux-foundation.org:
>=20
> =EF=BB=BF
> The patch titled
>     Subject: mm/memory_hotplug: quieting offline operation
> has been added to the -mm tree.  Its filename is
>     mm-memory_hotplug-quieting-offline-operation.patch
>=20
> This patch should soon appear at
>    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-quieting-of=
fline-operation.patch
> and later at
>    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-quieting-of=
fline-operation.patch
>=20
> Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testin=
g your code ***
>=20
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>=20
> ------------------------------------------------------
> From: Laurent Dufour <ldufour@linux.ibm.com>
> Subject: mm/memory_hotplug: quieting offline operation
>=20
> On PowerPC, when dymically removing memory from a system we can see in the=

> console a lot of messages like this:
>=20
> [  186.575389] Offlined Pages 4096
>=20
> This message is displayed on each LMB (256MB) removed, which means that we=

> removing 1TB of memory, this message is displayed 4096 times.
>=20
> Moving it to DEBUG to not flood the console.
>=20
> Link: https://lkml.kernel.org/r/20201211150157.91399-1-ldufour@linux.ibm.c=
om
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nathan Lynch <nathanl@linux.ibm.com>
> Cc: Scott Cheloha <cheloha@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20

Useful for virtio-mem as well.

Reviewed-by: David Hildenbrand <david@redhat.com>

> mm/memory_hotplug.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/mm/memory_hotplug.c~mm-memory_hotplug-quieting-offline-operation
> +++ a/mm/memory_hotplug.c
> @@ -1569,7 +1569,7 @@ int __ref offline_pages(unsigned long st
>=20
>    /* Mark all sections offline and remove free pages from the buddy. */
>    __offline_isolated_pages(start_pfn, end_pfn);
> -    pr_info("Offlined Pages %ld\n", nr_pages);
> +    pr_debug("Offlined Pages %ld\n", nr_pages);
>=20
>    /*
>     * The memory sections are marked offline, and the pageblock flags
> _
>=20
> Patches currently in -mm which might be from ldufour@linux.ibm.com are
>=20
> mm-memory_hotplug-quieting-offline-operation.patch
>=20

