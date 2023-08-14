Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6792DC04A94
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjHNTT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjHNTTf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A09DE65
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E22F651AC
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D346C433C8;
        Mon, 14 Aug 2023 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692040772;
        bh=Jw2HIwsEx9caxW3+M6sTJZzrTOJRsn2RppwMc0JW/Ig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8dm94Gew238fMEtNdRTMoybC42BH9D3//96oUKg4Brkrflm2eJ1AR58eRNtMHDcS
         9XSGHg0QTkDIJqpp+ELHC4a7J9rH91HFWfK1OLMSHYUZ4Tlc+Zjv8IXhRzO+oobv79
         PsXY6XlkZYW6q9ZtJHmTZWnRku6R9Br+WzoxW80E=
Date:   Mon, 14 Aug 2023 12:19:29 -0700
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
Subject: Re: [merged mm-nonmm-stable]
 kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec.patch
 removed from -mm tree
Message-Id: <20230814121929.5d93ca775a85732c98aaeda1@linux-foundation.org>
In-Reply-To: <eb3df6ae-c713-9b42-e6ae-562e0cefdd4b@oracle.com>
References: <20230812220523.89DECC433C9@smtp.kernel.org>
        <eb3df6ae-c713-9b42-e6ae-562e0cefdd4b@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 14 Aug 2023 07:08:34 -0500 Eric DeVolder <eric.devolder@oracle.com> wrote:

>  From automated email on Friday, I see that v27 of the crash hotplug series was picked up, thank you!
> I have been watching the mm-nonmm-unstable branch and I do wonder when that v27 will show up there? 
> It still has v26 which has build issues related to PROC_KCORE.

It turns up when I type "git push", which I did yesterday ;)

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-move-a-few-code-bits-to-setup-support-of-crash-hotplug.patch
