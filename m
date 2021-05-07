Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEBCC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 08:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8770A61464
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 08:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhEGIRW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 May 2021 04:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234484AbhEGIRW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2021 04:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620375382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QU5nPCq4OJAv/v6RLOBfbWfNHLCkuq3W/8oOHWi1GtM=;
        b=M1HOlb1Ur2WxxzC8SeQeQpGPD5syYFhRu2JQt2nHD+Dy49LL25rDSWYc+OnLWreS88/JCH
        gpi7L/lflFt4F/7t9gHfNFpfopitXJ5oQX8pUZkAql5bl75RggUzw6YfcvCU4xxZqL/l+C
        cT2vx4g6tDGDcEoUus2WbQBIMDlhAfg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-qRop4h8VPyeuGdlEo1Un-Q-1; Fri, 07 May 2021 04:16:14 -0400
X-MC-Unique: qRop4h8VPyeuGdlEo1Un-Q-1
Received: by mail-wm1-f69.google.com with SMTP id o18-20020a1ca5120000b02901333a56d46eso3637723wme.8
        for <mm-commits@vger.kernel.org>; Fri, 07 May 2021 01:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QU5nPCq4OJAv/v6RLOBfbWfNHLCkuq3W/8oOHWi1GtM=;
        b=eMydIKHI/b4Nel2LOjVnA0/k7xaUEy4BToAXbZQWOOTN6FzuOZ8VVnN+BUnWqBX+ns
         At2g9GeXpMjT/I5rkT6gb335LT6XSoM2Yw7KrKnscx66/tiINfdz1QW+E6MqgKsk7sPk
         7PWB1jiJHR7SFH+v1ZqY65exXbhBox4NoXF3KRTeHTjZm016+8csEaReRdsLwdPibauA
         KgzmyRzGH8BUvPu6jzArfzeZgRf+1sOSK0Sargq9KQxj9kREXCNapxFP44TJNnDX67bU
         cHcnS4U6vz2kDwdSpHi6iLgX9I7G4qwTbZP82+xil/OjkSmFFA7uy4GWG14aCR/nYms1
         1eBg==
X-Gm-Message-State: AOAM5320bMwe0C7EPrpstVMrjabNHSnHcFjrnv3fH3M9sV93yXnyDzC8
        vgWyNGsHPmv51/lXKr+s7ogH48HjW8xMteub3lsmMpqRVHUAyOSB3S58JHyPtgZj8pSZJWMFul7
        HPm//2lp4hm/4I9L9GKLX4A==
X-Received: by 2002:a5d:5989:: with SMTP id n9mr10510552wri.60.1620375372829;
        Fri, 07 May 2021 01:16:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPwlxwGpKSwux7xmomYJp4AJrLdLT8b/gkgFSV2749Azw5aIolat5m1b3QUnWYput7V6ffpg==
X-Received: by 2002:a5d:5989:: with SMTP id n9mr10510515wri.60.1620375372610;
        Fri, 07 May 2021 01:16:12 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c63c0.dip0.t-ipconnect.de. [91.12.99.192])
        by smtp.gmail.com with ESMTPSA id b6sm12050107wmj.2.2021.05.07.01.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 01:16:12 -0700 (PDT)
To:     Andrew Morton <akpm@linux-foundation.org>, andreyknvl@google.com,
        bhe@redhat.com, christian.brauner@ubuntu.com,
        colin.king@canonical.com, corbet@lwn.net, dyoung@redhat.com,
        frederic@kernel.org, gpiccoli@canonical.com,
        john.p.donnelly@oracle.com, jpoimboe@redhat.com,
        keescook@chromium.org, linux-mm@kvack.org, masahiroy@kernel.org,
        mchehab+huawei@kernel.org, mike.kravetz@oracle.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com,
        yifeifz2@illinois.edu
References: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [patch 48/91] kernel/crash_core: add crashkernel=auto for vmcore
 creation
