Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0038DEB64DC
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 02:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjGIC1O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 22:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGIC1N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 22:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97FDD3
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 19:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688869585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ZEVzcRqGDAVcZ/7uZkXopzV20WZLVvlIg4KNCZ+IFQ=;
        b=VB5C+YsN5YENK9CMJwnMibLs/oTBk7HsUym+H4BkGHNjLPKZEyWRSjPfQiR+ycLmQkDlSd
        5WDJc9u9oDNBFoXYBhV26C03qmTSGZNW1hyvUyMJw5Zyi587VCl61i6wJhuJZKP3hsGLMt
        pr9VTlwEXTTs/PSN/7h+QVimZkUKFr8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-3VYi1fxbOweSETx7cB0xJg-1; Sat, 08 Jul 2023 22:26:19 -0400
X-MC-Unique: 3VYi1fxbOweSETx7cB0xJg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C265929AA38A;
        Sun,  9 Jul 2023 02:26:17 +0000 (UTC)
Received: from localhost (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F6142166B25;
        Sun,  9 Jul 2023 02:26:13 +0000 (UTC)
Date:   Sun, 9 Jul 2023 10:26:10 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        willy@infradead.org, will@kernel.org, wangkefeng.wang@huawei.com,
        vgupta@kernel.org, svens@linux.ibm.com,
        stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
        schnelle@linux.ibm.com, rppt@kernel.org, npiggin@gmail.com,
        nathan@kernel.org, mpe@ellerman.id.au, jonas@southpole.se,
        jcmvbkbc@gmail.com, James.Bottomley@hansenpartnership.com,
        hch@lst.de, hca@linux.ibm.com, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, gerald.schaefer@linux.ibm.com,
        geert@linux-m68k.org, deller@gmx.de, David.Laight@aculab.com,
        dalias@libc.org, chris@zankel.net, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        bcain@quicinc.com, arnd@arndb.de, agordeev@linux.ibm.com
Subject: Re: [obsolete] s390-mm-convert-to-generic_ioremap.patch removed from
 -mm tree
Message-ID: <ZKoawnFd7ji96H0q@MiWiFi-R3L-srv>
References: <20230709003856.A3598C433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709003856.A3598C433C7@smtp.kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On 07/08/23 at 05:38pm, Andrew Morton wrote:
......
> --- a/arch/s390/kernel/perf_cpum_sf.c~s390-mm-convert-to-generic_ioremap
> +++ a/arch/s390/kernel/perf_cpum_sf.c
> @@ -22,7 +22,7 @@
>  #include <asm/irq.h>
>  #include <asm/debug.h>
>  #include <asm/timex.h>
> -#include <asm-generic/io.h>
> +#include <asm/io.h>

Only this hunk in arch/s390/kernel/perf_cpum_sf.c is obsolete because 
both below two commits have fixed the direct including of
<asm-generic/io.h> and have been merged into linus's master branch.

51f513fd9659 ("s390/mm: do not include <asm-generic/io.h> directly")
b378a9826143 ("s390: include linux/io.h instead of asm/io.h")

Other than this, the whole patch is still wanted. Do I need to remove
above hunk and repost patch s390-mm-convert-to-generic_ioremap.patch?

Thanks
Baoquan

