Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC39C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 06:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiCKGHa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Mar 2022 01:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241449AbiCKGG5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2022 01:06:57 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92B41B30B5
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 22:05:14 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w4so6851048ply.13
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 22:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:subject:user-agent:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=nPsu3YgxbT5g9w0GNZrK01MjkVSNS+O81p6dBz+xT2k=;
        b=BLMacmKcYL7bZoKq1B82c2GRSwoJ+VHaF6d/jg7oSm7lULBGwW4kQ/5GWf5QYOCTg8
         tDKqB6vrR4Y4XmlEQPy/m35eX23bcdcKD6qc/ZH7kyZIF9TAy0MWlS2KGgq98t8HsdRb
         XHEFGcL1e3gJJyww+2U6vaTohWEGDSx0hWSBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=nPsu3YgxbT5g9w0GNZrK01MjkVSNS+O81p6dBz+xT2k=;
        b=qwRaxL71t5Jd19ef6+YsJPJ88jtSfIcfmUadukcYcCPCIdddtUdwCcdiKUgyaDhG7m
         Vh7mX/dI5ux9Kk0YaJ9JtuTbsFmFHgsye3B4dpf+U7hzm6CtkybTI3TMbZePh3Rh2ned
         Ww+FnrIORSKro40AAttFAsEh8iAJjIDL81+hrMcP42XpeFQKBuPhSwu6SnMi7akuZmEj
         tIwhSXi18LlsgmmXTb+mxTvtdL3ht0ByFDBV/JMkdwAPcEjM1k1g2hcbGxt4xTlwSOXo
         hHzmsfUNcvW0lSUyX6XWwddk6bhgv9Td6/ZaDfdHQlq2HgcQQqDVhwE5ylU8pxULawdW
         9KDg==
X-Gm-Message-State: AOAM533GKvlNc6j4jTWdO9gJeHZNdaPS38NOPZwiUDH3eCakHs0rA0t0
        voza63oCitjMGFNIwxlueNELDA==
X-Google-Smtp-Source: ABdhPJzuPV/26RtCxMp0RlCU/V0AyxDsrqO0AIYhB+UqKIaZZfHtTEC8473jq1aEJvts0YU3DG6XFg==
X-Received: by 2002:a17:90b:1c03:b0:1bf:552e:f4a9 with SMTP id oc3-20020a17090b1c0300b001bf552ef4a9mr9274983pjb.42.1646978714284;
        Thu, 10 Mar 2022 22:05:14 -0800 (PST)
Received: from [127.0.0.1] (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o15-20020a17090a168f00b001bf66741097sm7883086pja.16.2022.03.10.22.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 22:05:13 -0800 (PST)
Date:   Thu, 10 Mar 2022 22:05:11 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, wad@chromium.org, luto@amacapital.net,
        lkp@intel.com, akpm@linux-foundation.org
Subject: Re: + kernel-seccompc-remove-unreachable-code.patch added to -mm tree
User-Agent: K-9 Mail for Android
In-Reply-To: <20220311014341.1F64BC340E8@smtp.kernel.org>
References: <20220311014341.1F64BC340E8@smtp.kernel.org>
Message-ID: <08053C5F-58BB-4D9E-BD70-B245C4BFD3DC@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On March 10, 2022 5:43:40 PM PST, Andrew Morton <akpm@linux-foundation=2Eo=
rg> wrote:
>
>The patch titled
>     Subject: kernel/seccomp=2Ec: remove unreachable code
>has been added to the -mm tree=2E  Its filename is
>     kernel-seccompc-remove-unreachable-code=2Epatch
>
>This patch should soon appear at
>    https://ozlabs=2Eorg/~akpm/mmots/broken-out/kernel-seccompc-remove-un=
reachable-code=2Epatch
>and later at
>    https://ozlabs=2Eorg/~akpm/mmotm/broken-out/kernel-seccompc-remove-un=
reachable-code=2Epatch
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist=2Erst when tes=
ting your code ***
>
>The -mm tree is included into linux-next and is updated
>there every 3-4 working days
>
>------------------------------------------------------
>From: Andrew Morton <akpm@linux-foundation=2Eorg>
>Subject: kernel/seccomp=2Ec: remove unreachable code
>
>kernel/seccomp=2Ec:1321 __secure_computing() warn: ignoring unreachable c=
ode=2E
>
>do_exit() is __noreturn=2E  And if it does return, we fall into the BUG()=
,
>which seems very appropriate=2E
>
>Link: https://lkml=2Ekernel=2Eorg/r/622aa69f=2EXI8McBWG4GX/YDab%25lkp@int=
el=2Ecom

This URL does not work=2E Correct URL seems to be: https://lore=2Ekernel=
=2Eorg/linux-mm/622aa69f=2EXI8McBWG4GX%2FYDab%25lkp@intel=2Ecom/

I assume this is from the c11 change?

>Reported-by: kernel test robot <lkp@intel=2Ecom>
>Cc: Kees Cook <keescook@chromium=2Eorg>
>Cc: Will Drewry <wad@chromium=2Eorg>
>Cc: Andy Lutomirski <luto@amacapital=2Enet>
>Signed-off-by: Andrew Morton <akpm@linux-foundation=2Eorg>
>---
>
> kernel/seccomp=2Ec |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>--- a/kernel/seccomp=2Ec~kernel-seccompc-remove-unreachable-code
>+++ a/kernel/seccomp=2Ec
>@@ -1317,8 +1317,7 @@ int __secure_computing(const struct secc
> 	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible=2E */
> 	case SECCOMP_MODE_DEAD:
> 		WARN_ON_ONCE(1);
>-		do_exit(SIGKILL);
>-		return -1;
>+		do_exit(SIGKILL);	/* This is __noreturn */

This needs to either stay "return -1" or be swapped with an explicit "fall=
through;" statement so this can never fail open no matter what the compiler=
 thinks about optimization, nor any changes to behavior of do_exit()=2E

I'd prefer to fix this via the seccomp tree, regardless=2E

-Kees

> 	default:
> 		BUG();
> 	}
>_
>
>Patches currently in -mm which might be from akpm@linux-foundation=2Eorg =
are
>
>memcg-sync-flush-only-if-periodic-flush-is-delayed-fix=2Epatch
>remove-bdi_congested-and-wb_congested-and-related-functions-fix=2Epatch
>mm=2Epatch
>documentation-vm-page_ownerrst-update-the-documentation-fix=2Epatch
>mm-list_lru-replace-linear-array-with-xarray-fix=2Epatch
>mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix=2Epatch
>mm-export-pageheadhuge-fix=2Epatch
>userfaultfd-provide-unmasked-address-on-page-fault-v3-fix=2Epatch
>mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix=
=2Epatch
>mm-handle-uninitialized-numa-nodes-gracefully-fix=2Epatch
>mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix=2Epatch
>proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix=2Epatch
>taskstats-remove-unneeded-dead-assignment-fix=2Epatch
>kernel-seccompc-remove-unreachable-code=2Epatch
>linux-next-rejects=2Epatch
>linux-next-git-rejects=2Epatch
>mm-oom_killc-fix-vm_oom_kill_table-ifdeffery=2Epatch
>kasan-improve-vmalloc-tests-fix-3-fix=2Epatch
>mm-slightly-clarify-ksm-logic-in-do_swap_page-fix=2Epatch
>mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix=2Epat=
ch
>mutex-subsystem-synchro-test-module-fix=2Epatch
>kernel-forkc-export-kernel_thread-to-modules=2Epatch
>

--=20
Kees Cook
