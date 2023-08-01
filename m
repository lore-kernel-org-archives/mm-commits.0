Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A913FC0015E
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjHASlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjHASlO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA9F2709
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57CED61692
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F406C433C7;
        Tue,  1 Aug 2023 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690915248;
        bh=62TuYQLQ6jbeABuvepSptf+NsiKracHjMsj6utD+YKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O6jLv9ChSPHnDYygaAjHckzpLvlECN2SunYgkYwC/Rv+/MylmlOgjYiqJHZeQhOVK
         4gToHLztsDJlqQFhIl4kPqavqO+yNMEgGE9u+X/NDXdT3v4GV+sJnm6eZbCavdfkY2
         Yt0s97/ZcpyrslulVM0rpXxZfoKkI0zcidnUP9lU=
Date:   Tue, 1 Aug 2023 11:40:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Eric DeVolder <eric.devolder@oracle.com>
Cc:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        ysato@users.sourceforge.jp, xin3.li@intel.com, will@kernel.org,
        tsi@tuyoix.net, tsbogend@alpha.franken.de, tj@kernel.org,
        thunder.leizhen@huawei.com, tglx@linutronix.de,
        svens@linux.ibm.com, sourabhjain@linux.ibm.com,
        sebastian.reichel@collabora.com, samitolvanen@google.com,
        rppt@kernel.org, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
        paul.walmsley@sifive.com, paulmck@kernel.org, palmer@dabbelt.com,
        ojeda@kernel.org, npiggin@gmail.com, ndesaulniers@google.com,
        mpe@ellerman.id.au, mingo@redhat.com, mhiramat@kernel.org,
        masahiroy@kernel.org, linux@armlinux.org.uk,
        linus.walleij@linaro.org, konrad.wilk@oracle.com,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        keescook@chromium.org, juerg.haefliger@canonical.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        hca@linux.ibm.com, hbathini@linux.ibm.com,
        gregkh@linuxfoundation.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        frederic@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
        dal.ias@libc.org, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@linux.ibm.com, boris.ostrovsky@oracle.com,
        bhe@redhat.com, arnd@arndb.de, ardb@kernel.org,
        aou@eecs.berkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com
Subject: Re: +
 kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
 added to mm-nonmm-unstable branch
Message-Id: <20230801114045.f40542d84b38183c267b00e3@linux-foundation.org>
In-Reply-To: <32e8593c-87df-afab-8610-7d3cec64cbba@oracle.com>
References: <20230712191528.70CBFC433C7@smtp.kernel.org>
        <32e8593c-87df-afab-8610-7d3cec64cbba@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 1 Aug 2023 11:30:19 -0500 Eric DeVolder <eric.devolder@oracle.com> wrote:

> What is the proper way to submit a small fix to this series? I would like to submit the following as 
> cleanup.

Please just send it as a regular patch, against linux-next or
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm branch
mm-unstable or against previously-sent patches.

It helps to identify which previously-sent patch is being altered.
