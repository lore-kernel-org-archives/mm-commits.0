Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F43C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 25 Nov 2021 03:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345252AbhKYDRk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 22:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346650AbhKYDPk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Nov 2021 22:15:40 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AD8C061A2D
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 18:52:40 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y13so18942142edd.13
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 18:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qZ9027euDHp/VBRrugN3oJrd5MYyIW1jmvHbsKkHQAU=;
        b=F9KVIqXmXf9Q4rgEmzc2ahegOOauptE7KZI280qva9TjeZ56zH9DgLkftsGZn1SUKv
         ID//DFP22005uzQLBwXWcva+asbJuIwVC2oOzwVwHqjlGK46RhVoMx8znL+8Aey4RbKa
         khWas0v9VCbHsbwNqxYrneEfc4AgAcPBm5rHNoZ5CUeRNsUcDJOr/dt43q9NfKW1PdBh
         h4FRK/EtfYXzmPvwN6JKaCrubgI3QJ/E3FqGqt7IKhn7npDMMS1jGqe1ZR2/Sp+gmavI
         OZbxBxbwRYA2EgGyCJQtwBGsPvWYW7vGO4RdWqNIf+NUzBQLvI7SaPExhxh1hQu1LWgy
         I4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qZ9027euDHp/VBRrugN3oJrd5MYyIW1jmvHbsKkHQAU=;
        b=zbVzg/uDYQ35v7Hr+mVXETlweAKsky19f9heivXx4hTCBa3rOlYvFmUwDz3cuzStnq
         hh2RlnMBW7qtJHlwezSTiJJ2xylQBR/uuoZrL036TlVcegPPkvKinETQWeg2jbaTFAKn
         bneCZL5S9xLuKdvJXbdqGkcS5xbFu14WpQITwQZjfcvKuXRKU415scTmUldmt5XAZbot
         gdoD4s0z1FhIHVcOM0ANNfV2Yu/ATsBvrggwtEFfyutOyZIFVU52afYUxDsZImt6imM3
         p98dhaS8VFpQ7Vb9v/0oKwOmVue6eSo6DWryfVNz7BP2QQ/EUE891Ya2jLxEXFcB27nN
         pq3A==
X-Gm-Message-State: AOAM531YYPlC3MFz/Eoy7rYoicgi9Q/H94Np4F1ZViXEsXrpVjw31GBi
        gWaYOcVFIloQ8USJaSwUnpGDgwCXvZd16xmc878PVQ==
X-Google-Smtp-Source: ABdhPJyZajGoyTz9IYitsT1buoEDPcxyKUxypylpbl5CTZ1LzpovAo7WNDE3C4O3H/wyJXTK5H4BtJ3KMXN0YuYZQ0c=
X-Received: by 2002:a50:fb16:: with SMTP id d22mr34664365edq.367.1637808759515;
 Wed, 24 Nov 2021 18:52:39 -0800 (PST)
MIME-Version: 1.0
References: <20211124234754.l5co34dUK%akpm@linux-foundation.org>
In-Reply-To: <20211124234754.l5co34dUK%akpm@linux-foundation.org>
From:   Pasha Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 24 Nov 2021 21:52:03 -0500
Message-ID: <CA+CK2bBFbR5+NRpRnoBkqenf4iUSbof9nmH5OGESBNS3GW85FQ@mail.gmail.com>
Subject: Re: + mm-page-table-check-fix.patch added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> --- a/mm/page_table_check.c~mm-page-table-check-fix
> +++ a/mm/page_table_check.c
> @@ -19,6 +19,7 @@ static bool __page_table_check_enabled _
>                                 IS_ENABLED(CONFIG_PAGE_TABLE_CHECK_ENFORCED);
>
>  DEFINE_STATIC_KEY_TRUE_RO(page_table_check_disabled);
> +EXPORT_SYMBOL(page_table_check_disabled);
>
>  static int __init early_page_table_check_param(char *buf)
>  {
> @@ -217,6 +218,7 @@ void __page_table_check_pte_set(struct m
>                                      pte_write(pte));
>         }
>  }
> +EXPORT_SYMBOL(__page_table_check_pte_set);

Thanks Andrew!

Pasha