Message-ID: <889c6b90-7335-71ce-c955-3596e6ac7c5a@redhat.com>
Date:   Fri, 7 May 2021 10:16:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210507010432.IN24PudKT%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 07.05.21 03:04, Andrew Morton wrote:
> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
> 
> This adds crashkernel=auto feature to configure reserved memory for vmcore
> creation.  CONFIG_CRASH_AUTO_STR is defined to be set for different kernel
> distributions and different archs based on their needs.
> 
> Link: https://lkml.kernel.org/r/20210223174153.72802-1-saeed.mirzamohammadi@oracle.com
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
> Tested-by: John Donnelly <john.p.donnelly@oracle.com>
> ed-by: Dave Young <dyoung@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Cc: YiFei Zhu <yifeifz2@illinois.edu>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   Documentation/admin-guide/kdump/kdump.rst       |    3 +-
>   Documentation/admin-guide/kernel-parameters.txt |    6 ++++
>   arch/Kconfig                                    |   20 ++++++++++++++
>   kernel/crash_core.c                             |    7 ++++
>   4 files changed, 35 insertions(+), 1 deletion(-)
> 
> --- a/arch/Kconfig~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/arch/Kconfig
> @@ -14,6 +14,26 @@ menu "General architecture-dependent opt
>   config CRASH_CORE
>   	bool
>   
> +config CRASH_AUTO_STR
> +	string "Memory reserved for crash kernel"
> +	depends on CRASH_CORE
> +	default "1G-64G:128M,64G-1T:256M,1T-:512M"
> +	help
> +	  This configures the reserved memory dependent
> +	  on the value of System RAM. The syntax is:
> +	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
> +	              range=start-[end]
> +
> +	  For example:
> +	      crashkernel=512M-2G:64M,2G-:128M
> +
> +	  This would mean:
> +
> +	      1) if the RAM is smaller than 512M, then don't reserve anything
> +	         (this is the "rescue" case)
> +	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
> +	      3) if the RAM size is larger than 2G, then reserve 128M
> +
>   config KEXEC_CORE
>   	select CRASH_CORE
>   	bool
> --- a/Documentation/admin-guide/kdump/kdump.rst~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/Documentation/admin-guide/kdump/kdump.rst
> @@ -285,7 +285,8 @@ This would mean:
>       2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
>       3) if the RAM size is larger than 2G, then reserve 128M
>   
> -
> +Or you can use crashkernel=auto to choose the crash kernel memory size
> +based on the recommended configuration set for each arch.
>   
>   Boot into System Kernel
>   =======================
> --- a/Documentation/admin-guide/kernel-parameters.txt~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/Documentation/admin-guide/kernel-parameters.txt
> @@ -751,6 +751,12 @@
>   			a memory unit (amount[KMG]). See also
>   			Documentation/admin-guide/kdump/kdump.rst for an example.
>   
> +	crashkernel=auto
> +			[KNL] This parameter will set the reserved memory for
> +			the crash kernel based on the value of the CRASH_AUTO_STR
> +			that is the best effort estimation for each arch. See also
> +			arch/Kconfig for further details.
> +
>   	crashkernel=size[KMG],high
>   			[KNL, X86-64] range could be above 4G. Allow kernel
>   			to allocate physical memory region from top, so could
> --- a/kernel/crash_core.c~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
> +++ a/kernel/crash_core.c
> @@ -7,6 +7,7 @@
>   #include <linux/crash_core.h>
>   #include <linux/utsname.h>
>   #include <linux/vmalloc.h>
> +#include <linux/kexec.h>
>   
>   #include <asm/page.h>
>   #include <asm/sections.h>
> @@ -250,6 +251,12 @@ static int __init __parse_crashkernel(ch
>   	if (suffix)
>   		return parse_crashkernel_suffix(ck_cmdline, crash_size,
>   				suffix);
> +#ifdef CONFIG_CRASH_AUTO_STR
> +	if (strncmp(ck_cmdline, "auto", 4) == 0) {
> +		ck_cmdline = CONFIG_CRASH_AUTO_STR;
> +		pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
> +	}
> +#endif
I remember that the original "crashkernel=auto" as once proposed by Red 
Hat people did not receive a warm welcome.

Let me take a look .... oh, there it is from 2009

https://marc.info/?t=125006512600002&r=1&w=2

and then we had it in 2018

https://lkml.org/lkml/2018/5/20/262


The issue I have with this: it's just plain wrong when you take memory 
hotplug into serious account as we see it quite heavily in VMs. You 
don't know what you'll need when building a kernel. Just pass it via the 
cmdline ...

-- 
Thanks,

David / dhildenb

