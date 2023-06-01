Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF166C7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjFAWEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjFAWES (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:04:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9A6180
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:04:17 -0700 (PDT)
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B545E1EC0657;
        Fri,  2 Jun 2023 00:04:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1685657055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xjyhM7Lql5Oe+oCbUv9WJQRNhOQRzzSUE9nYIWKh8lU=;
        b=fC/6pfbi229Zjw+VmYH54aZ5NSC2Exmbg8klagUJzhuvnURy+/997JnfU6UFCaUSoyU24e
        45gMg1sEPej/AvYp/lsSTYFkU7BCERKdgLAqohRCgYppU9eT/oAY8e9uFtUz9sCXAwzn+3
        u4mMt49M/qSlDZc3it/5Hg/OcSNw6LA=
Date:   Fri, 2 Jun 2023 00:04:10 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        tim.gardner@canonical.com, thomas.lendacky@amd.com,
        tglx@linutronix.de, seanjc@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, rppt@linux.ibm.com,
        rientjes@google.com, peterz@infradead.org, peterx@redhat.com,
        pbonzini@redhat.com, mingo@redhat.com, mgorman@techsingularity.net,
        marcelo.cerri@canonical.com, luto@kernel.org,
        liam.merwick@oracle.com, jroedel@suse.de, dfaggioli@suse.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dave.hansen@intel.com, bp@suse.de, ardb@kernel.org,
        ak@linux.intel.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com
Subject: Re: + x86-boot-compressed-handle-unaccepted-memory.patch added to
 mm-unstable branch
Message-ID: <20230601220410.GGZHkV2juLtRq4uaJw@fat_crate.local>
References: <20230601214841.55DFAC433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230601214841.55DFAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jun 01, 2023 at 02:48:40PM -0700, Andrew Morton wrote:
>  arch/x86/boot/compressed/efi.h   |   10 ++++++++
>  arch/x86/boot/compressed/kaslr.c |   35 +++++++++++++++++++----------
>  arch/x86/boot/compressed/mem.c   |   31 +++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.c  |    7 +++++
>  arch/x86/boot/compressed/misc.h  |    6 ++++
>  5 files changed, 77 insertions(+), 12 deletions(-)

Andrew, please drop at least the x86 bits from your tree.

There's other TDX stuff which would conflict with this in tip and, more
importantly, the AMD side of unaccepted memory needs to go in together:

https://lore.kernel.org/r/cover.1684513813.git.thomas.lendacky@amd.com

If you wanna pick up the mm bits and give us an immutable branch which
we can merge, that would be ok. But please don't take x86 bits through
your tree.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
