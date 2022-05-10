Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79450C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 09:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbiEJKCt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 06:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239434AbiEJKCr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 06:02:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0981654BD
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 02:58:48 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n10so31852095ejk.5
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 02:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=63fEozEBLiDM6Sr79aQX2sJEP+RCXqU99tHKBIk7PD8=;
        b=UJB0wqCGsUbCT/g4y8CKYkKvScsp2CyA5IgHnMtgVCfUOS4A04aDgsFqzdYIndW+H4
         +kHOylgB6OxWh7lbDjjFgeznAZnmhy0uM8mEmEXUNK29zYHwoZpORKgAqLEytIr5S345
         IMgQKh4HvvE16kgXV0SUa0XSHOgjO0YG21ul9ReJ7aoU9p18UXY1FqxY3hOwAiMIbn5N
         4a5S6BKiXzPSQc/kyxjpTw8aTKrGQsrUvc+NuCCSGsVSahfUiVSvuiw6LTwn3XPGe6Pq
         KyzKD5HAtP+fSn+v3ifbTKqLGaM45VP3AwlDQt2/UkumGZOQiYeq0LtEnUdNv2sb1RCB
         zO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=63fEozEBLiDM6Sr79aQX2sJEP+RCXqU99tHKBIk7PD8=;
        b=ySbrTTgvT/Gs3sfsKpfKWgNxqTnJNvtE7axteGRJF/lwzRWPfbiYWHRGq49r/e01hD
         gBq1whYNTq/JFxZ9/aO8v1PG9dTY7QDMybk0VjAILX1fzhPVpkH01Fbp/xxrC6ZGhdg2
         hlFAh6qG4Ois/7lBKiDMxR8mAWSFIltFpdPJoqNTr09KGLNyFpKeckUMsdXx/NJCkaoW
         4D0WuusHJknsYJTuGVkxLcb1034/JQIUcLZRRKIsKiE/nFsE1YUdIyKf3H99tkiG75bb
         Mv39zNWdiUP0arrS/YOkQlMZgHwgw62RXw53X+IjiP4E0Xz8NWBnTu4ldB/eO2L/gLtQ
         C9BA==
X-Gm-Message-State: AOAM531028uXaq9zsdgFSwDPX9S9TNwZs+UupAKieRdyzltQXiiBlAs+
        FozCa8/Wjy4b75fxJ+A6gunCAFVpyrw=
X-Google-Smtp-Source: ABdhPJy5TOeX6jgbaunOyDhTxjY/cczD2xhokOZOzun1JTtE81jtxr394JftMWzlIhkLB4cUzzYOPA==
X-Received: by 2002:a17:907:11c7:b0:6f3:941a:83c2 with SMTP id va7-20020a17090711c700b006f3941a83c2mr19026498ejb.33.1652176726961;
        Tue, 10 May 2022 02:58:46 -0700 (PDT)
Received: from leap.localnet (host-79-53-109-4.retail.telecomitalia.it. [79.53.109.4])
        by smtp.gmail.com with ESMTPSA id rb48-20020a170907693000b006f3ef214deesm5970922ejc.84.2022.05.10.02.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 02:58:44 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Subject: Re: [merged mm-stable] mm-highmem-vm_bug_on-if-offset-len-page_size.patch removed from -mm tree
Date:   Tue, 10 May 2022 11:58:43 +0200
Message-ID: <10077676.nUPlyArG6x@leap>
In-Reply-To: <20220510041528.E53C7C385C2@smtp.kernel.org>
References: <20220510041528.E53C7C385C2@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On marted=C3=AC 10 maggio 2022 06:15:28 CEST Andrew Morton wrote:
>=20
> The quilt patch titled
>      Subject: mm/highmem: VM_BUG_ON() if offset + len > PAGE_SIZE
> has been removed from the -mm tree.  Its filename was
>      mm-highmem-vm_bug_on-if-offset-len-page_size.patch
>=20
> This patch was dropped because it was merged into mm-stable
>=20
> ------------------------------------------------------
> From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
> Subject: mm/highmem: VM_BUG_ON() if offset + len > PAGE_SIZE
>=20
> Add VM_BUG_ON() bounds checking to make sure that, if "offset + len>
> PAGE_SIZE", memset() does not corrupt data in adjacent pages.
>=20
> Mainly to match all the similar functions in highmem.h.
>=20
> Link: https://lkml.kernel.org/r/20220426193020.8710-1-fmdefrancesco@gmail=
=2Ecom
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Peter Collingbourne <pcc@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  include/linux/highmem.h |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- a/include/linux/highmem.h~mm-highmem-vm_bug_on-if-offset-len-
page_size
> +++ a/include/linux/highmem.h
> @@ -358,6 +358,8 @@ static inline void memcpy_to_page(struct
>  static inline void memzero_page(struct page *page, size_t offset, size_t=
=20
len)
>  {
>  	char *addr =3D kmap_local_page(page);
> +
> +	VM_BUG_ON(offset + len > PAGE_SIZE);
>  	memset(addr + offset, 0, len);
>  	flush_dcache_page(page);
>  	kunmap_local(addr);
> _
>=20
> Patches currently in -mm which might be from fmdefrancesco@gmail.com are
>=20
>=20
>=20
Hello Andrew,

I still see that the list of my patches currently in -mm is empty.

On April 28th I sent v4 of a series.[1] It received two "Reviewed-by" tags,
respectively from Ira Weiny[2] and Sebastian Andrzej Siewior.[3]

Therefore, I assume that the v4 of the series can be considered final. Can
you please take a look at it and either apply to -mm or let me know if
there is anything which should still be improved?

Thank you very much,

=46abio M. De Francesco

[1] [PATCH v4 0/4] Extend and reorganize Highmem's documentation
https://lore.kernel.org/lkml/20220428212455.892-1-fmdefrancesco@gmail.com/
https://lore.kernel.org/lkml/20220428212455.892-2-fmdefrancesco@gmail.com/
https://lore.kernel.org/lkml/20220428212455.892-3-fmdefrancesco@gmail.com/
https://lore.kernel.org/lkml/20220428212455.892-4-fmdefrancesco@gmail.com/
https://lore.kernel.org/lkml/20220428212455.892-5-fmdefrancesco@gmail.com/

[2] Reviewed-by: Ira Weiny <ira.weiny@intel.com> (for the series)
https://lore.kernel.org/lkml/Ym4WSstEQI7yYU0n@iweiny-server/

[3] Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de> (for the=
=20
series)
[3] https://lore.kernel.org/lkml/YmuK79YPRAi0fHhH@linutronix.de/


