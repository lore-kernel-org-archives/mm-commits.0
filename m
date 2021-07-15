Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34E5C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 12:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D503A61380
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 12:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhGOMRi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 08:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbhGOMRh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jul 2021 08:17:37 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0F1C06175F
        for <mm-commits@vger.kernel.org>; Thu, 15 Jul 2021 05:14:44 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id y6so4731973ilj.13
        for <mm-commits@vger.kernel.org>; Thu, 15 Jul 2021 05:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5B8WMESI3kumlgfc1iv795unOe/5BbtUeoQ7RgZ5tLc=;
        b=E8xHqXeIaG2OboSPL8upOxGXuAUWi5hjsTEKJXEZ8nmTL7+0LMj2jQIoaw9DibfgWF
         NwCe5NKC3Ox55LYshAQXQ73RsnFTq7Ezrszn/mwv8aXGfH8wFJJ81NHG3Gp1j7CvcRSs
         ClZ/SRnNIvJVjaV0+Aq8im6RB1tQdr22cwX0zbWYzmrQR0dnWIurmcHCRE9+TjAWUELr
         T7LCKVq9xLACfrRpFZtO7L6ch++fHLfUUQSZTQoI7lQ99HVF6ZSaa7NCgRi8u9vQpTTE
         n7FLUyuLv7lnr+PRWQNO/3bELQJ5M0dH+atA7BLNW5PwbaXreIxHhm3yd7/m/bhMIjhb
         940w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5B8WMESI3kumlgfc1iv795unOe/5BbtUeoQ7RgZ5tLc=;
        b=dVDr+Ev+DcKpBEQEJLhT+qeHktQGhdoqfwglLrwh52RhtabFroyYqSCwo0IDMltHS0
         6Bop1b9qKSa3C1J7ztpR14kWBqUGpGjRpWFhdhnqa1YoYfPWD+OT4eKWepJAqaw7r4cT
         WPcoJCwsGxi7+CkI9Q2aJpMT+Ls/UnpKfCeab49kh/rm+X/Iq3vqZ3HBwDtqLPUKypl8
         gblmhIPaYbHwhFewgTf1rWC6jDUQ9wrom6fB4RoSvQK71fihaX7tEO8eP3XbEATzRJmL
         rx2erlStTPFtkFitPK4xiA2nv4uRDiWlUIRCme3UcGU+Ouu+TUNBBft+tWMW0h1YQ8Bw
         4MKg==
X-Gm-Message-State: AOAM532XRdqMMSIMF6iVgqzBXBps26nqRiI3N0gdDodLhxV6V31OfHol
        9F3ZF95TOi4bdLmAzZhVMh+wFalfJnPaey30nfStfWsKQjWpXw==
X-Google-Smtp-Source: ABdhPJwnGjMUXa8D1qIzQt6+znzKEmcsZTN3MCvG1PCV5M65ND3I70kic5WxwrJV3KwVIPBHJZXY7Uz2vsRaCDWsMss=
X-Received: by 2002:a05:6e02:1947:: with SMTP id x7mr2564865ilu.85.1626351284254;
 Thu, 15 Jul 2021 05:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210714234454.uDqO8_L5c%akpm@linux-foundation.org>
In-Reply-To: <20210714234454.uDqO8_L5c%akpm@linux-foundation.org>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Thu, 15 Jul 2021 14:14:33 +0200
Message-ID: <CAM9Jb+haXyRy20WnuN1eLyzgBj8tvtETV0pmYw_rRaz0qSJ4eA@mail.gmail.com>
Subject: Re: + acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anton Blanchard <anton@ozlabs.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Baoquan He <bhe@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Scott Cheloha <cheloha@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Rich Felker <dalias@libc.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Wang <jasowang@redhat.com>,
        Joe Perches <joe@perches.com>, Jia He <justin.he@arm.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Len Brown <lenb@kernel.org>, Andy Lutomirski <luto@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michel Lespinasse <michel@lespinasse.org>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pankaj Gupta <pankaj.gupta@ionos.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Rapoport <rppt@kernel.org>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Will Deacon <will@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

> The patch titled
>      Subject: ACPI: memhotplug: memory resources cannot be enabled yet
> has been added to the -mm tree.  Its filename is
>      acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: David Hildenbrand <david@redhat.com>
> Subject: ACPI: memhotplug: memory resources cannot be enabled yet
>
> We allocate + initialize everything from scratch.  In case enabling the
> device fails, we free all memory resourcs.
>
> Link: https://lkml.kernel.org/r/20210712124052.26491-5-david@redhat.com
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Anton Blanchard <anton@ozlabs.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jia He <justin.he@arm.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michel Lespinasse <michel@lespinasse.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Nathan Lynch <nathanl@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pankaj Gupta <pankaj.gupta@ionos.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Scott Cheloha <cheloha@linux.ibm.com>
> Cc: Sergei Trofimovich <slyfox@gentoo.org>
> Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/acpi/acpi_memhotplug.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> --- a/drivers/acpi/acpi_memhotplug.c~acpi-memhotplug-memory-resources-cannot-be-enabled-yet
> +++ a/drivers/acpi/acpi_memhotplug.c
> @@ -182,10 +182,6 @@ static int acpi_memory_enable_device(str
>          * (i.e. memory-hot-remove function)
>          */
>         list_for_each_entry(info, &mem_device->res_list, list) {
> -               if (info->enabled) { /* just sanity check...*/
> -                       num_enabled++;
> -                       continue;
> -               }
>                 /*
>                  * If the memory block size is zero, please ignore it.
>                  * Don't try to do the following memory hotplug flowchart.


Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
